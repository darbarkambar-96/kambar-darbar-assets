import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player_16kb/flutter_vlc_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class Sai1 extends StatefulWidget {
  const Sai1({Key? key}) : super(key: key);

  @override
  _Sai1State createState() => _Sai1State();
}

class _Sai1State extends State<Sai1> {



  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: (!kIsWeb && Platform.isAndroid) ? AppBar(
        backgroundColor: Colors.white,
        title:  Text('Jeevani of Sai Vilayatrai Sahib',style: GoogleFonts.poppins(
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
                Text("Early Ages : \n Saijan was born in 1825 to Munshi Pratab Rai in Halla a village in Sindh, Pakistan. His mother was Mata Cheti Bai. Munshi Pratab Rai was a well to do person & served with the 'Mirs' as a munshi. In those days to be a munshi to the Mirs was a great thing as it was the munshis who ran affairs of the State",  style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),),
                Text("Right from younger days Vilayatrai was a very intelligent person & used to ask very intellectual questions from his teachers, who in those days were Muslim Kazis. After finishing his education, Vilayatrai applied for service with the Mirs, but by then the Britishers had come in & powers of Mirs were on the wane. Vilayat applied to the British & was appointed as 'Tapedar', who used to collect land revenue on behalf of the rulers. After some time in service, a mistake was detected in his accounts. A case was registered against Vilayat Rai & he was sentenced to prison.",  style: GoogleFonts.poppins(
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
                    child : Text("Divine Awakening",  style: GoogleFonts.poppins(
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
                Text("While in Jail, Vilayat got divine visit from Guru Nanak Devji, who told Vilayat, \"Why have you forgotten yourself? Discover yourself and remember why you have come in this world. In your previous birth you were a 'Jogi'. You have a lot to do in this world and people are waiting for you \". After this it was discovered that the charge under which Vilayat was sentenced, was false and Vilayat was released honorably.Vilayat along with his other colleagues, after office hours, used to meditate and they all used to chant Om…. Om….Om……… Vilayat’s spiritual fame started spreading and he kept on working as a Tapedar. On one occasion, their superior, Diwan Chanda Singh rebuked all the Tapedars calling them fools, because of mistake one of the Tapedars. The Tapedars resigned en-masse. Chanda Singh realized his mistake and asked them to withdraw their resignations. All did, but Vilayat didn’t.",  style: GoogleFonts.poppins(
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
                Text("On the Path of Parmarath",  style: GoogleFonts.poppins(
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
                Text("Vali Vilayat Rai's fame and his spiritual prowess kept on growing and so was his following. He shifted from Halla to Kambar and his daily religious discourses attracted a lot of 'Sangat' Munshi Shamdas, of Kambar was one of Vali's devotees ",  style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),),
                Text("One day he confided unto Vali about his younger brother who was leading a life of undue luxury, pomp and show. Further Shamdas said about his brother that he had started reading and practicing occult arts and thought himself to be a big occultic personality. He requested Vali Vilayat Rai to show proper path to his brother Jiwatsingh. Vali told Munshi Shamdas to bring Jiwatsingh to him and if does not listen , then tell him that Vilayat Rai is a great practitioner of the Occult and he will teach him some things. This evoked interest in Jiwatsingh and he presented himself before Vali Vilayat Rai and asked him, \"Where are your powers? Show me.\" Vali Vilayat Rai looked into eyes of Jiwatsingh, eye contact was established between the two men of God, the true spiritual leaders. That was the turning point in the life of Jiwatsingh. He went into a trance and started shouting, \"Oh Jiwat! What have you done. Oh Jiwat! What have you done.\" Jiwatsingh went into a shell which worried his brother, Munshi Shamdas and he came back to Vali Vilayat Rai and was reassured that this is only a passing phase, Jiwat has a lot to achieve in this world. He has Karmas of his previous birth to complete and attain great spiritual heights.Thereafter Jiwatsingh became the most devoted Shewak of Vali Vilayat Rai.",  style: GoogleFonts.poppins(
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
                Text("Divinity",  style: GoogleFonts.poppins(
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
                Text("Vali Vilayat Rai always protected his disciples and led them on the path of divinity. There are many tales demonstrating his divine prowess. One such incident is of year 1885 when Vali along with his followers visited Bhai Dayaram who was seriously ill and unable to even get up. As soon as Vali entered the room of Bhai Dayaram, amazingly Dayaram got tremendous strength, he got up from his cot and started doing 'parikarma' of the cot where Vali Vilayat Rai was sitting.",  style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),),
                Text("Everyone sitting there was taken aback and one woman shouted \"Oh God, Where was a man like this, when my only son was on his death bed\". After Parikarma, Bhai Dayaram came back to his cot and his pulse rate started going down. His wife beseeched Vali Vilayat Rai and said, \"Oh Vali, don't make me a widow\". Vali said \" What can I do. Someone has to go at this moment, if you people are not ready then I will have to go myself\". The lady replied, \"I don't know but I will not be a widow\". Upon this Vali Vilayatrai prepared himself for journey from this world but his own wife who was there said \"Oh Lord, you are saving one woman from being a widow and in turn you are making me a widow. It would be better that you take my life.” Vali replied “OK. Be that as it may. Be prepared to depart from this world\". Having said that Vali Vilayat Rai moved away from there. His wife acquired the same disease as Bhai Dayaram and within a short time she departed from this world, in the hands of her husband. Vali Vilayat Rai completed the 12th day ceremony of his wife's demise and came back to Kambar. Bhai Dayaram lived his normal life.",
                  style: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodySmall,
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),),
                Text("That was the greatness of Vali Vilayat Rai, who always said that you can be closer to God even while doing day to day chores of mortal world. He preached \"Bhakti in Grahasti\", and said God is nearer than your own eyes, but you need to make yourself capable to realize him through love, shewa and Jap.",
                  style: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodySmall,
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
                Text("Last Days",  style: GoogleFonts.poppins(
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
                Text("In year 1887 Vali Vilayat Rai decided to move to Vainkunthdham. Read more  --(In order to bid goodbye to all his friends, he went on a tour. In the end he fell slightly ill at Sehwan and came to Larkana to his friend Diwan Chandumal Motwani and told him that, \"I now want to depart\". Chandumal Motwani said, \"if that be so, then do it here at Larkana\". But Vali Vilayat Rai said that, \"I desire to depart from Kambar\".)",
                  style: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodySmall,
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),),
                Text(" On 14th January,1887, Vali Vilayat Rai at the age of 62 years, was doing Satsang and in the end he told Sai Jiwatsingh, \"Alright get ready, I am just going round the corner and then I shall depart\". Everyone was stunned.Vali Vilayat Rai got up from the chair, went round the corner, came back, lied down on the floor and his atma merged with paramatma exactly at 4:00 am on 15th January, 1887.",
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