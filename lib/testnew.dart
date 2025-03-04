
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TestNewScreen extends StatefulWidget {
  const TestNewScreen({Key? key}) : super(key: key);

  @override
  _TestNewScreenState createState() => _TestNewScreenState();
}
class _TestNewScreenState extends State<TestNewScreen> {
  VlcPlayerController _vlcViewController = new VlcPlayerController.network(
    "rtsp://admin:Globotech@12345@116.73.65.158:1026/streaming/channels/101",
    autoPlay: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hello world"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new VlcPlayer(
              controller: _vlcViewController,
              aspectRatio: 16 / 9,
              placeholder: Text("Hello World"),
            ),
          ],
        ),
      ),
    );
  }
}

