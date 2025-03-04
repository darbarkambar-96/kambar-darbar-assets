import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
import 'package:http/http.dart' as http;


class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late Future<List<Events>> futurelinks;
  List<Events> links =[];


  Future<List<Events>> fetchAlbum() async {

    final response = await http
        .get(Uri.parse('https://www.classic24digital.com/kambardarbar/eventsapi.php'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = json.decode(response.body.toString());

      for(Map i in data)
      {
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Text('Events at Darbar',style: GoogleFonts.poppins(
          textStyle: Theme.of(context).textTheme.bodySmall,
          fontSize: 20,
          color: Colors.indigoAccent,
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
        ),),
        leading:Image.asset('assets/img/vjvlogo.png'),

      ),
      body:
      Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading:Image.asset('assets/img/shiv.png'),
              title: Text('Mahashivratri',style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodySmall,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),),
              subtitle: Text('1st March 2022 - 7 to 9:30 pm'),
            ),
            ListTile(
              leading:Image.asset('assets/img/calendar.png'),
              title: Text('Chetichand',style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodySmall,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),),
              subtitle: Text('2nd April 2022 - 7 to 9:30 pm'),
            ),
            ListTile(
              leading:Image.asset('assets/img/calendar.png'),
              title: Text('Mata Chainibai Anniversary',style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodySmall,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),),
              subtitle: Text('14th may 2022'),
            ),
            ListTile(
              leading:Image.asset('assets/img/calendar.png'),
              title: Text('Geet Utsav by ISKCON',style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodySmall,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),),
              subtitle: Text('4th July 2022 to 11th July 2022'),
            ),
            ListTile(
              leading:Image.asset('assets/img/calendar.png'),
              title: Text('Gurupurnima',style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodySmall,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),),
              subtitle: Text('13th July 2022'),
            ),
            ListTile(
              leading:Image.asset('assets/img/calendar.png'),
              title: Text('Krishna Janmashtami',style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodySmall,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),),
              subtitle: Text('19th August 2022'),
            ),
            ListTile(
              leading:Image.asset('assets/img/calendar.png'),
              title: Text('Sai Vilayatrai Birthday',style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodySmall,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),),
              subtitle: Text('19th August 2022'),
            ),
            ListTile(
              leading:Image.asset('assets/img/calendar.png'),
              title: Text('Saijans Shradh',style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodySmall,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),),
              subtitle: Text('22nd September 2022 - 9 am'),
            ),
            ListTile(
              leading:Image.asset('assets/img/calendar.png'),
              title: Text('Sai Vishindas Varsi',style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodySmall,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),),
              subtitle: Text('6th October 2022'),
            ),
            ListTile(
              leading:Image.asset('assets/img/calendar.png'),
              title: Text('Geeta Utsav by ISKCON',style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodySmall,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),),
              subtitle: Text('4th July 2022 to 11th July 2022'),
            ),
            ListTile(
              leading:Image.asset('assets/img/calendar.png'),
              title: Text('Sai Vishindas Varsi',style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodySmall,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),),
              subtitle: Text('6th October 2022'),
            ),
            ListTile(
              leading:Image.asset('assets/img/calendar.png'),
              title: Text('Geeta Utsav by ISKCON',style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodySmall,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),),
              subtitle: Text('4th July 2022 to 11th July 2022'),
            ),
          ],
        ),
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
    return Events(
      Id: int.parse(json['Id'].toString()),
      Name: json['Name'],
      Icon: json['Icon'],
      Date: json['Date'],
      Time: json['Time'],
    );
  }
}
