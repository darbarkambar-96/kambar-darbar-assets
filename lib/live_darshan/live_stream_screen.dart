import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io' show Platform;

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({Key? key}) : super(key: key);

  @override
  _LiveStreamScreenState createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen>
    with TickerProviderStateMixin {
  String data = "";
  late FToast fToast;
  bool isLoading = true;

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.greenAccent,
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check),
        SizedBox(
          width: 12.0,
        ),
        Text(
            "Live stream is loading - it takes 10 to 12 seconds for the LIVE stream to load"),
      ],
    ),
  );

  _showToast(context) {
    fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  final int zoomscale = 1;
  VlcPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VlcPlayerController.network(
        'rtsp://admin:Globotech@12345@182.48.203.143:1025',
        hwAcc: HwAcc.full,
        autoPlay: true,
        autoInitialize: false,
        options: VlcPlayerOptions());

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   callme(context);
    // });
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController?.stopRendererScanning();
    await _videoPlayerController?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> initializePlayer() async {
    debugPrint(_videoPlayerController?.value.playingState.toString());
  }

  callme(BuildContext context) async {
    /*print("i am being called");
  DialogBuilder(context).showLoadingIndicator();
  await Future.delayed(new Duration(seconds:10));
  DialogBuilder(context).hideOpenDialog();
  _videoPlayerController?.play();*/
  }

  bool isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    _videoPlayerController = VlcPlayerController.network(
      args.data,
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );

    _videoPlayerController?.addListener(initializePlayer);
    final int zoomscale = 1;
    final key = args.data2;
    String titlemain = "Kambar Darbar";
    if (key == 1) {
      titlemain = "Sainjans Room";
    } else if (key == 2) {
      titlemain = "Gurus Room";
    } else if (key == 3) {
      titlemain = "Samadhi Room";
    } else if (key == 4) {
      titlemain = "Samadhi Room Closeup";
    }
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      appBar: isFullScreen
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Live Darshan From Darbar',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 20,
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
      resizeToAvoidBottomInset: false,
      body:
      Platform.isAndroid
          ? Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      InteractiveViewer(
                        panEnabled: false,
                        // alignPanAxis: true,
                        minScale: 0.5,
                        maxScale: 10,
                        child: VlcPlayer(
                          controller: _videoPlayerController!,
                          aspectRatio: 16 / 7,
                          placeholder: const Center(
                              child: CircularProgressIndicator()),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: ElevatedButton(
                          style: style,
                          onPressed: () {
                            setState(() {
                              isFullScreen = !isFullScreen;
                              if (isFullScreen) {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.landscapeRight,
                                  DeviceOrientation.landscapeLeft,
                                ]);
                              } else {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.portraitUp,
                                  DeviceOrientation.portraitDown,
                                ]);
                              }
                            });
                          },
                          child: Icon(
                            isFullScreen
                                ? Icons.fullscreen_exit
                                : Icons.fullscreen,
                            color: Colors.indigoAccent,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Please Wait it Takes - 10 to 12 Seconds to load the LIVE Stream",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  Text(
                    titlemain,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodySmall,
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  const Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                    child: LinearProgressIndicator(),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
          : Stack(
        children: [
          InAppWebView(
            initialUrlRequest:
            URLRequest(url: WebUri.uri(Uri.parse(args.data))),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                  disableVerticalScroll: true,
                  disableHorizontalScroll: true,
                  disableContextMenu: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                  useOnLoadResource: true,
                  clearCache: true
                // useShouldOverrideUrlLoading: true,
                // mediaPlaybackRequiresUserGesture: false,
              ),
              ios: IOSInAppWebViewOptions(
                allowsInlineMediaPlayback: true,
                allowsBackForwardNavigationGestures: false,
                scrollsToTop: true,
                automaticallyAdjustsScrollIndicatorInsets: true,
              ),
            ),
            onLoadStart: (controller, url) {
              setState(() {
                isLoading = true;
              });
            },
            onLoadError: (controller, url, code, message) {
              setState(() {
                isLoading = false;
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                isLoading = false;
              });
              controller.evaluateJavascript(source: '''
            var style = document.createElement('style');
            style.innerHTML = `
              .right { display: none !important; }

            `;
            document.head.appendChild(style);

          ''');
            },
          ),
          isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Container(),
        ],
      ),

      // SingleChildScrollView(
      //   child: Container(
      //     alignment: Alignment.center,
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: <Widget>[
      //         InteractiveViewer(
      //           panEnabled: false,
      //           alignPanAxis: true,
      //           // Set it to false to prevent panning.
      //           // boundaryMargin: EdgeInsets.all(80),
      //
      //           minScale: 0.5,
      //           maxScale: 10,
      //           child: VlcPlayer(
      //             controller: _videoPlayerController!,
      //             aspectRatio: 16 / 7,
      //             placeholder: const Center(child: CircularProgressIndicator()),
      //           ),
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.all(20),
      //           child: Text(
      //             "Please Wait it Takes - 10 to 12 Seconds to load the LIVE Stream",
      //             style: GoogleFonts.poppins(
      //               textStyle: Theme.of(context).textTheme.bodySmall,
      //               fontSize: 18,
      //               fontWeight: FontWeight.w400,
      //               fontStyle: FontStyle.normal,
      //             ),
      //           ),
      //         ),
      //         ElevatedButton(
      //           style: style,
      //           onPressed: () {
      //             SystemChrome.setPreferredOrientations([
      //               DeviceOrientation.landscapeRight,
      //               DeviceOrientation.landscapeLeft,
      //             ]);
      //           },
      //           child: const Icon(
      //             Icons.fullscreen,
      //             color: Colors.indigoAccent,
      //             size: 30.0,
      //           ),
      //         ),
      //         Text(
      //           titlemain,
      //           style: GoogleFonts.poppins(
      //             textStyle: Theme.of(context).textTheme.bodySmall,
      //             fontSize: 20,
      //             color: Colors.black,
      //             fontWeight: FontWeight.w500,
      //             fontStyle: FontStyle.normal,
      //           ),
      //         ),
      //         const Padding(
      //           padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
      //           child: LinearProgressIndicator(),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
    _showToast(context);
  }
}

class DialogBuilder {
  DialogBuilder(this.context);

  final BuildContext context;

  void showLoadingIndicator() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              backgroundColor: Colors.black87,
              content: LoadingIndicator(text: "Loading Stream"),
            ));
      },
    );
  }

  void hideOpenDialog() {
    Navigator.of(context).pop();
  }
}

class LoadingIndicator extends StatelessWidget {
  LoadingIndicator({this.text = ''});

  final String text;

  @override
  Widget build(BuildContext context) {
    var displayedText = text;

    return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.black87,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _getLoadingIndicator(),
              _getHeading(context),
              _getText(displayedText)
            ]));
  }

  Padding _getLoadingIndicator() {
    return Padding(
        child: Container(
            child: const CircularProgressIndicator(strokeWidth: 3),
            width: 32,
            height: 32),
        padding: const EdgeInsets.only(bottom: 16));
  }

  Widget _getHeading(context) {
    return const Padding(
        child: Text(
          'Please wait …',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        padding: EdgeInsets.only(bottom: 4));
  }

  Text _getText(String displayedText) {
    return Text(
      displayedText,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      textAlign: TextAlign.center,
    );
  }
}
