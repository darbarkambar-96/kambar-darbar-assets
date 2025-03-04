import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
import 'package:accordion/accordion.dart';
import 'package:darbar_app_of_kambar_darbar/common_files/common.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

import 'package:loading_animation_widget/loading_animation_widget.dart';

class MedicalScreen extends StatefulWidget {
  const MedicalScreen({Key? key}) : super(key: key);

  @override
  _MedicalScreenState createState() => _MedicalScreenState();
}

class _MedicalScreenState extends State<MedicalScreen> {
  late Future<List<MedicalCategories>> futureMedicalCategories;

  List<MedicalCategories> categories = [];

  Future<List<MedicalCategories>> fetchAlbum() async {
    final response = await http.get(Uri.parse(
        'https://www.classic24digital.com/kambardarbar/medicalcatapi.php'));

    if (response.statusCode == 200) {
      debugPrint('Medical screen');
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = json.decode(response.body.toString());

      for (Map i in data) {
        categories.add(MedicalCategories.fromJson(i));
      }
      return categories;
    } else {
      return categories;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (Platform.isAndroid)
          ? AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                'Medical Facilities',
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
                'Medical Facilities',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 20,
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: fetchAlbum(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 1, // Set elevation to 2
                            color: Colors.white, // Set background color to white
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/medicaldetails',
                                        arguments: ScreenArguments(
                                            categories[index].Id,
                                            categories[index].title,
                                            1));
                                  },
                                  leading: Image.network(
                                    common.commonurl +
                                        'images/' +
                                        categories[index].iconsrc,
                                    height: 35,
                                    width: 35,
                                  ),
                                  trailing: Icon(Icons.chevron_right_rounded),
                                  title: Text(
                                    categories[index].title,
                                    style: GoogleFonts.poppins(
                                      textStyle: Theme.of(context).textTheme.bodySmall,
                                      fontSize: 16,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );

                        });
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
                      child: LoadingAnimationWidget.stretchedDots(
                        color: Colors.indigoAccent,
                        size: 50,
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}

class MedicalCategories {
  final int Id;
  final String iconsrc;
  final String title;

  const MedicalCategories({
    required this.Id,
    required this.iconsrc,
    required this.title,
  });

  factory MedicalCategories.fromJson(dynamic json) {
    return MedicalCategories(
      Id: int.parse(json['Id'].toString()),
      iconsrc: json['Icon'],
      title: json['Name'],
    );
  }
}
