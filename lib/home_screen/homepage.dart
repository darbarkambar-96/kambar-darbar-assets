import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';
import 'package:darbar_app_of_kambar_darbar/daily_quotes.dart';
import 'package:darbar_app_of_kambar_darbar/home_screen/darbar_sidebar_drawer.dart';
import 'package:darbar_app_of_kambar_darbar/home_screen/satgurus_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  static const String masterAdminEmail = 'darbarkambar@gmail.com';
  static const String dvrStreamUrl =
      "rtsp://admin:Globotech@12345@116.73.65.158:554/streaming/channels/104";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  late AnimationController _pulseController;

  String? _userName;
  String? _userEmail;
  String? _userPhotoUrl;
  bool _isLoadingAuth = false;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkDailyCalendarUpdates();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await _prefs;
    final email = prefs.getString('user_email');
    setState(() {
      _userName = prefs.getString('user_name');
      _userEmail = email;
      _userPhotoUrl = prefs.getString('user_photo');
      _isAdmin = (email != null && email.trim().toLowerCase() == masterAdminEmail.toLowerCase());
    });

    _googleSignIn.signInSilently().then((account) {
      if (account != null) _saveUserSession(account);
    }).catchError((err) => debugPrint("Silent sign-in error: $err"));
  }

  Future<void> _checkDailyCalendarUpdates() async {
    final SharedPreferences prefs = await _prefs;
    final String today = DateTime.now().toIso8601String().substring(0, 10);
    final String lastFetchDate = prefs.getString('last_calendar_fetch_date') ?? '';

    if (lastFetchDate != today) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('calendar')
            .doc('current_events')
            .get(const GetOptions(source: Source.serverAndCache));

        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          final List<dynamic>? rawList = data['events_list'];

          if (rawList != null && rawList.isNotEmpty) {
            await prefs.setString('cached_events_list', jsonEncode(rawList));
            await prefs.setString('last_calendar_fetch_date', today);

            final List<String> knownSignatures =
                prefs.getStringList('known_event_signatures') ?? [];
            final int lang = languageNotifier.value;

            if (knownSignatures.isEmpty) {
              final allSignatures = rawList
                  .map((e) =>
              "${(e['Name_En'] ?? e['Name'] ?? '').toString().trim()}_${(e['Date'] ?? '').toString().trim()}")
                  .toList();
              await prefs.setStringList('known_event_signatures', allSignatures);
            } else {
              final List<String> updatedSignatures = List<String>.from(knownSignatures);
              for (final item in rawList) {
                final nameEn = (item['Name_En'] ?? item['Name'] ?? '').toString().trim();
                final date = (item['Date'] ?? '').toString().trim();
                final sig = "${nameEn}_$date";

                if (!knownSignatures.contains(sig)) {
                  updatedSignatures.add(sig);
                  final String title = lang == 0
                      ? "New Darbar Event Announced!"
                      : "दरबार उत्सव की घोषणा!";
                  final String name =
                  lang == 0 ? nameEn : (item['Name_Hi'] ?? nameEn).toString();
                  final String time = (item['Time'] ?? '').toString();
                  final String body = "$name\n$date • $time";
                  await showDarbarEventNotification(title: title, body: body);
                }
              }
              await prefs.setStringList('known_event_signatures', updatedSignatures);
            }
          }
        }
      } catch (e) {
        debugPrint("Daily calendar update error: $e");
      }
    }
  }

  Future<void> _handleManualRefresh() async {
    await _checkDailyCalendarUpdates();
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Screen refreshed"),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _saveUserSession(GoogleSignInAccount account) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('user_name', account.displayName ?? 'Devotee');
    await prefs.setString('user_email', account.email);
    await prefs.setString('user_photo', account.photoUrl ?? '');

    setState(() {
      _userName = account.displayName ?? 'Devotee';
      _userEmail = account.email;
      _userPhotoUrl = account.photoUrl;
      _isAdmin = (account.email.trim().toLowerCase() == masterAdminEmail.toLowerCase());
    });

    try {
      final GoogleSignInAuthentication googleAuth = await account.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      debugPrint("Firebase Auth authenticated for: ${account.email}");
    } catch (e) {
      debugPrint("Firebase Auth bridge error: $e");
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoadingAuth = true);
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) await _saveUserSession(account);
    } catch (error) {
      debugPrint("Google Sign In failed: $error");
    } finally {
      if (mounted) setState(() => _isLoadingAuth = false);
    }
  }

  Future<void> _confirmSignOutDialog(int currentLang, bool isDarkMode) async {
    final Color dialogBg = isDarkMode ? const Color(0xFF1E1E24) : Colors.white;
    const Color brandSaffron = Color(0xFFE65100);
    final Color primaryText = isDarkMode ? Colors.white : const Color(0xFF2C221E);

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dialogBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.logout_rounded, color: brandSaffron, size: 22),
            const SizedBox(width: 8),
            Text(
              currentLang == 0 ? "Sign Out" : "लॉगआउट",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: brandSaffron,
              ),
            ),
          ],
        ),
        content: Text(
          currentLang == 0
              ? "Are you sure you want to log out?"
              : "क्या आप वाकई लॉगआउट करना चाहते हैं?",
          style: GoogleFonts.poppins(
            fontSize: 13.5,
            color: primaryText,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              currentLang == 0 ? "Cancel" : "रद्द करें",
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: brandSaffron,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              currentLang == 0 ? "Log Out" : "लॉगआउट",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();

      final SharedPreferences prefs = await _prefs;
      await prefs.remove('user_name');
      await prefs.remove('user_email');
      await prefs.remove('user_photo');

      setState(() {
        _userName = null;
        _userEmail = null;
        _userPhotoUrl = null;
        _isAdmin = false;
      });
    }
  }

  void _showSaintCloudModal({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String imagePath,
    required List<Map<String, String>> sections,
    required bool isDarkMode,
  }) {
    final Color modalBg = isDarkMode ? const Color(0xFF1E1C1A) : Colors.white;
    final Color titleColor = const Color(0xFFE65100);
    final Color textColor = isDarkMode ? Colors.white70 : Colors.black87;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(left: 12, right: 12, bottom: 20, top: 50),
          decoration: BoxDecoration(
            color: modalBg,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.white24 : Colors.orange.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: titleColor,
                              ),
                            ),
                            Text(
                              subtitle,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode ? Colors.white54 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close_rounded, color: isDarkMode ? Colors.white54 : Colors.grey),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: isDarkMode ? Colors.white12 : Colors.orange.shade100),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 250,
                          margin: const EdgeInsets.only(bottom: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: LinearGradient(
                              colors: isDarkMode
                                  ? [const Color(0xFF2C221E), const Color(0xFF191412)]
                                  : [const Color(0xFFFFF8ED), const Color(0xFFFFE8CC)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            border: Border.all(
                              color: const Color(0xFFFF9800).withValues(alpha: 0.35),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withValues(alpha: 0.15),
                                blurRadius: 16,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                        ),
                        ...sections.map((sec) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (sec['heading'] != null && sec['heading']!.isNotEmpty) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6F00).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      sec['heading']!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFE65100),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                Text(
                                  sec['body'] ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.5,
                                    height: 1.6,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([themeNotifier, languageNotifier]),
      builder: (context, _) {
        final bool isDarkMode = themeNotifier.value == ThemeMode.dark;
        final int counter = languageNotifier.value;

        final BoxDecoration canvasDecoration = BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [const Color(0xFF1B1510), const Color(0xFF121212), const Color(0xFF0D0D0D)]
                : [const Color(0xFFFFF8E7), const Color(0xFFFBF4E2), const Color(0xFFF3E9D2)],
          ),
        );

        final Color surfaceCardBg = isDarkMode ? const Color(0xFF231F1C) : Colors.white;
        final Color primaryText = isDarkMode ? Colors.white : const Color(0xFF2C221E);
        final Color secondaryText = isDarkMode ? Colors.white60 : const Color(0xFF7A6B63);
        const Color brandSaffron = Color(0xFFE65100);

        final List<Map<String, String>> spiritualItems = [
          {
            'icon': 'assets/img/eventsnew.png',
            'title': counter == 0 ? "Darbar Events" : "दरबार उत्सव",
            'desc': counter == 0 ? "Utsavs & Dates" : "उत्सव एवं तिथियां",
            'route': '/events',
          },
          {
            'icon': 'assets/img/bhajan.png',
            'title': counter == 0 ? "Bhajans & Pravachans" : "भजन एवं प्रवचन",
            'desc': counter == 0 ? "Spiritual Audio & Discourses" : "मधुर भजन व अमृतवाणी",
            'route': '/bhajans',
          },
          {
            'icon': 'assets/img/publications.png',
            'title': counter == 0 ? "Publications" : "पुस्तिकाएं",
            'desc': counter == 0 ? "Sacred Literature" : "ग्रंथ व साहित्य",
            'route': '/publications',
          },
          {
            'icon': 'assets/img/photo2.png',
            'title': counter == 0 ? "Photo Gallery" : "फोटो गैलरी",
            'desc': counter == 0 ? "Darshan Archives" : "पवित्र चित्र",
            'route': '/photogallery',
          },
        ];

        final List<Map<String, String>> sevaItems = [
          {
            'icon': 'assets/img/trustees.png',
            'title': counter == 0 ? "Trust & Trustees" : "ट्रस्ट और ट्रस्टी",
            'desc': counter == 0 ? "Governing Body" : "मार्गदर्शक मंडल",
            'route': '/trustees',
          },
          {
            'icon': 'assets/img/medical.png',
            'title': counter == 0 ? "Medical Aid" : "मेडिकल सेवा",
            'desc': counter == 0 ? "Charitable Clinic" : "निःशुल्क सेवा",
            'route': '/medical',
          },
          {
            'icon': 'assets/img/scholarshipnew.png',
            'title': counter == 0 ? "Scholarships" : "स्कॉलरशिप्स",
            'desc': counter == 0 ? "Student Support" : "शिक्षा सहायता",
            'route': '/scholarship',
          },
          {
            'icon': 'assets/img/programsnew.png',
            'title': counter == 0 ? "Programs" : "कार्यक्रम",
            'desc': counter == 0 ? "Upcoming Schedule" : "दरबार कार्यक्रम",
            'route': '/programs',
          },
        ];

        return Scaffold(
          key: _scaffoldKey,
          drawer: DarbarSidebarDrawer(
            currentLang: counter,
            isDarkMode: isDarkMode,
          ),
          body: Container(
            decoration: canvasDecoration,
            child: SafeArea(
              child: RefreshIndicator(
                color: brandSaffron,
                displacement: 55.0,
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: _handleManualRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Top Devotee Bar
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                        child: _buildGoogleUserHeader(
                          surfaceCardBg,
                          primaryText,
                          secondaryText,
                          brandSaffron,
                          counter,
                          isDarkMode,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Offline Synchronized Daily Quote Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDarkMode
                                  ? [const Color(0xFF2C221E), const Color(0xFF1E1714)]
                                  : [const Color(0xFFFFF3E0), const Color(0xFFFFE0B2)],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFFFFB74D).withValues(alpha: 0.4),
                              width: 1.1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withValues(alpha: 0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: brandSaffron.withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.format_quote_rounded, color: brandSaffron, size: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      counter == 0 ? "MESSAGE OF THE DAY" : "दिन का पावन विचार",
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.0,
                                        color: brandSaffron,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                DailyQuotes.getTodayQuote(),
                                style: GoogleFonts.poppins(
                                  fontSize: 12.5,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                  color: primaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Live Darshan Streaming Banner
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE65100), Color(0xFFFF6F00), Color(0xFFFF8F00)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF4300).withValues(alpha: 0.35),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(22),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/livestream',
                                  arguments: ScreenArguments(counter, dvrStreamUrl, 1),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(9),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.22),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Image.asset(
                                        'assets/img/live-streaming.png',
                                        width: 40,
                                        height: 40,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              FadeTransition(
                                                opacity: _pulseController,
                                                child: Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: const BoxDecoration(
                                                    color: Colors.red,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                counter == 0 ? "LIVE DARSHAN" : "लाइव दर्शन",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                  letterSpacing: 0.8,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            counter == 0
                                                ? "Connect directly to Darbar cameras"
                                                : "दरबार के कैमरों से सीधे जुड़ें",
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white.withValues(alpha: 0.95),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.18),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Latest Darbar News Banner
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8E0E00), Color(0xFF1F1C18)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8E0E00).withValues(alpha: 0.35),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(22),
                              onTap: () => Navigator.pushNamed(context, '/news'),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(9),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.16),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: const Icon(
                                        Icons.campaign_rounded,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              FadeTransition(
                                                opacity: _pulseController,
                                                child: Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: const BoxDecoration(
                                                    color: Colors.redAccent,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                counter == 0
                                                    ? "DARBAR NEWS"
                                                    : "दरबार समाचार",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                  letterSpacing: 0.8,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            counter == 0
                                                ? "Click here for latest updates"
                                                : "नवीनतम समाचार हेतु स्पर्श करें",
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white.withValues(alpha: 0.9),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.18),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                        size: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      _buildSectionTitle(
                        title: counter == 0 ? "Spiritual & Discourses" : "सत्संग एवं भक्ति",
                        subtitle: counter == 0 ? "Swipe cards to open audios & books" : "स्क्रॉल करें और अमृतवाणी सुनें",
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                      ),
                      const SizedBox(height: 10),
                      _buildHorizontalPhysicsDeck(
                        items: spiritualItems,
                        cardBg: surfaceCardBg,
                        textColor: primaryText,
                        subTextColor: secondaryText,
                        accentColor: brandSaffron,
                        isDarkMode: isDarkMode,
                        currentLang: counter,
                      ),
                      const SizedBox(height: 18),

                      _buildSectionTitle(
                        title: counter == 0 ? "Trust, Seva & Darbar" : "ट्रस्ट, सेवा एवं दरबार",
                        subtitle: counter == 0 ? "Medical clinics, scholarships & history" : "स्वास्थ्य सेवा, छात्रवृत्ति व परिचय",
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                      ),
                      const SizedBox(height: 10),
                      _buildHorizontalPhysicsDeck(
                        items: sevaItems,
                        cardBg: surfaceCardBg,
                        textColor: primaryText,
                        subTextColor: secondaryText,
                        accentColor: const Color(0xFFD84315),
                        isDarkMode: isDarkMode,
                        currentLang: counter,
                      ),
                      const SizedBox(height: 18),

                      // Satgurus & Spiritual Lineage Deck
                      _buildSectionTitle(
                        title: counter == 0 ? "Satgurus & Spiritual Lineage" : "पूज्य सतगुरु एवं मार्गदर्शक",
                        subtitle: counter == 0
                            ? "Swipe cards • Tap to read divine biographies"
                            : "स्क्रॉल करें • पावन जीवन चरित्र पढ़ने हेतु स्पर्श करें",
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 168,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: sacredPersonalities.length,
                          itemBuilder: (context, index) {
                            final item = sacredPersonalities[index];
                            final String title = counter == 0 ? item['nameEn'] : item['nameHi'];
                            final String role = counter == 0 ? item['roleEn'] : item['roleHi'];
                            final String modalTitle =
                            counter == 0 ? item['modalTitleEn'] : item['modalTitleHi'];
                            final List<Map<String, String>> sections =
                            counter == 0 ? item['sectionsEn'] : item['sectionsHi'];

                            return _PhysicsActionCard(
                              icon: item['image'],
                              title: title,
                              desc: role,
                              isAvatar: true,
                              cardBg: surfaceCardBg,
                              textColor: primaryText,
                              subTextColor: secondaryText,
                              accentColor: brandSaffron,
                              isDarkMode: isDarkMode,
                              onTap: () {
                                _showSaintCloudModal(
                                  context: context,
                                  title: modalTitle,
                                  subtitle: counter == 0 ? "Kambar Darbar" : "कांबर दरबार",
                                  imagePath: item['image'],
                                  isDarkMode: isDarkMode,
                                  sections: sections,
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 18),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset(
                            'assets/img/quote.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required String subtitle,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: primaryText,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalPhysicsDeck({
    required List<Map<String, String>> items,
    required Color cardBg,
    required Color textColor,
    required dynamic subTextColor,
    required Color accentColor,
    required bool isDarkMode,
    required int currentLang,
  }) {
    return SizedBox(
      height: 168,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _PhysicsActionCard(
            icon: item['icon']!,
            title: item['title']!,
            desc: item['desc']!,
            isAvatar: false,
            cardBg: cardBg,
            textColor: textColor,
            subTextColor: subTextColor,
            accentColor: accentColor,
            isDarkMode: isDarkMode,
            onTap: () {
              Navigator.pushNamed(
                context,
                item['route']!,
                arguments: ScreenArguments(currentLang, dvrStreamUrl, 1),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildGoogleUserHeader(
      Color bg,
      Color text,
      Color subText,
      Color accentColor,
      int currentLang,
      bool isDarkMode,
      ) {
    final bool isSignedIn = _userName != null && _userName!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDarkMode ? Colors.white10 : Colors.black.withValues(alpha: 0.04),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black45 : Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: currentLang == 0 ? "Menu" : "मेनू",
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            icon: Icon(Icons.menu_rounded, color: accentColor, size: 22),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          const SizedBox(width: 6),

          if (isSignedIn) ...[
            CircleAvatar(
              radius: 15,
              backgroundColor: accentColor.withValues(alpha: 0.15),
              backgroundImage: (_userPhotoUrl != null && _userPhotoUrl!.isNotEmpty)
                  ? NetworkImage(_userPhotoUrl!)
                  : null,
              child: (_userPhotoUrl == null || _userPhotoUrl!.isEmpty)
                  ? Text(
                _userName![0].toUpperCase(),
                style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w700, color: accentColor),
              )
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentLang == 0 ? "Jai Sai / Welcome," : "जय साईं / स्वागत है,",
                    style: GoogleFonts.poppins(fontSize: 9.5, fontWeight: FontWeight.w500, color: subText),
                  ),
                  Text(
                    _userName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w700, color: text),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: currentLang == 0 ? "Sign out" : "लॉगआउट",
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
              icon: Icon(Icons.logout_rounded, size: 17, color: isDarkMode ? Colors.white54 : Colors.grey),
              onPressed: () => _confirmSignOutDialog(currentLang, isDarkMode),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_rounded, color: accentColor, size: 16),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentLang == 0 ? "Welcome Devotee" : "दरबार में स्वागत है",
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: text),
                  ),
                  Text(
                    currentLang == 0 ? "Sign in for notifications" : "अपडेट्स के लिए साइन इन करें",
                    style: GoogleFonts.poppins(fontSize: 9.5, fontWeight: FontWeight.w400, color: subText),
                  ),
                ],
              ),
            ),
            _isLoadingAuth
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : TextButton(
              style: TextButton.styleFrom(
                backgroundColor: accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: _handleGoogleSignIn,
              child: Text(
                currentLang == 0 ? "Sign In" : "लॉगिन",
                style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PhysicsActionCard extends StatefulWidget {
  final String icon;
  final String title;
  final String desc;
  final bool isAvatar;
  final Color cardBg;
  final Color textColor;
  final dynamic subTextColor;
  final Color accentColor;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _PhysicsActionCard({
    required this.icon,
    required this.title,
    required this.desc,
    this.isAvatar = false,
    required this.cardBg,
    required this.textColor,
    required this.subTextColor,
    required this.accentColor,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  State<_PhysicsActionCard> createState() => _PhysicsActionCardState();
}

class _PhysicsActionCardState extends State<_PhysicsActionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 110),
          width: 142,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          decoration: BoxDecoration(
            color: widget.cardBg,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: widget.isDarkMode
                    ? Colors.black54
                    : (_isPressed ? Colors.black12 : Colors.orange.withValues(alpha: 0.08)),
                blurRadius: _isPressed ? 4 : 12,
                offset: _isPressed ? const Offset(0, 2) : const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: widget.isDarkMode
                  ? Colors.white12
                  : (_isPressed
                  ? widget.accentColor.withValues(alpha: 0.5)
                  : const Color(0xFFFFE0B2).withValues(alpha: 0.7)),
              width: 1.2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 78,
                  height: 78,
                  padding: EdgeInsets.all(widget.isAvatar ? 3.0 : 12.0),
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(alpha: widget.isDarkMode ? 0.22 : 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: widget.isAvatar
                      ? ClipOval(
                    child: Image.asset(
                      widget.icon,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (_, __, ___) => const Icon(Icons.person_rounded),
                    ),
                  )
                      : Image.asset(
                    widget.icon,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_rounded),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: widget.textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.desc,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: widget.subTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}