import 'package:flutter/material.dart';
import 'package:flutter_vlc_player_16kb/flutter_vlc_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class Sai3 extends StatefulWidget {
  const Sai3({Key? key}) : super(key: key);

  @override
  _Sai3State createState() => _Sai3State();
}

class _Sai3State extends State<Sai3> {



  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:(Platform.isAndroid) ? AppBar(
        backgroundColor: Colors.white,
        title:  Text('Jeevani of Sai Vishindas Sahib',style: GoogleFonts.poppins(
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
                Text("Son of Shri Karamchand Sainani, Vishindas was born in 1889 as a still baby at Kambar. When Sai Jiwatsingh was informed about this, he said the child is very much alive and is merely pretending to be lifeless, in protest against Sai Jiwatsingh's absence at the time of child's birth. As soon as Sai Jiwatsingh reached near him, the child started moving his limbs and crying. Vishindas was a King in his last birth, who had renounced his kingdom and spent his life in Yoga and meditation. He had taken birth again to complete the balance Yogic work left over in his previous birth. ",  style: GoogleFonts.poppins(
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
                    child : Text("Young Age",  style: GoogleFonts.poppins(
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
                Text("Expectedly Vishin was very bright in his young age and grasped school lessons very fast, but did not have much interest in learning at school. He stayed with his sister in a distant city of Sukkur for better schooling. Once he told his sister he didn't want to study and would like to go to Kambar to his parents, for which he was scolded by his sister. Within few hours of this instance, a telegram came from his father to his sister to send Vishin immediately to Kambar as he has to take charge of Darbar, seeing which the sister was shocked, as to how Vishin knew everything in advance. Thus at the age of 14 he was asked to take charge of Kambar Darbar, which his father was looking after as caretaker for about 4 years after Sai Jiwatsingh left for heavenly abode. Vishindas was the second youngest of five brothers and remained a bachelor and dedicated his life totally to the shewa of Kambar Darbar. The Saint in him always prevailed and Sai Vishindas continued the learning of various Shastras (including the Granth Saheb) in great depth and also practiced what he learnt.",  style: GoogleFonts.poppins(
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
                    child : Text("Spiritual Domain",  style: GoogleFonts.poppins(
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
                Text("",
                  style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),),
                Text("Sai Vishindas lived a life full of humility and kindness, compassion and love. He practiced intense meditation. His speedy spiritual advancement bestowed on him divine powers which along with above virtues pulled the Darbar's devotees and satsangis towards him. Sai Vishindas continued the free dispensary started by Guru Sai Jiwatsingh, for alleviating the troubles of whoever came to him. This practice of FREE/lowest medical cost treatment is still continuing, and covered many specialities, as Ophtal, (Eyes), Nephro (Kidney), Skin, Ortho (Bones), Gyanac (Including Cervial Cancer), Dental, Child-specialist, Heart & Diabetes, Spine, Homeo, ENT, etc. ",
                  style: GoogleFonts.poppins(
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
                Text("Sai Vishindas used his divine powers on numerous occasions for helping people in agony. He was very humble and always told the people that Saijans (his Gurus) were bestowing the Grace and not he himself.",
                  style: GoogleFonts.poppins(
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
                Text("Formation of Trust:",  style: GoogleFonts.poppins(
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
                Text("Sai Vishindas had the vision to foresee the problems expected during partition and the expected migration of Hindus to India. Hence, he decided to create a Trust for managing the affairs of Kambar Darbar. The Board of Trustees have constructed Kambar Darbar at Kandivali (Mumbai) and are managing the affairs in consultation with the spiritual head. He entered Maha-Samadhi in 1942, at the age of 53.",
                  style: GoogleFonts.poppins( textStyle: Theme.of(context).textTheme.bodySmall,
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

