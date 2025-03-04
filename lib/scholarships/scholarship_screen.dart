import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
import 'package:accordion/accordion.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class ScholarshipScreen extends StatefulWidget {
  const ScholarshipScreen({Key? key}) : super(key: key);

  @override
  _ScholarshipScreenState createState() => _ScholarshipScreenState();
}

class _ScholarshipScreenState extends State<ScholarshipScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (Platform.isAndroid)
          ? AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                'Scholarship',
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
                'Scholarship',
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
        color: Colors.indigo,
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Text(
              "SAI VILAYATRAI SCHOLARSHIP SCHEME FOR PROFESSIONAL COURSES",
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodySmall,
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Sai Vilayatrai Charitable Trust, Mumbai a non-profit & charitable organization grants educational scholarships every year of an amount ranging upto Rs 20,000/- per year to meritorious & needy students for studying higher professional courses.",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Following students are eligible for scholarship:",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "1. Studying Engineering, MCA, BIT, CA, IPCC, CPT, CFA, C S, Pharma, B Arch, MBA (reputed institute with above 70% marks in graduate program), Medicine, BDS.",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "2. Also eligible high school students who have scored more than 80%  marks in SSC in English medium and are preparing for higher professional courses.",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Application for grant of scholarship is to be made in the prescribed form a copy of which can be downloaded from our website www.kambardarbar.org. Applications must be always accompanied with attested copies of ALL the enclosures asked in the application form.",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "For any clarification please contact: p_sainani@rediffmail.com.",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "NO PHONE CALLS WILL BE ACCEPTED.",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {
                      _launchInBrowser(
                          "http://docs.google.com/viewer?url=https://www.classic24digital.com/kambardarbar/Scholarship_form.pdf");
                    },
                    child: Text('Download Form'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
