import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';
import 'package:darbar_app_of_kambar_darbar/publications/pdf_viewer_screen.dart';

class PublicationsScreen extends StatelessWidget {
  const PublicationsScreen({Key? key}) : super(key: key);

  final String baseUrl =
      'https://github.com/darbarkambar-96/kambar-darbar-assets/releases/download/1.0/';

  void _openInAppReader(BuildContext context, String title, String filename) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(
          title: title,
          pdfUrl: '$baseUrl$filename',
          filename: filename,
        ),
      ),
    );
  }

  Future<void> _downloadPdf(BuildContext context, String filename, int lang) async {
    final Uri uri = Uri.parse('$baseUrl$filename');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              lang == 0 ? 'Download failed: $e' : 'डाउनलोड विफल हुआ: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.deepOrange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([themeNotifier, languageNotifier]),
      builder: (context, _) {
        final bool isDark = themeNotifier.value == ThemeMode.dark;
        final int lang = languageNotifier.value; // 0 = English, 1 = Hindi

        final List<Map<String, String>> publications = [
          {
            'title': lang == 0
                ? '18 Chapter Gita Translation'
                : 'गीता अठारह अध्याय (सरल अनुवाद)',
            'subtitle': lang == 0
                ? 'Discourse & translation by Sain Vishindas Sahib'
                : 'साईं विशिनदास साहिब द्वारा पावन सरल अनुवाद',
            'size': '7.0 MB',
            'filename': 'gita_translation_sain_vishindas.pdf',
          },
          {
            'title': lang == 0
                ? 'Biography of Sain Vishindas Sahib'
                : 'साईं विशिनदास साहिब जीवन चरित्र',
            'subtitle': lang == 0
                ? 'Life, teachings, and spiritual journey'
                : 'पवित्र जीवन गाथा एवं अमृत उपदेश',
            'size': '21.5 MB',
            'filename': 'biography_sain_vishindas.pdf',
          },
          {
            'title': lang == 0
                ? 'Biography of Sain Vilayatrai Sahib'
                : 'साईं विलायतराय साहिब जीवन चरित्र',
            'subtitle': lang == 0
                ? 'Reprint Edition - Early life & Bhakti in Grahasti'
                : 'गृहस्थ में भक्ति, सेवा एवं दिव्य जीवन',
            'size': '16.4 MB',
            'filename': 'biography_sain_vilayatrai.pdf',
          },
          {
            'title': lang == 0
                ? 'Sain Jiwatsingh Sahib - Book'
                : 'साईं जीवतसिंह साहिब - ग्रंथ',
            'subtitle': lang == 0
                ? 'Sacred biography, timeless wisdom, and Kalaams'
                : 'पावन कलाम, विचार एवं दिव्य जीवन चरित्र',
            'size': '23.5 MB',
            'filename': 'biography_sain_jiwatsingh.pdf',
          },
        ];

        final Color scaffoldBg = isDark
            ? const Color(0xFF131315)
            : const Color.fromRGBO(235, 236, 222, 1);
        final Color appBarBg = isDark ? const Color(0xFF1E1E24) : Colors.white;
        final Color appBarAccent = isDark ? const Color(0xFFFF9E80) : const Color(0xFFE65100);
        final Color cardBg = isDark ? const Color(0xFF1E1E24) : Colors.white;
        final Color titleColor = isDark ? Colors.white : Colors.black87;
        final Color subtitleColor = isDark ? Colors.white70 : Colors.grey.shade600;
        final Color badgeBg = isDark ? Colors.white12 : Colors.grey.shade100;
        final Color badgeText = isDark ? Colors.white70 : Colors.grey.shade700;
        final Color dividerColor = isDark ? Colors.white12 : Colors.black12;

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            backgroundColor: appBarBg,
            elevation: 0.5,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: appBarAccent),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              lang == 0 ? 'Publications & Books' : 'पुस्तिकाएं एवं ग्रंथ',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: appBarAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            itemCount: publications.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = publications[index];
              final String title = item['title']!;
              final String filename = item['filename']!;

              return Card(
                color: cardBg,
                elevation: isDark ? 0 : 1.5,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                    color: isDark ? Colors.white12 : Colors.black.withOpacity(0.04),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE65100).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              color: Color(0xFFE65100),
                              size: 30,
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
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: titleColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['subtitle']!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.5,
                                    color: subtitleColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: badgeBg,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'PDF • ${item['size']}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: badgeText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Divider(height: 1, color: dividerColor),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE65100),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              onPressed: () =>
                                  _openInAppReader(context, title, filename),
                              icon: const Icon(Icons.visibility_rounded,
                                  size: 18, color: Colors.white),
                              label: Text(
                                lang == 0 ? "Read in App" : "ऐप में पढ़ें",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFE65100)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                            ),
                            onPressed: () => _downloadPdf(context, filename, lang),
                            icon: const Icon(Icons.download_rounded,
                                size: 18, color: Color(0xFFE65100)),
                            label: Text(
                              lang == 0 ? "Download" : "डाउनलोड",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFE65100),
                              ),
                            ),
                          ),
                        ],
                      ),
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