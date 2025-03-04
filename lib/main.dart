import 'package:darbar_app_of_kambar_darbar/medical/medical_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:darbar_app_of_kambar_darbar/darbar_events/events_screen.dart';
import 'package:darbar_app_of_kambar_darbar/live_darshan/live_stream_screen.dart';
import 'package:darbar_app_of_kambar_darbar/live_darshan/live_stream_categories.dart';
import 'package:darbar_app_of_kambar_darbar/quiz_links.dart';
import 'package:darbar_app_of_kambar_darbar/darbar_events/events_screen.dart';
import 'package:darbar_app_of_kambar_darbar/home_screen/homepage.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
import 'package:darbar_app_of_kambar_darbar/aboutus/about_screen.dart';
import 'package:darbar_app_of_kambar_darbar/programs/programs_screen.dart';
import 'package:darbar_app_of_kambar_darbar/programs/youtube_screen.dart';
import 'package:darbar_app_of_kambar_darbar/contact_us/contact_screen.dart';
import 'package:darbar_app_of_kambar_darbar/medical/medical_screen.dart';
import 'package:darbar_app_of_kambar_darbar/photo_gallery/photo_gallery_screen.dart';
import 'package:darbar_app_of_kambar_darbar/ImageDetail.dart';
import 'package:darbar_app_of_kambar_darbar/scholarships/scholarship_screen.dart';
import 'package:darbar_app_of_kambar_darbar/carousals_tour_page/tour.dart';
import 'package:darbar_app_of_kambar_darbar/testnew.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen/image_one/Sai1.dart';
import 'home_screen/image_three/Sai3.dart';
import 'home_screen/image_two/Sai2.dart';
import 'medical/MedicalDetails.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kambar Darbar',
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const HomePage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/livestream': (context) => const LiveStreamCategories(),
        '/livevideo': (context) => const LiveStreamScreen(),
        '/quiz': (context) => const QuizLinks(),
        '/events': (context) => const EventsScreen(),
        '/about': (context) => const AboutScreen(),
        '/programs': (context) => const ProgramsScreen(),
        '/youtube': (context) => const YoutubeScreen(),
        '/contact': (context) => const ContactScreen(),
        '/medical': (context) => const MedicalScreen(),
        '/photogallery': (context) => const PhotoGalleryScreen(),
        '/imagedetail': (context) => const ImageDetailScreen(),
        '/scholarship': (context) => const ScholarshipScreen(),
        '/medicaldetails': (context) => const MedicalDetailsScreen(),
        '/testnew': (context) => const TestNewScreen(),
        '/sai1': (context) => const Sai1(),
        '/sai2': (context) => const Sai2(),
        '/sai3': (context) => const Sai3(),
        '/tour': (context) => const TourPage(),
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
