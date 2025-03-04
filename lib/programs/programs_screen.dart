import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments2.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({Key? key}) : super(key: key);

  @override
  _ProgramsScreenState createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  late Future<List<ProgramLinks>> futurelinks;
  List<ProgramLinks> links = [];

  Future<List<ProgramLinks>> fetchAlbum() async {
    final response = await http.get(Uri.parse(
        'https://www.classic24digital.com/kambardarbar/programlinksapi.php'));

    if (response.statusCode == 200) {
      debugPrint('programs API call');
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = json.decode(response.body.toString());

      for (Map i in data) {
        links.add(ProgramLinks.fromJson(i));
      }
      return links;
    } else {
      return links;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (Platform.isAndroid)
          ? AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                'Video Gallery',
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
                'Video gallery',
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
                        itemCount: links.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/youtube',
                                  arguments: ScreenArguments2(1,
                                      links[index].link, links[index].title));
                            },
                            child: Card(
                              color: Colors.white,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                    ),
                                    child: Image.network(
                                      'https://img.youtube.com/vi/${links[index].link}/0.jpg',
                                      width: double.infinity,
                                      // Make the image take the full width
                                      fit: BoxFit
                                          .cover, // Ensure the image covers the entire space
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                        border:
                                            Border(top: BorderSide(width: 1))),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    alignment: Alignment.center,
                                    child: Text(
                                      links[index].title,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                          //   Card(
                          //   color: Colors.white,
                          //   child: InkWell(
                          //     onTap: () {
                          //       Navigator.pushNamed(context, '/youtube',
                          //           arguments: ScreenArguments2(1,
                          //               links[index].link, links[index].title));
                          //     },
                          //     child: Container(
                          //       padding: EdgeInsets.all(5),
                          //       alignment: Alignment.center,
                          //       child: Column(
                          //         mainAxisSize: MainAxisSize.min,
                          //         children: <Widget>[
                          //           Image.network(
                          //               'https://img.youtube.com/vi/' +
                          //                   links[index].link +
                          //                   '/0.jpg'),
                          //           new Padding(
                          //             padding: EdgeInsets.only(
                          //                 top: 10,
                          //                 left: 5,
                          //                 right: 5,
                          //                 bottom: 10),
                          //             child: Text(
                          //               links[index].title,
                          //               style: GoogleFonts.poppins(
                          //                 textStyle: Theme.of(context)
                          //                     .textTheme
                          //                     .bodySmall,
                          //                 fontSize: 18,
                          //                 color: Colors.black,
                          //                 fontWeight: FontWeight.w500,
                          //                 fontStyle: FontStyle.normal,
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // );
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

class ProgramLinks {
  final int Id;
  final String link;
  final String title;

  const ProgramLinks(
      {required this.Id, required this.link, required this.title});

  factory ProgramLinks.fromJson(dynamic json) {
    return ProgramLinks(
      Id: int.parse(json['Id'].toString()),
      link: json['Youtubelink'],
      title: json['Title'],
    );
  }
}
