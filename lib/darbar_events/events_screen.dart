import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
import 'package:http/http.dart' as http;
import 'package:darbar_app_of_kambar_darbar/common_files/common.dart';
import 'dart:io' show Platform;

import 'package:loading_animation_widget/loading_animation_widget.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late Future<List<Events>> futurelinks;
  List<Events> links = [];

  Future<List<Events>> fetchAlbum() async {
    final response = await http.get(Uri.parse(
        'https://www.classic24digital.com/kambardarbar/eventsapi.php'));

    if (response.statusCode == 200) {
      debugPrint('URL');
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = json.decode(response.body.toString());
      debugPrint(data.toString());
      debugPrint('data.toString()');

      for (Map i in data) {
        links.add(Events.fromJson(i));
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
                'Events at Darbar',
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
                'Events at Darbar',
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
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              leading:  Image.asset(
                                'assets/img/vjvlogo.png',
                                width: 50,
                              ),
                              title: Text(
                                links[index].Name,
                                style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.bodySmall,
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              subtitle: Text(
                                '${links[index].Date} - ${links[index].Time}',
                                style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.bodySmall,
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              onTap: () {
                                // Handle onTap event
                              },
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

class Events {
  final int Id;
  final String Name;
  final String Icon;
  final String Date;
  final String Time;

  const Events({
    required this.Id,
    required this.Name,
    required this.Icon,
    required this.Date,
    required this.Time,
  });

  factory Events.fromJson(dynamic json) {
    print(json);
    return Events(
      Id: int.parse(json['Id'].toString()),
      Name: json['Name'],
      Icon: json['Icon'],
      Date: json['Date'],
      Time: json['Time'],
    );
  }
}
