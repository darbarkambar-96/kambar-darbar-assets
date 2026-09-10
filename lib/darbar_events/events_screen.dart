import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  static const String masterAdminEmail = 'darbarkambar@gmail.com';
  static const int maxDailyRefreshes = 6;

  late Future<List<SimpleEvent>> _eventsFuture;
  final ScrollController _scrollController = ScrollController();
  bool _isAdmin = false;
  List<SimpleEvent> _loadedEvents = [];

  DateTime _currentCalendarMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime? _selectedCalendarDate;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _currentCalendarMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _checkAdminAccess();
    _eventsFuture = fetchCentralEvents(isManualRefresh: false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<void> _checkAdminAccess() async {
    final SharedPreferences prefs = await _prefs;
    final String? localEmail = prefs.getString('user_email');
    final String? authEmail = FirebaseAuth.instance.currentUser?.email;

    final effectiveEmail = authEmail ?? localEmail;
    if (mounted) {
      setState(() {
        _isAdmin = (effectiveEmail != null &&
            effectiveEmail.trim().toLowerCase() == masterAdminEmail.toLowerCase());
      });
    }
  }

  // Detects newly added events and triggers system notification
  Future<void> _checkForNewEventsAndNotify(
      List<SimpleEvent> incomingEvents, SharedPreferences prefs) async {
    final List<String> knownSignatures =
        prefs.getStringList('known_event_signatures') ?? [];
    final int lang = languageNotifier.value;

    // First run initialization: record initial events so devotees are not spammed on first install
    if (knownSignatures.isEmpty) {
      final allSignatures = incomingEvents.map((e) => e.signature).toList();
      await prefs.setStringList('known_event_signatures', allSignatures);
      return;
    }

    final List<SimpleEvent> newlyAdded = [];
    final List<String> updatedSignatures = List<String>.from(knownSignatures);

    for (final event in incomingEvents) {
      if (!knownSignatures.contains(event.signature)) {
        newlyAdded.add(event);
        updatedSignatures.add(event.signature);
      }
    }

    if (newlyAdded.isNotEmpty) {
      await prefs.setStringList('known_event_signatures', updatedSignatures);

      for (final event in newlyAdded) {
        final String title =
        lang == 0 ? "New Darbar Event Announced!" : "दरबार उत्सव की घोषणा!";
        final String name = lang == 0 ? event.nameEn : event.nameHi;
        final String body = "$name\n${event.readableDate} • ${event.time}";
        await showDarbarEventNotification(title: title, body: body);
      }
    }
  }

  // Dual-Tier Architecture: 1 mandatory daily check + 6 capped manual refreshes
  Future<List<SimpleEvent>> fetchCentralEvents({bool isManualRefresh = false}) async {
    final SharedPreferences prefs = await _prefs;
    final String today = DateTime.now().toIso8601String().substring(0, 10);
    final String? cachedJson = prefs.getString('cached_events_list');
    final String lastFetchDate = prefs.getString('last_calendar_fetch_date') ?? '';

    // 1. Instantly render from local cache if available (0 reads)
    if (cachedJson != null && _loadedEvents.isEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(cachedJson);
        _loadedEvents = _sortEventsChronologically(
          decoded
              .map((item) =>
              SimpleEvent.fromJson(Map<String, dynamic>.from(item as Map)))
              .toList(),
        );
      } catch (e) {
        debugPrint("Local cache parse warning: $e");
      }
    }

    // 2. Tab Navigation Check: If already synced today and not a manual refresh, do NOT hit Firebase
    if (!isManualRefresh) {
      if (lastFetchDate == today && _loadedEvents.isNotEmpty) {
        return _loadedEvents;
      }
    } else {
      // 3. Manual Refresh Check: Enforce daily 6-refresh governor
      final String governorDate = prefs.getString('events_governor_date') ?? '';
      int currentCount = prefs.getInt('events_refresh_count') ?? 0;

      if (governorDate != today) {
        currentCount = 0;
        await prefs.setString('events_governor_date', today);
        await prefs.setInt('events_refresh_count', 0);
      }

      if (currentCount >= maxDailyRefreshes) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Daily cloud refresh limit reached (6/6). Showing saved data."),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return _loadedEvents;
      }

      await prefs.setInt('events_refresh_count', currentCount + 1);
    }

    // 4. Single Document Network Query
    try {
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('calendar')
          .doc('current_events')
          .get(const GetOptions(source: Source.serverAndCache));

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        final List<dynamic>? rawList = data['events_list'];

        if (rawList != null && rawList.isNotEmpty) {
          final list = rawList.map((item) {
            final map = Map<String, dynamic>.from(item as Map);
            return SimpleEvent.fromJson(map);
          }).toList();

          _loadedEvents = _sortEventsChronologically(list);
          await prefs.setString('cached_events_list', jsonEncode(rawList));
          await prefs.setString('last_calendar_fetch_date', today);

          // Trigger push notification if new events are detected
          await _checkForNewEventsAndNotify(_loadedEvents, prefs);

          return _loadedEvents;
        }
      }
    } catch (e) {
      debugPrint("Firestore fetch error: $e");
    }

    if (_loadedEvents.isEmpty) {
      _loadedEvents = _sortEventsChronologically(_getDefaultEvents());
    }
    return _loadedEvents;
  }

  List<SimpleEvent> _getDefaultEvents() {
    final currentYear = DateTime.now().year;
    return [
      SimpleEvent(
        nameEn: "Sai Vilayatrai Sahib Barsi Utsav",
        nameHi: "साईं विलायतराय साहिब बरसी उत्सव",
        date: "$currentYear-01-14",
        time: "10:00 AM & 07:00 PM",
        imageUrl: "assets/img/top2.png",
      ),
      SimpleEvent(
        nameEn: "Sai Jiwatsingh Sahib Janam & Barsi",
        nameHi: "साईं जीवतसिंह साहिब प्रकाश व बरसी पर्व",
        date: "$currentYear-01-15",
        time: "Morning Aarti & Guru Langar",
        imageUrl: "assets/img/vjvlogo.png",
      ),
      SimpleEvent(
        nameEn: "Cheti Chand Celebrations",
        nameHi: "चेटीचंड महोत्सव (सिंधी नववर्ष)",
        date: "$currentYear-03-20",
        time: "Behrana Sahib & Maha Aarti",
        imageUrl: "assets/img/vjvlogo.png",
      ),
      SimpleEvent(
        nameEn: "Guru Purnima Celebrations",
        nameHi: "गुरु पूर्णिमा पावन उत्सव",
        date: "$currentYear-07-29",
        time: "Special Dhuni & Satsang",
        imageUrl: "assets/img/vjvlogo.png",
      ),
      SimpleEvent(
        nameEn: "Chaliha Sahib Mahotsav",
        nameHi: "चालीहा साहिब महोत्सव",
        date: "$currentYear-08-15",
        time: "07:00 AM & 07:30 PM",
        imageUrl: "assets/img/vjvlogo.png",
      ),
      SimpleEvent(
        nameEn: "Sai Vishindas Sahib Barsi Utsav",
        nameHi: "साईं विशिनदास साहिब बरसी उत्सव",
        date: "$currentYear-10-25",
        time: "Akhand Dhuni & Bhajan Sandhya",
        imageUrl: "assets/img/top1.png",
      ),
      SimpleEvent(
        nameEn: "Annual Diwali Mela",
        nameHi: "वार्षिक दीपावली मेला",
        date: "$currentYear-11-08",
        time: "Full Day Mela & Ardas",
        imageUrl: "assets/img/DadiGopi.png",
      ),
    ];
  }

  List<SimpleEvent> _sortEventsChronologically(List<SimpleEvent> events) {
    final list = List<SimpleEvent>.from(events);
    list.sort((a, b) {
      final aDate = a.primaryDate ?? DateTime(2099);
      final bDate = b.primaryDate ?? DateTime(2099);
      return aDate.compareTo(bDate);
    });
    return list;
  }

  Future<void> _ensureFirebaseAuthToken() async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null ||
        auth.currentUser?.email?.toLowerCase() != masterAdminEmail.toLowerCase()) {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? account =
          googleSignIn.currentUser ?? await googleSignIn.signInSilently();
      if (account == null) {
        account = await googleSignIn.signIn();
      }
      if (account != null) {
        final GoogleSignInAuthentication googleAuth = await account.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await auth.signInWithCredential(credential);
      }
    }
  }

  Future<void> _saveAllEvents(List<SimpleEvent> updatedList) async {
    try {
      await _ensureFirebaseAuthToken();

      final sorted = _sortEventsChronologically(updatedList);
      final rawMaps = sorted.map((e) => e.toMap()).toList();

      await FirebaseFirestore.instance
          .collection('calendar')
          .doc('current_events')
          .set({
        'events_list': rawMaps,
        'events_updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      final prefs = await _prefs;
      await prefs.setString('cached_events_list', jsonEncode(rawMaps));
      await prefs.setString(
          'last_calendar_fetch_date', DateTime.now().toIso8601String().substring(0, 10));

      // Keep signatures up-to-date locally so admin does not receive redundant self-alerts
      final allSignatures = sorted.map((e) => e.signature).toList();
      await prefs.setStringList('known_event_signatures', allSignatures);

      setState(() {
        _loadedEvents = sorted;
        _eventsFuture = Future.value(sorted);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Changes saved and published successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint("Firestore save error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update cloud: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  bool _hasEventOn(int year, int month, int day) {
    return _loadedEvents.any((e) => e.occursOn(year, month, day));
  }

  List<SimpleEvent> _getEventsOn(int year, int month, int day) {
    return _loadedEvents.where((e) => e.occursOn(year, month, day)).toList();
  }

  void _showEventDialog({SimpleEvent? existingItem, int? editIndex}) {
    final bool isEdit = existingItem != null;

    final nameEnCtrl = TextEditingController(text: isEdit ? existingItem.nameEn : '');
    final nameHiCtrl = TextEditingController(text: isEdit ? existingItem.nameHi : '');

    DateTime selectedDate = isEdit
        ? (existingItem.primaryDate ?? DateTime.now())
        : (_selectedCalendarDate ?? DateTime.now());

    String timeString = isEdit ? existingItem.time : "07:00 AM & 07:30 PM";
    String currentImageUrl = isEdit ? existingItem.imageUrl : 'assets/img/vjvlogo.png';
    bool isProcessingImage = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Text(
                isEdit ? "Edit Event" : "Schedule New Event",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameEnCtrl,
                    decoration: const InputDecoration(
                      labelText: "Event Title (English)",
                      hintText: "e.g. Chaliha Sahib",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameHiCtrl,
                    decoration: const InputDecoration(
                      labelText: "Event Title (Hindi)",
                      hintText: "उदा. चालीहा साहिब",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),

                  Text("Select Date",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                      );
                      if (picked != null) {
                        setModalState(() => selectedDate = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange.shade300),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.orange.withValues(alpha: 0.05),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded,
                              color: Color(0xFFE65100), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ),
                          Text(
                            "Pick Date",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFE65100),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text("Event Time",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 7, minute: 0),
                      );
                      if (picked != null) {
                        setModalState(() {
                          timeString = picked.format(context);
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange.shade300),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.orange.withValues(alpha: 0.05),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time_rounded,
                              color: Color(0xFFE65100), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              timeString,
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ),
                          Text(
                            "Pick Time",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFE65100),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  Text("Event Photo",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildEventImage(currentImageUrl, size: 56, fit: BoxFit.cover),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE65100).withValues(alpha: 0.12),
                            foregroundColor: const Color(0xFFE65100),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () async {
                            final XFile? pickedFile = await _picker.pickImage(
                              source: ImageSource.gallery,
                              maxWidth: 350,
                              maxHeight: 350,
                              imageQuality: 60,
                            );
                            if (pickedFile != null) {
                              setModalState(() => isProcessingImage = true);
                              final bytes = await pickedFile.readAsBytes();
                              final base64Encoded = base64Encode(bytes);
                              setModalState(() {
                                currentImageUrl = "data:image/jpeg;base64,$base64Encoded";
                                isProcessingImage = false;
                              });
                            }
                          },
                          icon: const Icon(Icons.photo_library_rounded, size: 18),
                          label: Text(
                            "Gallery Photo",
                            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (isProcessingImage) ...[
                    const SizedBox(height: 14),
                    Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: const Color(0xFFE65100),
                        size: 26,
                      ),
                    ),
                  ],
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              actions: [
                if (isEdit)
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      final confirmed = await showDialog<bool>(
                        context: this.context,
                        builder: (delCtx) => AlertDialog(
                          title: const Text("Delete Event?"),
                          content: const Text("Remove this event from all users' calendars?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(delCtx, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(delCtx, true),
                              child: const Text("Delete", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true && editIndex != null) {
                        final current = List<SimpleEvent>.from(_loadedEvents);
                        if (editIndex < current.length) {
                          current.removeAt(editIndex);
                          await _saveAllEvents(current);
                        }
                      }
                    },
                    child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE65100),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    if (nameEnCtrl.text.trim().isEmpty) return;

                    final formattedIso =
                        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

                    final current = List<SimpleEvent>.from(_loadedEvents);
                    final updated = SimpleEvent(
                      nameEn: nameEnCtrl.text.trim(),
                      nameHi: nameHiCtrl.text.trim().isEmpty
                          ? nameEnCtrl.text.trim()
                          : nameHiCtrl.text.trim(),
                      date: formattedIso,
                      time: timeString,
                      imageUrl: currentImageUrl,
                    );

                    if (isEdit && editIndex != null) {
                      current[editIndex] = updated;
                    } else {
                      current.add(updated);
                    }

                    Navigator.pop(ctx);
                    await _saveAllEvents(current);
                  },
                  child: Text(isEdit ? "Update" : "Save", style: const TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showImagePreview(String imageUrl) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildEventImage(imageUrl, size: 260, fit: BoxFit.contain),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Close",
                      style: TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventImage(String imageUrl, {double size = 64, BoxFit fit = BoxFit.contain}) {
    if (imageUrl.startsWith('data:image')) {
      try {
        final base64String = imageUrl.split(',').last;
        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.memory(
            base64Decode(base64String),
            width: size,
            height: size,
            fit: fit,
            errorBuilder: (_, __, ___) =>
                Image.asset('assets/img/vjvlogo.png', width: size, height: size, fit: fit),
          ),
        );
      } catch (e) {
        return Image.asset('assets/img/vjvlogo.png', width: size, height: size, fit: fit);
      }
    } else if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          imageUrl,
          width: size,
          height: size,
          fit: fit,
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/img/vjvlogo.png',
            width: size,
            height: size,
            fit: fit,
          ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          imageUrl.isNotEmpty ? imageUrl : 'assets/img/vjvlogo.png',
          width: size,
          height: size,
          fit: fit,
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/img/vjvlogo.png',
            width: size,
            height: size,
            fit: fit,
          ),
        ),
      );
    }
  }

  Widget _buildCalendarCard({
    required bool isDark,
    required int lang,
    required Color cardBg,
    required Color primaryText,
    required Color secondaryText,
    required Color accentColor,
  }) {
    final year = _currentCalendarMonth.year;
    final month = _currentCalendarMonth.month;

    final firstDayOfWeek = DateTime(year, month, 1).weekday % 7;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    final List<String> monthNamesEn = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    final List<String> monthNamesHi = [
      "जनवरी", "फ़रवरी", "मार्च", "अप्रैल", "मई", "जून",
      "जुलाई", "अगस्त", "सितंबर", "अक्टूबर", "नवंबर", "दिसंबर"
    ];
    final String currentMonthName = lang == 0 ? monthNamesEn[month - 1] : monthNamesHi[month - 1];

    final List<String> weekDays = lang == 0
        ? ["S", "M", "T", "W", "T", "F", "S"]
        : ["र", "सो", "मं", "बु", "गु", "शु", "श"];

    final isLiveCurrentMonth = _currentCalendarMonth.year == DateTime.now().year &&
        _currentCalendarMonth.month == DateTime.now().month;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        "$currentMonthName $year",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                        ),
                      ),
                    ),
                    if (!isLiveCurrentMonth) ...[
                      const SizedBox(width: 8),
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            _currentCalendarMonth =
                                DateTime(DateTime.now().year, DateTime.now().month, 1);
                            _selectedCalendarDate = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            lang == 0 ? "Today" : "आज",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: accentColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  setState(() {
                    _currentCalendarMonth = DateTime(year, month - 1, 1);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(Icons.chevron_left_rounded, color: accentColor, size: 22),
                ),
              ),
              const SizedBox(width: 2),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  setState(() {
                    _currentCalendarMonth = DateTime(year, month + 1, 1);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(Icons.chevron_right_rounded, color: accentColor, size: 22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.map((d) {
              return SizedBox(
                width: 32,
                child: Text(
                  d,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: secondaryText,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - firstDayOfWeek + 1;
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }

              final hasEvent = _hasEventOn(year, month, dayNumber);
              final isSelected = _selectedCalendarDate != null &&
                  _selectedCalendarDate!.year == year &&
                  _selectedCalendarDate!.month == month &&
                  _selectedCalendarDate!.day == dayNumber;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedCalendarDate = null;
                    } else {
                      _selectedCalendarDate = DateTime(year, month, dayNumber);
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? accentColor
                        : (hasEvent
                        ? accentColor.withValues(alpha: isDark ? 0.35 : 0.18)
                        : Colors.transparent),
                    border: Border.all(
                      color: isSelected
                          ? accentColor
                          : (hasEvent ? accentColor : Colors.transparent),
                      width: hasEvent ? 2.2 : 1.0,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "$dayNumber",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight:
                          hasEvent || isSelected ? FontWeight.w800 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (hasEvent ? accentColor : primaryText),
                        ),
                      ),
                      if (hasEvent && !isSelected)
                        Positioned(
                          bottom: 4,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accentColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([themeNotifier, languageNotifier]),
      builder: (context, _) {
        final bool isDark = themeNotifier.value == ThemeMode.dark;
        final int lang = languageNotifier.value;

        final Color scaffoldBg = isDark
            ? const Color(0xFF131315)
            : const Color.fromRGBO(235, 236, 222, 1);
        final Color cardBg = isDark ? const Color(0xFF1E1E24) : Colors.white;
        final Color primaryText = isDark ? Colors.white : const Color(0xFF2C221E);
        final Color secondaryText = isDark ? Colors.white70 : Colors.black54;
        final Color appBarColor = isDark ? const Color(0xFF1E1E24) : Colors.white;
        final Color accentColor =
        isDark ? const Color(0xFFFF9E80) : const Color(0xFFE65100);

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            backgroundColor: appBarColor,
            elevation: 0.5,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: accentColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              lang == 0 ? 'Darbar Events' : 'दरबार उत्सव एवं तिथियां',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: accentColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              if (_isAdmin)
                IconButton(
                  tooltip: "Push Live Instantly",
                  icon: const Icon(Icons.bolt_rounded, color: Colors.green, size: 26),
                  onPressed: () => _saveAllEvents(_loadedEvents),
                ),
              IconButton(
                tooltip: lang == 0 ? "Refresh" : "ताज़ा करें",
                icon: Icon(Icons.refresh_rounded, color: accentColor),
                onPressed: () {
                  setState(() {
                    _eventsFuture = fetchCentralEvents(isManualRefresh: true);
                  });
                },
              ),
            ],
          ),
          floatingActionButton: _isAdmin
              ? FloatingActionButton.extended(
            backgroundColor: accentColor,
            onPressed: () => _showEventDialog(),
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: Text(
              "Add Event",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, color: Colors.white),
            ),
          )
              : null,
          body: FutureBuilder<List<SimpleEvent>>(
            future: _eventsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting && _loadedEvents.isEmpty) {
                return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: accentColor,
                    size: 44,
                  ),
                );
              }

              List<SimpleEvent> visibleEvents = _loadedEvents;
              if (_selectedCalendarDate != null) {
                visibleEvents = _getEventsOn(
                  _selectedCalendarDate!.year,
                  _selectedCalendarDate!.month,
                  _selectedCalendarDate!.day,
                );
              }

              return RefreshIndicator(
                color: accentColor,
                onRefresh: () async {
                  setState(() {
                    _eventsFuture = fetchCentralEvents(isManualRefresh: true);
                  });
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCalendarCard(
                        isDark: isDark,
                        lang: lang,
                        cardBg: cardBg,
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                        accentColor: accentColor,
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 10, 18, 4),
                        child: Row(
                          children: [
                            Text(
                              _selectedCalendarDate != null
                                  ? (lang == 0
                                  ? "Events on ${_selectedCalendarDate!.day}-${_selectedCalendarDate!.month}-${_selectedCalendarDate!.year}"
                                  : "${_selectedCalendarDate!.day}-${_selectedCalendarDate!.month}-${_selectedCalendarDate!.year} के उत्सव")
                                  : (lang == 0 ? "Upcoming Events" : "आगामी उत्सव व पर्व"),
                              style: GoogleFonts.poppins(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: primaryText,
                              ),
                            ),
                            const Spacer(),
                            if (_selectedCalendarDate != null)
                              ActionChip(
                                backgroundColor: accentColor.withValues(alpha: 0.15),
                                label: Text(
                                  lang == 0 ? "Show All" : "सभी देखें",
                                  style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: accentColor),
                                ),
                                onPressed: () {
                                  setState(() => _selectedCalendarDate = null);
                                },
                              ),
                          ],
                        ),
                      ),

                      if (visibleEvents.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.event_busy_rounded, size: 42, color: secondaryText),
                                const SizedBox(height: 8),
                                Text(
                                  lang == 0
                                      ? "No events scheduled for this date."
                                      : "इस तिथि पर कोई उत्सव निर्धारित नहीं है।",
                                  style: GoogleFonts.poppins(
                                      fontSize: 13.5, color: secondaryText),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          itemCount: visibleEvents.length,
                          itemBuilder: (context, index) {
                            final event = visibleEvents[index];
                            final String title = lang == 0 ? event.nameEn : event.nameHi;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white12
                                      : Colors.black.withValues(alpha: 0.04),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark
                                        ? Colors.black45
                                        : Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    final dt = event.primaryDate;
                                    if (dt != null) {
                                      setState(() {
                                        _currentCalendarMonth = DateTime(dt.year, dt.month, 1);
                                        _selectedCalendarDate = DateTime(dt.year, dt.month, dt.day);
                                      });
                                      _scrollController.animateTo(
                                        0,
                                        duration: const Duration(milliseconds: 350),
                                        curve: Curves.easeOut,
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () => _showImagePreview(event.imageUrl),
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: accentColor.withValues(
                                                  alpha: isDark ? 0.18 : 0.1),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: _buildEventImage(event.imageUrl, size: 64),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                title,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.w700,
                                                  color: primaryText,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  Icon(Icons.calendar_today_rounded,
                                                      size: 13, color: accentColor),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      event.readableDate,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                        color: secondaryText,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(Icons.access_time_rounded,
                                                      size: 13, color: accentColor),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      event.time,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: secondaryText,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (_isAdmin)
                                          IconButton(
                                            tooltip: "Edit Event",
                                            icon: Icon(Icons.edit_note_rounded,
                                                color: accentColor, size: 28),
                                            onPressed: () {
                                              final originalIndex =
                                              _loadedEvents.indexOf(event);
                                              _showEventDialog(
                                                existingItem: event,
                                                editIndex: originalIndex >= 0
                                                    ? originalIndex
                                                    : index,
                                              );
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class SimpleEvent {
  final String nameEn;
  final String nameHi;
  final String date;
  final String time;
  final String imageUrl;

  const SimpleEvent({
    required this.nameEn,
    required this.nameHi,
    required this.date,
    required this.time,
    this.imageUrl = 'assets/img/vjvlogo.png',
  });

  String get signature => "${nameEn.trim()}_${date.trim()}";

  bool occursOn(int year, int month, int day) {
    for (final dt in targetDates) {
      if (dt.month == month && dt.day == day) {
        if (dt.year == year || date.contains(month.toString())) {
          return true;
        }
      }
    }
    return false;
  }

  List<DateTime> get targetDates {
    final List<DateTime> dates = [];
    if (date.isEmpty) return dates;

    final parsedIso = DateTime.tryParse(date);
    if (parsedIso != null) {
      return [parsedIso];
    }

    final lower = date.toLowerCase();
    final currentYear = DateTime.now().year;

    final monthsMap = {
      'january': 1, 'jan': 1,
      'february': 2, 'feb': 2,
      'march': 3, 'mar': 3,
      'april': 4, 'apr': 4,
      'may': 5,
      'june': 6, 'jun': 6,
      'july': 7, 'jul': 7,
      'august': 8, 'aug': 8,
      'september': 9, 'sep': 9,
      'october': 10, 'oct': 10,
      'november': 11, 'nov': 11,
      'december': 12, 'dec': 12,
    };

    int detectedMonth = 0;
    monthsMap.forEach((mName, mNum) {
      if (detectedMonth == 0 && lower.contains(mName)) {
        detectedMonth = mNum;
      }
    });

    final numbers = RegExp(r'\d+').allMatches(date).map((m) => int.parse(m.group(0)!)).toList();

    if (detectedMonth != 0 && numbers.isNotEmpty) {
      for (final num in numbers) {
        if (num >= 1 && num <= 31) {
          dates.add(DateTime(currentYear, detectedMonth, num));
        }
      }
      return dates;
    }

    if (lower.contains("october") || lower.contains("oct")) {
      dates.add(DateTime(currentYear, 10, 25));
    } else if (lower.contains("chaitra") || lower.contains("cheti")) {
      dates.add(DateTime(currentYear, 3, 20));
    } else if (lower.contains("ashadha") || lower.contains("purnima")) {
      dates.add(DateTime(currentYear, 7, 29));
    } else if (lower.contains("july") || lower.contains("august")) {
      dates.add(DateTime(currentYear, 8, 15));
    }

    return dates;
  }

  DateTime? get primaryDate {
    final dts = targetDates;
    if (dts.isEmpty) return null;
    return dts.first;
  }

  String get readableDate {
    final dt = primaryDate;
    if (dt != null) {
      final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
      return "${dt.day} ${months[dt.month - 1]} ${dt.year}";
    }
    return date;
  }

  factory SimpleEvent.fromJson(Map<String, dynamic> json) {
    return SimpleEvent(
      nameEn: json['Name_En']?.toString() ?? json['Name']?.toString() ?? '',
      nameHi: json['Name_Hi']?.toString() ??
          json['Name_En']?.toString() ??
          json['Name']?.toString() ??
          '',
      date: json['Date']?.toString() ?? '',
      time: json['Time']?.toString() ?? '',
      imageUrl: json['ImageUrl']?.toString().isNotEmpty == true
          ? json['ImageUrl']!.toString()
          : 'assets/img/vjvlogo.png',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name_En': nameEn,
      'Name_Hi': nameHi,
      'Date': date,
      'Time': time,
      'ImageUrl': imageUrl,
    };
  }
}