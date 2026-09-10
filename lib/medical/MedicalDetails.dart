import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vlc_player_16kb/flutter_vlc_player.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
import 'package:accordion/accordion.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

class MedicalDetailsScreen extends StatefulWidget {
  const MedicalDetailsScreen({Key? key}) : super(key: key);

  @override
  _MedicalDetailsScreenState createState() => _MedicalDetailsScreenState();
}

class _MedicalDetailsScreenState extends State<MedicalDetailsScreen> {
  List<MedicalDoctors> categories = [];
  int catid = 0;
  String cattitle = "";

  Future<List<MedicalDoctors>> fetchAlbum() async {
    final response = await http.get(Uri.parse(
        'https://www.classic24digital.com/kambardarbar/medicaldoctorsapi.php?catid=' +
            catid.toString()));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = json.decode(response.body.toString());
      debugPrint('Data Printed: $data');
      for (Map i in data) {
        categories.add(MedicalDoctors.fromJson(i));
      }
      return categories;
    } else {
      return categories;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    catid = args.id;
    cattitle = args.data.toString();
    return Scaffold(
      appBar: (Platform.isAndroid)
          ? AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                args.data,
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
                args.data,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 20,
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
      body: FutureBuilder(
        future: fetchAlbum(), // Replace with your future function
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                ListView.builder(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  itemCount: categories.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/img/doctor-logo.png'),
                        ),
                        // trailing: Icon(Icons.chevron_right_rounded),
                        title: Text(
                          categories[index].Name,
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall,
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        subtitle: Text(
                          categories[index].DayTime,
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall,
                            fontSize: 12,
                            color: Colors.black,
                            // fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.all(5),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       CircleAvatar(
                      //         radius: 40,
                      //         backgroundImage: AssetImage('assets/img/doctor-logo.png'),
                      //       ),
                      //       SizedBox(height: 5),
                      //       Text(
                      //         categories[index].Name,
                      //         textAlign: TextAlign.center,
                      //         style: GoogleFonts.poppins(
                      //           textStyle: Theme.of(context)
                      //               .textTheme
                      //               .bodySmall,
                      //           fontSize: 18,
                      //           color: Colors.black,
                      //           fontWeight: FontWeight.w600,
                      //           fontStyle: FontStyle.normal,
                      //         ),
                      //       ),
                      //       Text(
                      //         args.data,
                      //         textAlign: TextAlign.center,
                      //         style: GoogleFonts.poppins(
                      //           textStyle: Theme.of(context)
                      //               .textTheme
                      //               .bodySmall,
                      //           fontSize: 10,
                      //           color: Colors.grey,
                      //           fontStyle: FontStyle.normal,
                      //         ),
                      //       ),
                      //       SizedBox(height: 10),
                      //       Text(
                      //         categories[index].DayTime,
                      //         style: GoogleFonts.poppins(
                      //           textStyle: Theme.of(context)
                      //               .textTheme
                      //               .bodySmall,
                      //           fontSize: 14,
                      //           color: Colors.black,
                      //           // fontWeight: FontWeight.w500,
                      //           fontStyle: FontStyle.normal,
                      //         ),
                      //         textAlign: TextAlign.center,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    );
                  },
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/img/no_internet.png',height: 100,width: 100,),
                  Text(
                    'Please connect to a good internet.',
                    style: GoogleFonts.poppins(
                      textStyle:
                      Theme.of(context).textTheme.bodyMedium,
                      fontSize: 18,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            ); // Show loading indicator
          }
        },
      ),

    );
  }
}

class MedicalDoctors {
  final int Id;
  final String Name;
  final String DayTime;

  const MedicalDoctors({
    required this.Id,
    required this.Name,
    required this.DayTime,
  });

  factory MedicalDoctors.fromJson(dynamic json) {
    return MedicalDoctors(
      Id: int.parse(json['Id'].toString()),
      Name: json['Name'],
      DayTime: json['DayTime'],
    );
  }
}
