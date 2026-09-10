import 'package:flutter/material.dart';
import 'package:flutter_vlc_player_16kb/flutter_vlc_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';


class QuizLinks extends StatefulWidget {
  const QuizLinks({Key? key}) : super(key: key);

  @override
  _QuizLinksState createState() => _QuizLinksState();
}

class _QuizLinksState extends State<QuizLinks> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Text('Quiz Links',style: GoogleFonts.poppins(
          textStyle: Theme.of(context).textTheme.bodySmall,
          fontSize: 20,
          color: Colors.indigoAccent,
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
        ),),
        

      ),
      body:
      Container(
          child: ListView(
        children: <Widget>[
        ListTile(
            leading:Image.asset('assets/img/quiz.png'),
            title: Text('Quiz Link 1',style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.bodySmall,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),),
            ),
            ListTile(
              leading:Image.asset('assets/img/quiz.png'),
              title: Text('Quiz Link 2',style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodySmall,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),),
            ),
            ListTile(
              leading:Image.asset('assets/img/quiz.png'),
              title: Text('Quiz Link 3',style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodySmall,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),),
            ),

          ],
        ),
        ),

    );
  }
}

