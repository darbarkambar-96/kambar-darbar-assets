
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:io' show Platform;


class ImageDetailScreen extends StatefulWidget {
  const ImageDetailScreen({Key? key}) : super(key: key);

  @override
  _ImageDetailScreenState createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {


  @override
  void initState()
  {

    super.initState();

  }

  @override
  void dispose() async {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments2;
    return Scaffold(
        appBar: (Platform.isAndroid) ? AppBar(
        backgroundColor: Colors.white,
        title:  Text('Photos - Kambar Darbar',style: GoogleFonts.poppins(
          textStyle: Theme.of(context).textTheme.bodySmall,
          fontSize: 20,
          color: Colors.indigoAccent,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
    ),),
    

    ): AppBar(
          backgroundColor: Colors.white,
          title: Text('Image Details', style: GoogleFonts.poppins(
            textStyle: Theme
                .of(context)
                .textTheme
                .bodySmall,
            fontSize: 20,
            color: Colors.indigoAccent,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
          ),),
          ),
    body: Column(
        children: [
          AspectRatio(aspectRatio: 1,
          child: Container(
              width: double.infinity,
              child:
              InteractiveViewer(
                panEnabled: false,
                // alignPanAxis: true,
                // Set it to false to prevent panning.
                // boundaryMargin: EdgeInsets.all(80),
                minScale: 0.5,
                maxScale: 10,
                child: Image.network(args.data),
              ),
              ),
            )


        ],





      )
    );
  }
}

