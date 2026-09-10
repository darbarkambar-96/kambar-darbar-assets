import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  static const String masterAdminEmail = 'darbarkambar@gmail.com';
  static const Color brandSaffron = Color(0xFFE65100);
  static const String draftKey = 'kambar_feedback_draft';

  final TextEditingController _feedbackController = TextEditingController();
  bool _isLoading = false;
  bool _isAdmin = false;
  bool _checkingRole = true;
  bool _draftRestored = false;

  // Admin on-demand state
  List<QueryDocumentSnapshot> _feedbackDocs = [];
  bool _hasFetched = false;
  bool _isFetchingAdmin = false;

  String _userName = "Anonymous";
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _initScreen();
    _feedbackController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _feedbackController.removeListener(_onTextChanged);
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _initScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('user_email');
    final savedName = prefs.getString('user_name');
    final authUser = FirebaseAuth.instance.currentUser;

    final email = authUser?.email ?? savedEmail;
    final name = authUser?.displayName ?? savedName;
    final bool isAdminUser =
    (email != null && email.trim().toLowerCase() == masterAdminEmail.toLowerCase());

    String restoredDraft = '';
    if (!isAdminUser) {
      restoredDraft = prefs.getString(draftKey) ?? '';
      if (restoredDraft.isNotEmpty) {
        _feedbackController.text = restoredDraft;
      }
    }

    if (mounted) {
      setState(() {
        _userEmail = email;
        _userName = (name != null && name.trim().isNotEmpty) ? name.trim() : "Anonymous";
        _isAdmin = isAdminUser;
        _draftRestored = restoredDraft.isNotEmpty;
        _checkingRole = false;
      });
    }
  }

  void _onTextChanged() {
    if (!_isAdmin) {
      _saveDraft(_feedbackController.text);
    }
  }

  Future<void> _saveDraft(String text) async {
    final prefs = await SharedPreferences.getInstance();
    if (text.trim().isEmpty) {
      await prefs.remove(draftKey);
      if (_draftRestored && mounted) {
        setState(() => _draftRestored = false);
      }
    } else {
      await prefs.setString(draftKey, text);
    }
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(draftKey);
    _feedbackController.clear();
    if (mounted) {
      setState(() => _draftRestored = false);
    }
  }

  // Admin On-Demand Fetch (Zero reads consumed until tapped)
  Future<void> _fetchAdminFeedbacks({bool isRefresh = false}) async {
    setState(() => _isFetchingAdmin = true);

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('feedback')
          .orderBy('timestamp', descending: true)
          .limit(100)
          .get(const GetOptions(source: Source.serverAndCache));

      setState(() {
        _feedbackDocs = querySnapshot.docs;
        _hasFetched = true;
      });

      if (isRefresh && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Refreshed ${_feedbackDocs.length} recent feedbacks"),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching feedbacks: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isFetchingAdmin = false);
    }
  }

  Future<void> _submitFeedback(int lang) async {
    final text = _feedbackController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            lang == 0 ? "Please enter your feedback" : "कृपया अपना सुझाव दर्ज करें",
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('feedback').add({
        'message': text,
        'userName': _userName,
        'userEmail': _userEmail ?? '',
        'timestamp': FieldValue.serverTimestamp(),
      });

      await _clearDraft();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF2E7D32),
            content: Text(
              lang == 0
                  ? "Thank you! Your feedback has been submitted."
                  : "धन्यवाद! आपका सुझाव सफलतापूर्वक प्राप्त हो गया है।",
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error sending feedback: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteFeedback(String docId, int lang) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          lang == 0 ? "Delete Feedback" : "फीडबैक हटाएं",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        content: Text(
          lang == 0
              ? "Are you sure you want to permanently delete this devotee feedback?"
              : "क्या आप इस सुझाव को स्थायी रूप से हटाना चाहते हैं?",
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(lang == 0 ? "Cancel" : "रद्द करें"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              lang == 0 ? "Delete" : "हटाएं",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('feedback').doc(docId).delete();
      setState(() {
        _feedbackDocs.removeWhere((doc) => doc.id == docId);
      });
    }
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Just now";
    final dt = timestamp.toDate();
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return "$day/$month/$year $hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([themeNotifier, languageNotifier]),
      builder: (context, _) {
        final bool isDark = themeNotifier.value == ThemeMode.dark;
        final int lang = languageNotifier.value;

        final Color scaffoldBg =
        isDark ? const Color(0xFF131315) : const Color.fromRGBO(235, 236, 222, 1);
        final Color cardBg = isDark ? const Color(0xFF1E1E24) : Colors.white;
        final Color primaryText = isDark ? Colors.white : const Color(0xFF2C221E);
        final Color secondaryText = isDark ? Colors.white60 : const Color(0xFF7A6B63);

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            backgroundColor: cardBg,
            elevation: 0.5,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: brandSaffron),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              _isAdmin
                  ? (lang == 0 ? "Devotee Feedback Inbox" : "भक्त सुझाव इनबॉक्स")
                  : (lang == 0 ? "Give Feedback" : "सुझाव दर्ज करें"),
              style: GoogleFonts.poppins(
                fontSize: 17.5,
                color: brandSaffron,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              if (_isAdmin && _hasFetched)
                IconButton(
                  tooltip: "Refresh",
                  icon: const Icon(Icons.refresh_rounded, color: brandSaffron),
                  onPressed: _isFetchingAdmin ? null : () => _fetchAdminFeedbacks(isRefresh: true),
                ),
            ],
          ),
          body: _checkingRole
              ? const Center(child: CircularProgressIndicator(color: brandSaffron))
              : _isAdmin
              ? _buildAdminConsoleBody(
            isDark: isDark,
            cardBg: cardBg,
            primaryText: primaryText,
            secondaryText: secondaryText,
            lang: lang,
          )
              : _buildUserDraftForm(
            isDark: isDark,
            cardBg: cardBg,
            primaryText: primaryText,
            secondaryText: secondaryText,
            lang: lang,
          ),
        );
      },
    );
  }

  Widget _buildUserDraftForm({
    required bool isDark,
    required Color cardBg,
    required Color primaryText,
    required Color secondaryText,
    required int lang,
  }) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: brandSaffron.withValues(alpha: isDark ? 0.25 : 0.15),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: brandSaffron.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.rate_review_rounded, color: brandSaffron, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang == 0 ? "We value your thoughts" : "आपके विचार हमारे लिए अमूल्य हैं",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: primaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lang == 0
                            ? "Submitting as: $_userName"
                            : "प्रस्तुतकर्ता: $_userName",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (_draftRestored)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit_note_rounded, color: Colors.blue, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      lang == 0
                          ? "Restored your unsent draft"
                          : "अपूर्ण ड्राफ्ट पुनः लोड कर दिया गया है",
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _clearDraft,
                    child: Text(
                      lang == 0 ? "Clear" : "हटाएं",
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Text(
            lang == 0 ? "Your Suggestions or Grievances:" : "आपका सुझाव अथवा समस्या:",
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.08),
              ),
            ),
            child: TextField(
              controller: _feedbackController,
              maxLines: 7,
              minLines: 5,
              style: GoogleFonts.poppins(fontSize: 13.5, color: primaryText),
              decoration: InputDecoration(
                hintText: lang == 0
                    ? "Type your honest feedback here (draft saves automatically as you type)..."
                    : "यहाँ अपना सुझाव लिखें (टाइप करते ही ड्राफ्ट स्वतः सुरक्षित हो जाता है)...",
                hintStyle: GoogleFonts.poppins(fontSize: 12.5, color: secondaryText),
                contentPadding: const EdgeInsets.all(16),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: brandSaffron,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
              ),
              onPressed: _isLoading ? null : () => _submitFeedback(lang),
              icon: _isLoading
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
                  : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              label: Text(
                lang == 0 ? "Submit Feedback" : "सुझाव सबमिट करें",
                style: GoogleFonts.poppins(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminConsoleBody({
    required bool isDark,
    required Color cardBg,
    required Color primaryText,
    required Color secondaryText,
    required int lang,
  }) {
    if (!_hasFetched) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: brandSaffron.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.mark_email_unread_rounded, size: 36, color: brandSaffron),
              ),
              const SizedBox(height: 16),
              Text(
                lang == 0 ? "Admin Feedback Console" : "प्रशासनिक फीडबैक कंसोल",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: primaryText),
              ),
              const SizedBox(height: 6),
              Text(
                lang == 0
                    ? "Click below to query and inspect submissions from the cloud."
                    : "क्लाउड से नवीनतम सुझाव देखने के लिए नीचे दिए बटन पर क्लिक करें।",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 12.5, color: secondaryText),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandSaffron,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _isFetchingAdmin ? null : () => _fetchAdminFeedbacks(),
                icon: _isFetchingAdmin
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : const Icon(Icons.cloud_download_rounded, color: Colors.white),
                label: Text(
                  lang == 0 ? "Check Feedback" : "सुझाव देखें",
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_feedbackDocs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              lang == 0 ? "No devotee feedback found." : "कोई फीडबैक प्राप्त नहीं हुआ है।",
              style: GoogleFonts.poppins(color: secondaryText, fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => _fetchAdminFeedbacks(isRefresh: true),
              icon: const Icon(Icons.refresh_rounded, color: brandSaffron, size: 18),
              label: Text(
                lang == 0 ? "Check Again" : "पुनः जांचें",
                style: GoogleFonts.poppins(color: brandSaffron, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: _feedbackDocs.length,
      itemBuilder: (context, index) {
        final doc = _feedbackDocs[index];
        final data = doc.data() as Map<String, dynamic>;

        final String senderName =
        (data['userName'] != null && data['userName'].toString().trim().isNotEmpty)
            ? data['userName'].toString().trim()
            : "Anonymous";
        final String message = data['message']?.toString() ?? "";
        final Timestamp? ts = data['timestamp'] as Timestamp?;
        final String timeStr = _formatTimestamp(ts);
        final String senderEmail = data['userEmail']?.toString() ?? "";

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: brandSaffron.withValues(alpha: 0.15),
                    child: Text(
                      senderName.isNotEmpty ? senderName[0].toUpperCase() : "?",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: brandSaffron,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          senderName,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: primaryText,
                          ),
                        ),
                        Text(
                          senderEmail.isNotEmpty ? "$timeStr • $senderEmail" : timeStr,
                          style: GoogleFonts.poppins(fontSize: 10.5, color: secondaryText),
                        ),
                      ],
                    ),
                  ),
                  // Delete-only permission (no edit access)
                  IconButton(
                    tooltip: "Delete",
                    icon: Icon(Icons.delete_outline_rounded, size: 20, color: Colors.red.shade400),
                    onPressed: () => _deleteFeedback(doc.id, lang),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  height: 1.55,
                  color: primaryText,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}