import 'package:flutter/material.dart';
import 'package:flutter_vlc_player_16kb/flutter_vlc_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class Sai2 extends StatefulWidget {
  const Sai2({Key? key}) : super(key: key);

  @override
  _Sai2State createState() => _Sai2State();
}

class _Sai2State extends State<Sai2> {



  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: (Platform.isAndroid) ? AppBar(
        backgroundColor: Colors.white,
        title:  Text('Jeevani of Sai Jiwatsingh Sahib',style: GoogleFonts.poppins(
          textStyle: Theme.of(context).textTheme.bodySmall,
          fontSize: 20,
          color: Colors.indigoAccent,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
        ),),
        

      ): AppBar(
        backgroundColor: Colors.white,
        title: Text('Jeevani of Sai Vilayatrai Sahib', style: GoogleFonts.poppins(
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
      body:
      SingleChildScrollView(
        child : Container(
          color: const Color.fromRGBO(223, 224, 208, 1),
          child : Padding(
            padding:EdgeInsets.symmetric(vertical: 20,horizontal: 25),
            child :Column(
              children: <Widget>[
                const Divider(
                  height: 20,
                  thickness: 5,
                  indent: 10,
                  endIndent: 0,
                  color: Colors.black12,
                ),
                Align(
                    alignment: Alignment.center,
                    child : Text("Early Life",  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodySmall,
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.normal,
                    ),)),
                const Divider(
                  height: 20,
                  thickness: 5,
                  indent: 10,
                  endIndent: 0,
                  color: Colors.black12,
                ),
                Text("Born in 1831 to a rich \"Zamindar\" Shewaram Sainani at Kambar, Jiwat lost his father at a young age and was brought up by his mother and elder brothers, viz. Alimchand and Shamdas. Being the youngest, he was pampered and sort of spoilt.",  style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),),
                Text("Inspite of vast possessions of land, he joined the Police force to enjoy life. He was handsome, smartly dressed and used his physical powers and police influence to overcome his critics. Nobody dared to challenge him. He had also learnt black magic. His mother and brothers shed tears on his such indulgences.",  style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),),
                const Divider(
                  height: 20,
                  thickness: 5,
                  indent: 10,
                  endIndent: 0,
                  color: Colors.black12,
                ),
                Align(
                    alignment: Alignment.center,
                    child : Text("Spiritual Uplifment",  style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodySmall,
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.normal,
                    ),)),
                const Divider(
                  height: 20,
                  thickness: 5,
                  indent: 10,
                  endIndent: 0,
                  color: Colors.black12,
                ),
                Text("Jiwat's brother Shamdas approached Vali Vilayat Rai in desperation, in whom he had unflinching faith. Tempted by the prospect of learning even more about black magic from Vali Vilayat Rai, Jiwatsingh went to meet him. A single glance of Grace from the Guru was sufficient to transform Jiwat into a Saint. For some time, he lead a life of repentance and used to say \"Oh Jiwat, what have you done? You have wasted your life?\" Very soon, he became such a devoted disciple of Vali Vilayat Rai that anybody would like to emulate him. Vali Vilayat Rai bestowed his abundant grace on his beloved disciple who became a great saint, and also gave him a lot of divine powers.",  style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),),
                const Divider(
                  height: 20,
                  thickness: 5,
                  indent: 10,
                  endIndent: 0,
                  color: Colors.black12,
                ),
                Text("Subsequent Life",  style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.normal,
                ),),
                const Divider(
                  height: 20,
                  thickness: 5,
                  indent: 10,
                  endIndent: 0,
                  color: Colors.black12,
                ),
                Text("Sai Jiwatsingh’s life is that of a humble family man. He devoted his life to  selfless 'Sheva' of his Guru and surrendered himself completely to the Guru. ",  style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),),
                const Divider(
                  height: 20,
                  thickness: 5,
                  indent: 10,
                  endIndent: 0,
                  color: Colors.black12,
                ),
                Text("Miracles",  style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.normal,
                ),),
                const Divider(
                  height: 20,
                  thickness: 5,
                  indent: 10,
                  endIndent: 0,
                  color: Colors.black12,
                ),
                Text("In the process, Sai Jiwatsingh was bestowed by his Guru such divine powers that he could even bring even dead back to life. Quite a few such incidents happened. This practice did not meet his Guru's approval and so was asked to dispense medicines and give 'Rakhyas' and sacred thread to alleviate the agony of others which he started doing immediately; and this tradition continues till today. The dispensary also had its beginning at that  time.today it is multi-specialty medical centre with diagnostics, and other special features.",  style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),),
                const Divider(
                  height: 20,
                  thickness: 5,
                  indent: 10,
                  endIndent: 0,
                  color: Colors.black12,
                ),
                Text("Own Bhajans/Shabads",  style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.normal,
                ),),
                const Divider(
                  height: 20,
                  thickness: 5,
                  indent: 10,
                  endIndent: 0,
                  color: Colors.black12,
                ),
                  Text("Besides being a great 'Bhakta' he was also a great poet. His devotion and love for his Guru brought out spontaneous flow of hymns (bhajans) from within. He sang in praise of his Guru and his 'Ishtdev' - Lord Krishna. His Shabads are also indicators of the gradual stages of his spiritual advancement and his level of bliss for self-fulfilment. These bhajans are sung even today with great devotion.",  style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),),
                const Divider(
                  height: 20,
                  thickness: 5,
                  indent: 10,
                  endIndent: 0,
                  color: Colors.black12,
                ),
                Text("Leaving the world as per his own choice",  style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.normal,
                ),),
                const Divider(
                  height: 20,
                  thickness: 5,
                  indent: 10,
                  endIndent: 0,
                  color: Colors.black12,
                ),
                Text("Sai Jiwatsingh had been bestowed by his Guru the boon of Ichha-Mrityu. He wanted to depart from this world on same day and time as his Guru. He had to stay one year more for the same. To meet this objective he decided to leave this mortal world on 14 Jan 1899 although he was totally healthy, and nobody believed that he would depart on that night(early morning next day), which he had mentioned a year ago. Late evening on 14th Jan, he bid goodbye to all the well-wishers. He told them that he would sleep on the floor at 10:00 pm and started chanting \"Om\" which will stop exactly at 4:00 am on 15 Jan 1899 and at that time his atma would leave his body. This is exactly what happened. This was Sai Jaiwatsingh's power to decide his own date and time of leaving the material world.",
                  style: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodySmall,
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

