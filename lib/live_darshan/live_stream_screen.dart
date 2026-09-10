import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_vlc_player_16kb/flutter_vlc_player.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({Key? key}) : super(key: key);

  @override
  _LiveStreamScreenState createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen>
    with TickerProviderStateMixin {
  static const String activeNvrHost = "116.73.65.158:554";
  static const String deadNvrHost = "182.48.203.143:1025";

  VlcPlayerController? _videoPlayerController;
  late AnimationController _blinkController;

  bool _isInitialized = false;
  bool _hasError = false;
  bool _isBuffering = true;
  bool _isFullScreen = false;
  bool _isExiting = false;
  String _activeStreamUrl = "";
  int _cameraIndex = 1;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is ScreenArguments) {
        _cameraIndex = args.data2;
        _activeStreamUrl = _resolveStreamUrl(args.data, _cameraIndex);
      } else {
        _cameraIndex = 1;
        _activeStreamUrl = _resolveStreamUrl("", 1);
      }
      _startPlayer(_activeStreamUrl);
      _isInitialized = true;
    }
  }

  String _resolveStreamUrl(String incomingUrl, int camIndex) {
    if (incomingUrl.isEmpty || incomingUrl.contains(deadNvrHost)) {
      final channelCode = (100 + camIndex).toString();
      return "rtsp://admin:Globotech@12345@$activeNvrHost/streaming/channels/$channelCode";
    }
    return incomingUrl;
  }

  void _startPlayer(String streamUrl) {
    _hasError = false;
    _isBuffering = true;

    _videoPlayerController?.removeListener(_playerListener);
    _videoPlayerController?.dispose();

    _videoPlayerController = VlcPlayerController.network(
      streamUrl,
      hwAcc: HwAcc.auto,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
          '--rtsp-tcp',
          '--avcodec-skiploopfilter', 'all',
          '--drop-late-frames',
          '--skip-frames',
          '--no-video-title-show',
        ]),
        rtp: VlcRtpOptions([
          ':rtp-over-rtsp',
          ':rtsp-tcp',
        ]),
      ),
    );

    _videoPlayerController?.addListener(_playerListener);
  }

  void _playerListener() {
    if (!mounted || _videoPlayerController == null || _isExiting) return;

    final state = _videoPlayerController!.value.playingState;

    if (state == PlayingState.playing && (_isBuffering || _hasError)) {
      setState(() {
        _isBuffering = false;
        _hasError = false;
      });
    } else if (state == PlayingState.buffering && !_isBuffering) {
      setState(() {
        _isBuffering = true;
      });
    } else if (state == PlayingState.error) {
      setState(() {
        _hasError = true;
        _isBuffering = false;
      });
    }
  }

  void _retryConnection() {
    setState(() {
      _hasError = false;
      _isBuffering = true;
    });
    final channelCode = (100 + _cameraIndex).toString();
    _activeStreamUrl =
    "rtsp://admin:Globotech@12345@$activeNvrHost/streaming/channels/$channelCode";
    _startPlayer(_activeStreamUrl);
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      isFullScreenNotifier.value = _isFullScreen;

      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });
  }

  Future<void> _handleExit() async {
    if (_isExiting) return;

    if (_isFullScreen) {
      _toggleFullScreen();
      await Future.delayed(const Duration(milliseconds: 150));
    }

    isFullScreenNotifier.value = false;

    setState(() {
      _isExiting = true;
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    await Future.delayed(const Duration(milliseconds: 60));

    _videoPlayerController?.removeListener(_playerListener);

    try {
      await _videoPlayerController?.stop();
    } catch (e) {
      debugPrint("VLC stop error: $e");
    }

    await Future.delayed(const Duration(milliseconds: 250));

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    isFullScreenNotifier.value = false;
    _blinkController.dispose();
    _videoPlayerController?.removeListener(_playerListener);

    final controller = _videoPlayerController;
    _videoPlayerController = null;

    if (controller != null) {
      Future.microtask(() async {
        try {
          await controller.stop();
          await controller.stopRendererScanning();
          await controller.dispose();
        } catch (e) {
          debugPrint("Async VLC dispose error: $e");
        }
      });
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  String _getCameraTitle(int camIndex, int lang) {
    if (lang == 0) {
      switch (camIndex) {
        case 1:
          return "Samadhi Room";
        case 2:
          return "Samadhi Room Closeup";
        case 3:
          return "Guru Room";
        case 4:
          return "Sainjans Room";
        default:
          return "Kambar Darbar";
      }
    } else {
      switch (camIndex) {
        case 1:
          return "समाधि कक्ष";
        case 2:
          return "समाधि क्लोज़-अप";
        case 3:
          return "गुरु कक्ष";
        case 4:
          return "सांईंजन कक्ष";
        default:
          return "कांबर दरबार";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([themeNotifier, languageNotifier]),
      builder: (context, _) {
        final bool isDark = themeNotifier.value == ThemeMode.dark;
        final int lang = languageNotifier.value;

        final String titlemain = _getCameraTitle(_cameraIndex, lang);

        final Color scaffoldBg = isDark
            ? const Color(0xFF131315)
            : const Color.fromRGBO(235, 236, 222, 1);
        final Color cardBg = isDark ? const Color(0xFF1E1E24) : Colors.white;
        final Color secondaryText = isDark ? Colors.white70 : Colors.black87;
        final Color appBarColor = isDark ? const Color(0xFF1E1E24) : Colors.white;
        final Color accentColor = isDark ? const Color(0xFFFF9E80) : const Color(0xFFE65100);

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (!didPop) {
              _handleExit();
            }
          },
          child: Scaffold(
            backgroundColor: scaffoldBg,
            appBar: (_isFullScreen || _isExiting)
                ? null
                : AppBar(
              backgroundColor: appBarColor,
              elevation: 0.5,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: accentColor),
                onPressed: _handleExit,
              ),
              title: Text(
                lang == 0 ? 'Live Darshan' : 'लाइव दर्शन',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            body: Stack(
              children: [
                Platform.isAndroid
                    ? SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: _isFullScreen
                          ? EdgeInsets.zero
                          : const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 14.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(
                                  _isFullScreen ? 0 : 20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  _isFullScreen ? 0 : 20),
                              child: AspectRatio(
                                aspectRatio: _isFullScreen ? 16 / 9 : 16 / 9.5,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Video Surface
                                    if (_videoPlayerController != null && !_isExiting)
                                      InteractiveViewer(
                                        panEnabled: false,
                                        minScale: 1.0,
                                        maxScale: 4.0,
                                        child: VlcPlayer(
                                          controller: _videoPlayerController!,
                                          aspectRatio: 16 / 9.5,
                                          placeholder: Container(
                                            color: Colors.black,
                                            child: Center(
                                              child: LoadingAnimationWidget
                                                  .staggeredDotsWave(
                                                color: Colors.white,
                                                size: 38,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      Container(color: Colors.black),

                                    // Error Overlay
                                    if (_hasError && !_isExiting)
                                      Container(
                                        color: Colors.black87,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 8),
                                        child: Center(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.videocam_off_rounded,
                                                  color: Colors.white70,
                                                  size: 30,
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  lang == 0
                                                      ? "Camera Feed Temporarily Offline"
                                                      : "कैमरा प्रसारण वर्तमान में बंद है",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  lang == 0
                                                      ? "Darbar NVR is currently offline or unreachable."
                                                      : "दरबार NVR वर्तमान में ऑफ़लाइन अथवा पहुंच से बाहर है।",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                ElevatedButton.icon(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                    Colors.deepOrangeAccent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(12),
                                                    ),
                                                    padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14,
                                                        vertical: 6),
                                                    minimumSize: const Size(0, 32),
                                                  ),
                                                  onPressed: _retryConnection,
                                                  icon: const Icon(
                                                      Icons.refresh_rounded,
                                                      size: 15,
                                                      color: Colors.white),
                                                  label: Text(
                                                    lang == 0
                                                        ? "Retry Connection"
                                                        : "पुनः प्रयास करें",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 11.5,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                    // Buffering Indicator
                                    if (_isBuffering && !_hasError && !_isExiting)
                                      Container(
                                        color: Colors.black45,
                                        child: Center(
                                          child: LoadingAnimationWidget
                                              .staggeredDotsWave(
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                      ),

                                    // Top "LIVE" Tag
                                    if (!_isExiting)
                                      Positioned(
                                        top: 12,
                                        left: 12,
                                        child: FadeTransition(
                                          opacity: _blinkController,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent
                                                  .withOpacity(0.9),
                                              borderRadius:
                                              BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.circle,
                                                    color: Colors.white, size: 8),
                                                const SizedBox(width: 6),
                                                Text(
                                                  "LIVE",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                    // Fullscreen Toggle shifted to Top-Right
                                    if (!_isExiting)
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.55),
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            iconSize: 24,
                                            onPressed: _toggleFullScreen,
                                            icon: Icon(
                                              _isFullScreen
                                                  ? Icons.fullscreen_exit_rounded
                                                  : Icons.fullscreen_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Bottom Detail Card
                          if (!_isFullScreen)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(20),
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
                                        : Colors.black.withOpacity(0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    titlemain,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: accentColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    lang == 0
                                        ? "Real-time spiritual feed from Kambar Darbar."
                                        : "कांबर दरबार से पावन सीधा प्रसारण।",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.5,
                                      color: secondaryText,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
                    : InAppWebView(
                  initialUrlRequest:
                  URLRequest(url: WebUri.uri(Uri.parse(_activeStreamUrl))),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      javaScriptEnabled: true,
                      useOnLoadResource: true,
                      clearCache: true,
                    ),
                  ),
                ),

                if (_isExiting)
                  Positioned.fill(
                    child: Container(
                      color: scaffoldBg,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/img/vjvlogo.png',
                                width: 52,
                                height: 52,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 24),
                            LoadingAnimationWidget.staggeredDotsWave(
                              color: accentColor,
                              size: 42,
                            ),
                            const SizedBox(height: 18),
                            Text(
                              lang == 0 ? "Please wait..." : "कृपया प्रतीक्षा करें...",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: accentColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              lang == 0
                                  ? "Closing sacred live darshan"
                                  : "पावन लाइव दर्शन समाप्त हो रहा है",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: secondaryText,
                              ),
                            ),
                          ],
                        ),
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
}