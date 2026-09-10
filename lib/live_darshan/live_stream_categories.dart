import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';

class LiveStreamCategories extends StatefulWidget {
  const LiveStreamCategories({Key? key}) : super(key: key);

  @override
  State<LiveStreamCategories> createState() => _LiveStreamCategoriesState();
}

class _LiveStreamCategoriesState extends State<LiveStreamCategories>
    with SingleTickerProviderStateMixin {
  List<dynamic> _cameraLinks = [];
  bool _isLoading = true;
  late AnimationController _blinkController;

  final Map<String, String> _imageMapping = {
    "Samadhi Room": 'assets/img/cam3.jpg',
    "Samadhi Closeup": 'assets/img/cam4.jpg',
    "Guru Room": 'assets/img/cam2.jpg',
    "Sainjans Room": 'assets/img/cam1.jpg',
  };

  final Map<String, String> _hindiTitles = {
    "Samadhi Room": 'समाधि कक्ष',
    "Samadhi Closeup": 'समाधि क्लोज़-अप',
    "Guru Room": 'गुरु कक्ष',
    "Sainjans Room": 'सांईंजन कक्ष',
  };

  // NVR stream fallbacks
  final Map<String, String> _androidLinks = {
    "Samadhi Room": 'rtsp://admin:Globotech@12345@116.73.65.158:554/streaming/channels/101',
    "Samadhi Closeup": 'rtsp://admin:Globotech@12345@116.73.65.158:554/streaming/channels/102',
    "Guru Room": 'rtsp://admin:Globotech@12345@116.73.65.158:554/streaming/channels/103',
    "Sainjans Room": 'rtsp://admin:Globotech@12345@116.73.65.158:554/streaming/channels/104',
  };

  final List<Map<String, dynamic>> _defaultCameras = const [
    {
      "Title": "Samadhi Room",
      "RTSPLink": "rtsp://admin:Globotech@12345@116.73.65.158:554/streaming/channels/101",
    },
    {
      "Title": "Samadhi Closeup",
      "RTSPLink": "rtsp://admin:Globotech@12345@116.73.65.158:554/streaming/channels/102",
    },
    {
      "Title": "Guru Room",
      "RTSPLink": "rtsp://admin:Globotech@12345@116.73.65.158:554/streaming/channels/103",
    },
    {
      "Title": "Sainjans Room",
      "RTSPLink": "rtsp://admin:Globotech@12345@116.73.65.158:554/streaming/channels/104",
    },
  ];

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _fetchCameraLinks();
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  Future<void> _fetchCameraLinks() async {
    const String apiUrl = 'https://kambardarbar.org/cameralinks.php';

    try {
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' &&
            data['links'] != null &&
            (data['links'] as List).isNotEmpty) {
          if (mounted) {
            setState(() {
              _cameraLinks = data['links'];
              _isLoading = false;
            });
            return;
          }
        }
      }
    } catch (e) {
      debugPrint("Camera API fallback activated: $e");
    }

    // Default to the 4 Darbar HD cameras if the server endpoint is unreachable
    if (mounted) {
      setState(() {
        _cameraLinks = _defaultCameras;
        _isLoading = false;
      });
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
        final Color cardBg = isDark ? const Color(0xFF1E1E24) : Colors.white;
        final Color primaryText = isDark ? Colors.white : const Color(0xFF2C221E);
        final Color appBarColor = isDark ? const Color(0xFF1E1E24) : Colors.white;
        final Color accentColor = isDark ? const Color(0xFFFF9E80) : const Color(0xFFE65100);

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
              lang == 0 ? 'Select Live Camera' : 'लाइव कैमरा चुनें',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: accentColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: _isLoading
              ? Center(
            child: CircularProgressIndicator(color: accentColor),
          )
              : GridView.builder(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 20.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14.0,
              mainAxisSpacing: 14.0,
              childAspectRatio: 0.88,
            ),
            itemCount: _cameraLinks.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final camera = _cameraLinks[index];
              final String titleEn = camera['Title'] ?? 'Camera ${index + 1}';
              final String title = lang == 0
                  ? titleEn
                  : (_hindiTitles[titleEn] ?? titleEn);
              final String imageUrl =
                  _imageMapping[titleEn] ?? 'assets/img/cam1.jpg';

              final keysList = _androidLinks.keys.toList();
              String selectedKey = keysList.length > index
                  ? keysList[index]
                  : keysList.first;
              String selectedLink = _androidLinks[selectedKey]!;

              return Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(22.0),
                  border: Border.all(
                    color: isDark
                        ? Colors.white12
                        : Colors.black.withOpacity(0.04),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black45
                          : Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22.0),
                    onTap: () {
                      if (Platform.isIOS) {
                        Navigator.pushNamed(
                          context,
                          '/livevideo',
                          arguments: ScreenArguments(
                            lang,
                            camera['RTSPLink'] ?? selectedLink,
                            index + 1,
                          ),
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          '/livevideo',
                          arguments: ScreenArguments(
                            lang,
                            selectedLink,
                            index + 1,
                          ),
                        );
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(22.0)),
                                child: Image.asset(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.25),
                                  borderRadius:
                                  const BorderRadius.vertical(
                                      top: Radius.circular(22.0)),
                                ),
                              ),
                              const Center(
                                child: Icon(
                                  Icons.play_circle_fill_rounded,
                                  color: Colors.white,
                                  size: 44,
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.65),
                                    borderRadius:
                                    BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FadeTransition(
                                        opacity: _blinkController,
                                        child: Container(
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(
                                            color: Colors.redAccent,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "LIVE",
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 1,
                                  color: isDark
                                      ? Colors.white10
                                      : Colors.black12,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: primaryText,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
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