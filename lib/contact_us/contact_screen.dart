import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  void launchMap(String address) async {
    String query = Uri.encodeComponent(address);
    debugPrint('Google url $query');
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    }
  }

  static void openMap(String address) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunch(googleUrl) != null) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (Platform.isAndroid)
          ? AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              title: Text(
                'Contact Darbar',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 20,
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
            )
          : AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                'Contact Darbar',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 20,
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
      body: Container(
          color: const Color.fromRGBO(223, 224, 208, 1),
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  openMap('Kambar Darbar');
                },
                child: Image.asset('assets/img/map.png'),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 40),
                //apply padding horizontal or vertical only
                child: Text(
                  "Address : Kambar Darbar, Near Mayur Cinema, Shantilal Modi Road, Opp Bhurabhai Arogya Bhuvan, Kandivali West, Mumbai - 400067",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodySmall,
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 1,
                endIndent: 0,
                color: Colors.black12,
              ),
              TextButton(
                onPressed: () => launchUrl(Uri.parse("tel://918976081672")),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Contact : +91 8976081672',
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodySmall,
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 1,
                endIndent: 0,
                color: Colors.black12,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Timings : 10 AM - 2 PM / 6 - 8 PM",
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
          )),
    );
  }
}
