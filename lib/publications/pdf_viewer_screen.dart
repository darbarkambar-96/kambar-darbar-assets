import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';

class PdfViewerScreen extends StatefulWidget {
  final String title;
  final String pdfUrl;
  final String filename;

  const PdfViewerScreen({
    Key? key,
    required this.title,
    required this.pdfUrl,
    required this.filename,
  }) : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  File? _localFile;
  bool _isLoading = true;
  int _savedPage = 1;
  String _statusKey = "opening"; // 'opening', 'loading_saved', 'saving_offline', 'opening_book'

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _preparePdf();
  }

  Future<void> _preparePdf() async {
    try {
      // 1. Get saved page from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _savedPage = prefs.getInt('last_page_${widget.filename}') ?? 1;

      // 2. Check local file storage
      final Directory dir = await getApplicationDocumentsDirectory();
      final File file = File('${dir.path}/${widget.filename}');

      if (await file.exists() && (await file.length()) > 5000) {
        // Already cached locally
        if (mounted) {
          setState(() {
            _localFile = file;
            _statusKey = "loading_saved";
          });
        }
      } else {
        // Download and cache locally once
        if (mounted) {
          setState(() {
            _statusKey = "saving_offline";
          });
        }

        final HttpClient client = HttpClient();
        final HttpClientRequest request = await client.getUrl(Uri.parse(widget.pdfUrl));
        final HttpClientResponse response = await request.close();

        if (response.statusCode == 200) {
          final IOSink sink = file.openWrite();
          await response.pipe(sink);

          if (mounted) {
            setState(() {
              _localFile = file;
              _statusKey = "opening_book";
            });
          }
        } else {
          throw Exception("Server returned code ${response.statusCode}");
        }
      }
    } catch (e) {
      debugPrint("PDF loading error: $e");
      if (mounted) {
        setState(() => _isLoading = false);
        final int lang = languageNotifier.value;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              lang == 0
                  ? 'Failed to load document: $e'
                  : 'दस्तावेज़ लोड करने में विफल: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _saveCurrentPage(int pageNumber) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_page_${widget.filename}', pageNumber);
  }

  Future<void> _downloadFileExternally(int lang) async {
    final Uri uri = Uri.parse(widget.pdfUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              lang == 0 ? 'Download failed: $e' : 'डाउनलोड विफल रहा: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.deepOrange,
          ),
        );
      }
    }
  }

  String _getLocalizedStatus(String key, int lang) {
    if (lang == 0) {
      switch (key) {
        case "loading_saved":
          return "Loading saved book...";
        case "saving_offline":
          return "Saving copy for offline reading...";
        case "opening_book":
          return "Opening book...";
        case "opening":
        default:
          return "Opening...";
      }
    } else {
      switch (key) {
        case "loading_saved":
          return "सहेजी गई पुस्तक लोड हो रही है...";
        case "saving_offline":
          return "ऑफ़लाइन पढ़ने हेतु सहेजा जा रहा है...";
        case "opening_book":
          return "पुस्तक खुल रही है...";
        case "opening":
        default:
          return "खोल रहे हैं...";
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

        final Color scaffoldBg = isDark
            ? const Color(0xFF131315)
            : const Color.fromRGBO(235, 236, 222, 1);
        final Color appBarColor = isDark ? const Color(0xFF1E1E24) : Colors.white;
        final Color accentColor = isDark ? const Color(0xFFFF9E80) : const Color(0xFFE65100);
        final Color primaryText = isDark ? Colors.white : Colors.black87;
        final Color secondaryText = isDark ? Colors.white60 : Colors.grey.shade600;
        final Color overlayBg = isDark
            ? const Color(0xFF1E1E24).withOpacity(0.95)
            : Colors.white.withOpacity(0.95);

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            backgroundColor: appBarColor,
            elevation: 0.5,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: accentColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                tooltip: lang == 0 ? "Download PDF to phone" : "फोन में पीडीएफ डाउनलोड करें",
                icon: const Icon(Icons.download_rounded, color: Colors.deepOrangeAccent),
                onPressed: () => _downloadFileExternally(lang),
              ),
            ],
          ),
          body: Stack(
            children: [
              if (_localFile != null)
                SfPdfViewer.file(
                  _localFile!,
                  key: _pdfViewerKey,
                  controller: _pdfViewerController,
                  canShowScrollHead: true,
                  canShowScrollStatus: true,
                  onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                    setState(() => _isLoading = false);
                    if (_savedPage > 1) {
                      _pdfViewerController.jumpToPage(_savedPage);
                    }
                  },
                  onPageChanged: (PdfPageChangedDetails details) {
                    _saveCurrentPage(details.newPageNumber);
                  },
                  onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                    setState(() => _isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          lang == 0
                              ? 'Failed to render PDF: ${details.description}'
                              : 'पीडीएफ प्रदर्शित करने में विफल: ${details.description}',
                          style: GoogleFonts.poppins(),
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  },
                ),
              if (_isLoading)
                Container(
                  color: overlayBg,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: accentColor),
                        const SizedBox(height: 18),
                        Text(
                          _getLocalizedStatus(_statusKey, lang),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: primaryText,
                          ),
                        ),
                        if (_savedPage > 1) ...[
                          const SizedBox(height: 6),
                          Text(
                            lang == 0
                                ? "Resuming from page $_savedPage"
                                : "पृष्ठ $_savedPage से पुनः प्रारंभ कर रहे हैं",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: secondaryText,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}