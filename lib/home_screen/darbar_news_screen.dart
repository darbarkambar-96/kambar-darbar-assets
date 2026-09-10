import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';
import 'package:darbar_app_of_kambar_darbar/darbar_app_bar.dart';

class DarbarNewsScreen extends StatefulWidget {
  const DarbarNewsScreen({super.key});

  @override
  State<DarbarNewsScreen> createState() => _DarbarNewsScreenState();
}

class _DarbarNewsScreenState extends State<DarbarNewsScreen>
    with SingleTickerProviderStateMixin {
  static const String masterAdminEmail = 'darbarkambar@gmail.com';
  static const Color brandSaffron = Color(0xFFE65100);

  late AnimationController _pulseController;

  bool _isAdmin = false;
  bool _isLoading = true;
  bool _isSaving = false;

  String? _newsTitle;
  String? _newsParagraph;
  String? _newsImageUrl;
  Timestamp? _updatedAt;

  // Admin Form State (URL-based approach)
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _paragraphController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _checkRoleAndFetchNews();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _titleController.dispose();
    _paragraphController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _checkRoleAndFetchNews() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('user_email');
    final authUser = FirebaseAuth.instance.currentUser;
    final email = authUser?.email ?? savedEmail;

    final bool isAdminUser = (email != null &&
        email.trim().toLowerCase() == masterAdminEmail.toLowerCase());

    setState(() => _isAdmin = isAdminUser);
    await _fetchLatestNews();
  }

  Future<void> _fetchLatestNews() async {
    setState(() => _isLoading = true);
    try {
      final doc = await FirebaseFirestore.instance
          .collection('news')
          .doc('latest_news')
          .get(const GetOptions(source: Source.serverAndCache));

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final title = data['title']?.toString() ?? '';
        final paragraph = data['paragraph']?.toString() ?? '';
        final imageUrl = data['imageUrl']?.toString() ?? '';
        final ts = data['updatedAt'] as Timestamp?;

        setState(() {
          _newsTitle = title;
          _newsParagraph = paragraph;
          _newsImageUrl = imageUrl.isNotEmpty ? imageUrl : null;
          _updatedAt = ts;

          _titleController.text = title;
          _paragraphController.text = paragraph;
          _imageUrlController.text = imageUrl;
        });
      }
    } catch (e) {
      debugPrint("Error fetching Darbar news: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _publishNews(int lang) async {
    final text = _paragraphController.text.trim();
    final title = _titleController.text.trim();
    final img = _imageUrlController.text.trim();

    if (text.isEmpty && title.isEmpty && img.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            lang == 0
                ? "Please enter news content"
                : "कृपया समाचार विवरण दर्ज करें",
          ),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance.collection('news').doc('latest_news').set({
        'title': title,
        'paragraph': text,
        'imageUrl': img,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        _newsTitle = title;
        _newsParagraph = text;
        _newsImageUrl = img.isNotEmpty ? img : null;
        _updatedAt = Timestamp.now();
        _isEditing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF2E7D32),
            content: Text(
              lang == 0
                  ? "Darbar News published live!"
                  : "दरबार समाचार सफलतापूर्वक प्रकाशित हुआ!",
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error publishing news: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error publishing news: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return "";
    final dt = timestamp.toDate();
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return "$day/$month/$year • $hour:$minute";
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
        final Color primaryText =
        isDark ? Colors.white : const Color(0xFF2C221E);
        final Color secondaryText =
        isDark ? Colors.white60 : const Color(0xFF7A6B63);

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: DarbarAppBar(
            titleEn: 'Darbar News',
            titleHi: 'दरबार समाचार',
            extraActions: [
              if (_isAdmin && !_isLoading)
                IconButton(
                  tooltip: _isEditing ? "Cancel Edit" : "Edit / Post News",
                  icon: Icon(
                    _isEditing ? Icons.close_rounded : Icons.edit_note_rounded,
                    color: brandSaffron,
                    size: 24,
                  ),
                  onPressed: () => setState(() => _isEditing = !_isEditing),
                ),
            ],
          ),
          body: _isLoading
              ? const Center(
              child: CircularProgressIndicator(color: brandSaffron))
              : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isAdmin && _isEditing)
                  _buildAdminEditor(
                      cardBg, primaryText, secondaryText, lang, isDark)
                else
                  _buildNewsDisplay(
                      cardBg, primaryText, secondaryText, lang, isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdminEditor(
      Color cardBg,
      Color primaryText,
      Color secondaryText,
      int lang,
      bool isDark,
      ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: brandSaffron.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: brandSaffron.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.admin_panel_settings_rounded,
                    color: brandSaffron, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                lang == 0 ? "Admin Post Console" : "प्रशासनिक प्रकाशन कंसोल",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            style: GoogleFonts.poppins(fontSize: 14, color: primaryText),
            decoration: InputDecoration(
              labelText:
              lang == 0 ? "Headline / Title (Optional)" : "शीर्षक (वैकल्पिक)",
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _imageUrlController,
            style: GoogleFonts.poppins(fontSize: 13, color: primaryText),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: lang == 0
                  ? "Image URL (Leave empty for text-only)"
                  : "तस्वीर URL (केवल टेक्स्ट के लिए खाली छोड़ें)",
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              contentPadding: const EdgeInsets.all(14),
              suffixIcon: _imageUrlController.text.isNotEmpty
                  ? IconButton(
                tooltip: "Clear URL",
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Colors.redAccent),
                onPressed: () {
                  _imageUrlController.clear();
                  setState(() {});
                },
              )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          if (_imageUrlController.text.trim().isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: _imageUrlController.text.trim(),
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  height: 60,
                  color: Colors.red.withValues(alpha: 0.1),
                  alignment: Alignment.center,
                  child: Text(
                    lang == 0 ? "Invalid Image URL" : "अमान्य तस्वीर लिंक",
                    style: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
          TextField(
            controller: _paragraphController,
            maxLines: 7,
            minLines: 4,
            style: GoogleFonts.poppins(fontSize: 13.5, color: primaryText),
            decoration: InputDecoration(
              labelText: lang == 0
                  ? "News Paragraph / Feed"
                  : "समाचार विवरण / मुख्य टेक्स्ट",
              alignLabelWithHint: true,
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: brandSaffron,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _isSaving ? null : () => _publishNews(lang),
              icon: _isSaving
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
                  : const Icon(Icons.cloud_upload_rounded, color: Colors.white),
              label: Text(
                lang == 0 ? "Publish Darbar News" : "समाचार प्रकाशित करें",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsDisplay(
      Color cardBg,
      Color primaryText,
      Color secondaryText,
      int lang,
      bool isDark,
      ) {
    final bool hasImage = _newsImageUrl != null && _newsImageUrl!.isNotEmpty;
    final bool hasNews =
        (_newsParagraph != null && _newsParagraph!.isNotEmpty) ||
            (_newsTitle != null && _newsTitle!.isNotEmpty);

    if (!hasNews && !hasImage) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.campaign_outlined,
                  size: 54, color: secondaryText.withValues(alpha: 0.5)),
              const SizedBox(height: 12),
              Text(
                lang == 0
                    ? "No active announcement right now."
                    : "वर्तमान में कोई घोषणा उपलब्ध नहीं है।",
                style: GoogleFonts.poppins(fontSize: 14, color: secondaryText),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasImage) ...[
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
              child: CachedNetworkImage(
                imageUrl: _newsImageUrl!,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: isDark ? Colors.black26 : Colors.orange.shade50,
                  child: const Center(
                    child: CircularProgressIndicator(
                        color: brandSaffron, strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => const SizedBox.shrink(),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!hasImage) ...[
                  Row(
                    children: [
                      FadeTransition(
                        opacity: _pulseController,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent,
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        lang == 0 ? "LATEST UPDATE" : "ताज़ा समाचार",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.red.shade700,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
                if (_newsTitle != null && _newsTitle!.isNotEmpty) ...[
                  Text(
                    _newsTitle!,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: primaryText,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (_newsParagraph != null && _newsParagraph!.isNotEmpty) ...[
                  Text(
                    _newsParagraph!,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.65,
                      fontWeight: FontWeight.w400,
                      color: primaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (_updatedAt != null) ...[
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded,
                          size: 14, color: secondaryText),
                      const SizedBox(width: 5),
                      Text(
                        _formatDate(_updatedAt),
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: secondaryText),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}