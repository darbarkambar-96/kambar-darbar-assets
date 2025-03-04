import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _counter2;

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int decision = (prefs.getInt('firstlaunch') ?? 0);
    if (decision == 0) {
      //first launch
      Navigator.pushNamed(context, '/tour');
    } else {}
  }

  int _counter = 0;

  @override
  void initState() {
    _incrementCounter();
    super.initState();
  }

  void togglelanguageoptions() {
    if (_counter == 0) {
      setState(() {
        _counter = 1;
      });
      debugPrint("now set to 1");
    } else {
      setState(() {
        _counter = 0;
      });
      debugPrint("now set to 0");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Kambar Darbar',
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.bodySmall,
            fontSize: 20,
            color: Colors.indigoAccent,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
          ),
        ),
        leading: Image.asset('assets/img/vjvlogo.png'),
        actions: [
          TextButton(
            onPressed: () {
              togglelanguageoptions();
            },
            child: (_counter == 0)
                ? Text(
                    'हिंदी',
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodySmall,
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  )
                : Text(
                    'English',
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodySmall,
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromRGBO(223, 224, 208, 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/sai3',
                              arguments: ScreenArguments(
                                  1,
                                  "rtsp://admin:Globotech@12345@116.73.65.158:554/streaming/channels/104",
                                  1));
                        },
                        child: Image.asset('assets/img/top1.png'),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/sai1',
                              arguments: ScreenArguments(
                                  1,
                                  "rtsp://admin:Globotech@12345@116.73.65.158:554/streaming/channels/104",
                                  1));
                        },
                        child: Image.asset('assets/img/top2.png'),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/sai2',
                              arguments: ScreenArguments(
                                  1,
                                  "rtsp://admin:Globotech@12345@116.73.65.158:554/streaming/channels/104",
                                  1));
                        },
                        child: Image.asset('assets/img/top3.png'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5,),
                Image.network(
                  'https://www.classic24digital.com/kambardarbarscreen.jpg',
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: LoadingAnimationWidget.stretchedDots(
                        color: Colors.indigoAccent,
                        size: 50,
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Container();
                  },
                ),
                const SizedBox(height: 5,),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/livestream',
                              arguments: ScreenArguments(
                                  1,
                                  "rtsp://admin:Globotech@12345@116.73.65.158:554/streaming/channels/104",
                                  1));
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Image.asset(
                                  'assets/img/live-streaming.png',
                                  width: 80,
                                ),
                                const Divider(
                                  height: 20,
                                  thickness: 2,
                                  endIndent: 0,
                                  color: Colors.black,
                                ),
                                if (_counter == 0)
                                  Text(
                                    "Live Darshan",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  )
                                else
                                  Text(
                                    "लाइव दर्शन",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/events');
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Image.asset(
                                  'assets/img/eventsnew.png',
                                  width: 80,
                                ),
                                const Divider(
                                  height: 20,
                                  thickness: 2,
                                  endIndent: 0,
                                  color: Colors.black,
                                ),
                                if (_counter == 0)
                                  Text(
                                    "Darbar Events",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  )
                                else
                                  Text(
                                    "इवेंट्स ",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/programs');
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Image.asset(
                                  'assets/img/programsnew.png',
                                  width: 80,
                                ),
                                const Divider(
                                  height: 20,
                                  thickness: 2,
                                  endIndent: 0,
                                  color: Colors.black,
                                ),
                                if (_counter == 0)
                                  Text(
                                    "Programs",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  )
                                else
                                  Text(
                                    "कार्यक्रम",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/scholarship');
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Image.asset(
                                  'assets/img/scholarshipnew.png',
                                  width: 80,
                                ),
                                const Divider(
                                  height: 20,
                                  thickness: 2,
                                  endIndent: 0,
                                  color: Colors.black,
                                ),
                                if (_counter == 0)
                                  Text(
                                    "Scholarships",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  )
                                else
                                  Text(
                                    "स्कॉलरशिप्स",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/medical');
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Image.asset(
                                  'assets/img/medical.png',
                                  width: 80,
                                ),
                                const Divider(
                                  height: 20,
                                  thickness: 2,
                                  endIndent: 0,
                                  color: Colors.black,
                                ),
                                if (_counter == 0)
                                  Text(
                                    "Medical",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  )
                                else
                                  Text(
                                    "मेडिकल सुविधाएं",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/photogallery');
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Image.asset(
                                  'assets/img/photo2.png',
                                  width: 80,
                                ),
                                const Divider(
                                  height: 20,
                                  thickness: 2,
                                  endIndent: 0,
                                  color: Colors.black,
                                ),
                                if (_counter == 0)
                                  Text(
                                    "Photo Gallery",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  )
                                else
                                  Text(
                                    "फोटो गैलरी ",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/about');
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Image.asset(
                                  'assets/img/aboutnew.png',
                                  width: 80,
                                ),
                                const Divider(
                                  height: 20,
                                  thickness: 2,
                                  endIndent: 0,
                                  color: Colors.black,
                                ),
                                if (_counter == 0)
                                  Text(
                                    "About Darbar",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  )
                                else
                                  Text(
                                    "दरबार की जानकारी ",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/contact');
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Image.asset(
                                  'assets/img/contactnew.png',
                                  width: 80,
                                ),
                                const Divider(
                                  height: 20,
                                  thickness: 2,
                                  endIndent: 0,
                                  color: Colors.black,
                                ),
                                if (_counter == 0)
                                  Text(
                                    "Contact Darbar",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  )
                                else
                                  Text(
                                    "संपर्क ",
                                    style: GoogleFonts.poppins(
                                      textStyle:
                                          Theme.of(context).textTheme.bodySmall,
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Image.asset(
                        'assets/img/quote.jpg',
                        width: 80,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
