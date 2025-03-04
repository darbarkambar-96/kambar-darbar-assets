import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (Platform.isAndroid)
          ? AppBar(
              backgroundColor: Colors.white,
        centerTitle: true,
              title: Text(
                'About Darbar',
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
                'About Darbar',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 20,
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
              leading: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_outlined,
                      color: Colors.black,
                      size: 26.0,
                    ),
                  )),
            ),
      body: Container(
        color: const Color.fromRGBO(223, 224, 208, 1),
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kambar Darbar is situated at Kandivali, Mumbai, India. The site was selected by the late Trustee Shri Narayan Vaswani, who was miraculously guided to this place. The darbar primarily houses the Samadhis of our Gurus, Sai Vilayatrai, Sai Jiwatsingh, and Sai Vishindas, in a very serene and peaceful environment.\nAdjacent to the Samadhi room, are two other rooms, one with Guru Granth Sahib, and the other, has life-size portraits of the Three Gurus and Shri Nathji. This room also has the Samadhis of Adi Chaini Bai and Dadi Gopi, who have looked after Darbar and provided spiritual guidance to devotees, after Saijan, in India. The last spiritual head was Dadi Kamla Badlani who left this mortal world in 2015.",
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                          maxLines: isReadMore ? 10 : 100,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isReadMore = !isReadMore;
                                });
                              },
                              child: Text(
                                isReadMore ? "Read More" : "Read Less",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  //   child: Text(
                  //     "Kambar Darbar is situated at Kandivali, Mumbai, India. The site was selected by the late Trustee Shri Narayan Vaswani, who was miraculously guided to this place. The darbar primarily houses the Samadhis of our Gurus, Sai Vilayatrai, Sai Jiwatsingh, and Sai Vishindas, in a very serene and peaceful environment.",
                  //     style: GoogleFonts.poppins(
                  //       textStyle: Theme.of(context).textTheme.bodySmall,
                  //       fontSize: 20,
                  //       color: Colors.black,
                  //       fontWeight: FontWeight.w400,
                  //       fontStyle: FontStyle.normal,
                  //     ),
                  //   ),
                  // ),
                  // ExpansionPanelList(
                  //   expansionCallback: (int index, bool isExpanded) {
                  //     setState(() {
                  //       itemData[index].isExpanded = isExpanded;
                  //     });
                  //   },
                  //   children: itemData.map<ExpansionPanel>((Item item) {
                  //     return ExpansionPanel(
                  //       headerBuilder: (BuildContext context, bool isExpanded) {
                  //         return ListTile(
                  //           title: Text(item.headerValue),
                  //         );
                  //       },
                  //       body: Align(
                  //         alignment: Alignment.centerLeft,
                  //         child: Padding(
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: 20, vertical: 10),
                  //             child: Text(
                  //               item.expandedValue,
                  //               style: GoogleFonts.poppins(
                  //                 textStyle:
                  //                     Theme.of(context).textTheme.bodySmall,
                  //                 fontSize: 20,
                  //                 color: Colors.black,
                  //                 fontWeight: FontWeight.w400,
                  //                 fontStyle: FontStyle.normal,
                  //               ),
                  //             )),
                  //       ),
                  //       isExpanded: item.isExpanded,
                  //     );
                  //   }).toList(),
                  // ),
                ],
              ),
            ),
            const Divider(
              height: 20,
              thickness: 1,
              endIndent: 0,
              color: Colors.black,
            ),
            ExpansionTile(
              title: Text(
                'Guru\'s Preachings',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5), topLeft: Radius.circular(5)),
                side: BorderSide(color: Colors.grey),
              ),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              collapsedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5), topLeft: Radius.circular(5)),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              children: [
                Text(
                  'The main preachings of the Gurus have been: "JAP" (chanting) of "OM" To live life as per Guru’s expectations Selfless Shewa (service) of others To imbibe Humility, love & care for all.',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Origin of Darbar',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey),
              ),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              childrenPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              children: [
                Text(
                  'KAMBAR DARBAR had its origin when Sai Jiwatsingh in 1887 decided to make a memorial in the memory of his Guru Vali Vilayatrai at Kambar, Larkana (now in Pakistan) and also to set up his Samadhi there. Darbar Sahib was established at Kambar, since Vali Vilayatrai left his native place  Halla and spent his later years in Kambar. Samadhis of Sai Jiwatsingh and Sai Vishindas were also established adjacent to Sai Vilayatrai’s Samadhi. All samadhis were covered with silver straps.',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Establishing of Kambar Darbar at Kandivali',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey),
              ),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              childrenPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              children: [
                Text(
                  'After partition in 1947, most of the devotees migrated to India, majority of them settling in Mumbai (then Bombay). Hence there was an urge to re-establish Kambar Darbar in Bombay, but was difficult to build the Darbar without transferring the Samadhis from Kambar (now in Pakistan)The Samadhis remained at Kambar, in Pakistan, and so did Mata Chaini Bai. Bringing the Samadhis to India was not easy as Vali Vilayatrai"s grandson Sai Radhakrishna who continued to stay in Pakistan did not want the Darbar Sahib to shift to India and he had set up a security system to check this. After unsuccessful attempts by many devotees; Saijan told HIS greatgrandson Dada Kishinchand Villait to go to Kambar (Pakistan) along with 3 other specified devotees and bring a portion of the Samadhis for establishing the Darbar at Mumbai;Dada Kishinchand followed the instructions to the ‘tee’ and his mission proved successful.Darbar was then established in Mumbai, which was  done by beloved Trustee Shri Narain Vaswani in 1960.Mata Chaini Bai was the spiritual head of Darbar after Saijan and always stayed at Darbar. She laid the foundation stone for Darbar at Kandivali, Mumbai, on Cheti Chand day in 1960.Later ,Dada Brahmanand (Trustee as well as Sai Vishindas brother) started staying frequently at Kambar Darbar Kandivali and continued to live there until he passed away in 1980. Dadi Gopi, daughter of Dada Brahmanand who was intermittently living at Darbar Sahib during all this period, finally assumed the spiritual responsibilities of the Darbar Sahib in 1970, after Mata Chaini Bai left this world.Dadi Gopi also passed away in 1998 after more than 25 years of selfless service to Darbar. All the devotees miss her tremendously. Subsequently in 1999, Dadi Kamla Badlani assumed the spiritual responsibilities, in which she excelled. She was a living example of a Poorna Yogi - totally composed and with full peace of mind, yet with concern for everybody.Dadi Kamla was assisted by Trustees for administration and handling current and new activities - religious and charitable (medical, educational and help to poor).The Darbar building where Samadhis, guru Granth Sahib and Saijan\'s Tasveer room stand today was designed by the well-known architect of that time Shri Ram Hingoraney. He did this invaluable Shewa out of his love & devotion for the Satgurus.',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Sain Vilayatrai Sahib',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey),
              ),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              childrenPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              children: [
                Text(
                  'Early Ages \n Saijan was born in 1825 to Munshi Pratab Rai in Halla a village in Sindh, Pakistan. His mother was Mata Cheti Bai. Munshi Pratab Rai was a well to do person & served with the "Mirs" as a munshi. In those days to be a munshi to the Mirs was a great thing as it was the munshis who ran affairs of the State.Right from younger days Vilayatrai was a very intelligent person & used to ask very intellectual questions from his teachers, who in those days were Muslim Kazis. After finishing his education, Vilayatrai applied for service with the Mirs, but by then the Britishers had come in & powers of Mirs were on the wane. Vilayat applied to the British & was appointed as "Tapedar", who used to collect land revenue on behalf of the rulers. After some time in service, a mistake was detected in his accounts. A case was registered against Vilayat Rai & he was sentenced to prison. \n Divine Awakening \n While in Jail, Vilayat got divine visit from Guru Nanak Devji, who told Vilayat, "Why have you forgotten yourself? Discover yourself and remember why you have come in this world. In your previous birth you were a "Jogi". You have a lot to do in this world and people are waiting for you ". After this it was discovered that the charge under which Vilayat was sentenced, was false and Vilayat was released honorably.Vilayat along with his other colleagues, after office hours, used to meditate and they all used to chant Om…. Om….Om……… Vilayat’s spiritual fame started spreading and he kept on working as a Tapedar. On one occasion, their superior, Diwan Chanda Singh rebuked all the Tapedars calling them fools, because of mistake one of the Tapedars. The Tapedars resigned en-masse. Chanda Singh realized his mistake and asked them to withdraw their resignations. All did, but Vilayat didn’t. \n On the Path of Parmarath \n Vali Vilayat Rai\'s fame and his spiritual prowess kept on growing and so was his following. He shifted from Halla to Kambar and his daily religious discourses attracted a lot of \'Sangat\'.Munshi Shamdas, of Kambar was one of Vali\'s devotees.(One day he confided unto Vali about his younger brother who was leading a life of undue luxury, pomp and show. Further Shamdas said about his brother that he had started reading and practicing occult arts and thought himself to be a big occultic personality. He requested Vali Vilayat Rai to show proper path to his brother Jiwatsingh. Vali told Munshi Shamdas to bring Jiwatsingh to him and if does not listen , then tell him that Vilayat Rai is a great practitioner of the Occult and he will teach him some things. This evoked interest in Jiwatsingh and he presented himself before Vali Vilayat Rai and asked him, "Where are your powers? Show me." Vali Vilayat Rai looked into eyes of Jiwatsingh, eye contact was established between the two men of God, the true spiritual leaders. That was the turning point in the life of Jiwatsingh. He went into a trance and started shouting, "Oh Jiwat! What have you done. Oh Jiwat! What have you done." Jiwatsingh went into a shell which worried his brother, Munshi Shamdas and he came back to Vali Vilayat Rai and was reassured that this is only a passing phase, Jiwat has a lot to achieve in this world. He has Karmas of his previous birth to complete and attain great spiritual heights. Thereafter Jiwatsingh became the most devoted Shewak of Vali Vilayat Rai.) \n Divinity \n Vali Vilayat Rai always protected his disciples and led them on the path of divinity. There are many tales demonstrating his divine prowess. One such incident is of year 1885 when Vali along with his followers visited Bhai Dayaram who was seriously ill and unable to even get up. As soon as Vali entered the room of Bhai Dayaram, amazingly Dayaram got tremendous strength, he got up from his cot and started doing \'parikarma\' of the cot where Vali Vilayat Rai was sitting.\n (Everyone sitting there was taken aback and one woman shouted "Oh God, Where was a man like this, when my only son was on his death bed". After Parikarma, Bhai Dayaram came back to his cot and his pulse rate started going down. His wife beseeched Vali Vilayat Rai and said, "Oh Vali, don\'t make me a widow". Vali said " What can I do. Someone has to go at this moment, if you people are not ready then I will have to go myself". The lady replied, "I don\'t know but I will not be a widow". Upon this Vali Vilayatrai prepared himself for journey from this world but his own wife who was there said "Oh Lord, you are saving one woman from being a widow and in turn you are making me a widow. It would be better that you take my life.” Vali replied “OK. Be that as it may. Be prepared to depart from this world". Having said that Vali Vilayat Rai moved away from there. His wife acquired the same disease as Bhai Dayaram and within a short time she departed from this world, in the hands of her husband. Vali Vilayat Rai completed the 12th day ceremony of his wife\'s demise and came back to Kambar. Bhai Dayaram lived his normal life.)That was the greatness of Vali Vilayat Rai, who always said that you can be closer to God even while doing day to day chores of mortal world. He preached "Bhakti in Grahasti", and said God is nearer than your own eyes, but you need to make yourself capable to realize him through love, shewa and Jap. \n Last Days \n In year 1887 Vali Vilayat Rai decided to move to Vainkunthdham. Read more  --(In order to bid goodbye to all his friends, he went on a tour. In the end he fell slightly ill at Sehwan and came to Larkana to his friend Diwan Chandumal Motwani and told him that, "I now want to depart". Chandumal Motwani said, "if that be so, then do it here at Larkana". But Vali Vilayat Rai said that, "I desire to depart from Kambar".) \n On 14th January,1887, Vali Vilayat Rai at the age of 62 years, was doing Satsang and in the end he told Sai Jiwatsingh, "Alright get ready, I am just going round the corner and then I shall depart". Everyone was stunned.Vali Vilayat Rai got up from the chair, went round the corner, came back, lied down on the floor and his atma merged with paramatma exactly at 4:00 am on 15th January, 1887.',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Sain Jiwatsingh Sahib',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey),
              ),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              childrenPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              children: [
                Text(
                  'Early Life Born in 1831 to a rich "Zamindar" Shewaram Sainani at Kambar, Jiwat lost his father at a young age and was brought up by his mother and elder brothers, viz. Alimchand and Shamdas. Being the youngest, he was pampered and sort of spoilt.Inspite of vast possessions of land, he joined the Police force to enjoy life. He was handsome, smartly dressed and used his physical powers and police influence to overcome his critics. Nobody dared to challenge him. He had also learnt black magic. His mother and brothers shed tears on his such indulgences. \n \n Spiritual Upliftment \n\n Jiwat\'s brother Shamdas approached Vali Vilayat Rai in desperation, in whom he had unflinching faith. Tempted by the prospect of learning even more about black magic from Vali Vilayat Rai, Jiwatsingh went to meet him. A single glance of Grace from the Guru was sufficient to transform Jiwat into a Saint. For some time, he lead a life of repentance and used to say "Oh Jiwat, what have you done? You have wasted your life?" Very soon, he became such a devoted disciple of Vali Vilayat Rai that anybody would like to emulate him. Vali Vilayat Rai bestowed his abundant grace on his beloved disciple who became a great saint, and also gave him a lot of divine powers. \n\n Subsequent Life \n\n Sai Jiwatsingh’s life is that of a humble family man. He devoted his life to  selfless \'Sheva\' of his Guru and surrendered himself completely to the Guru. \n\n Miracles \n\n In the process, Sai Jiwatsingh was bestowed by his Guru such divine powers that he could even bring even dead back to life. Quite a few such incidents happened. This practice did not meet his Guru\'s approval and so was asked to dispense medicines and give \'Rakhyas\' and sacred thread to alleviate the agony of others which he started doing immediately; and this tradition continues till today. The dispensary also had its beginning at that  time.today it is multi-specialty medical centre with diagnostics, and other special features. \n\n Own Bhajans/Shabads \n\n Besides being a great \'Bhakta\' he was also a great poet. His devotion and love for his Guru brought out spontaneous flow of hymns (bhajans) from within. He sang in praise of his Guru and his \'Ishtdev\' - Lord Krishna. His Shabads are also indicators of the gradual stages of his spiritual advancement and his level of bliss for self-fulfilment. These bhajans are sung even today with great devotion. \n\n Leaving the world as per his own choice \n\n Sai Jiwatsingh had been bestowed by his Guru the boon of Ichha-Mrityu. He wanted to depart from this world on same day and time as his Guru. He had to stay one year more for the same. To meet this objective he decided to leave this mortal world on 14 Jan 1899 although he was totally healthy, and nobody believed that he would depart on that night(early morning next day), which he had mentioned a year ago. Late evening on 14th Jan, he bid goodbye to all the well-wishers. He told them that he would sleep on the floor at 10:00 pm and started chanting "Om" which will stop exactly at 4:00 am on 15 Jan 1899 and at that time his atma would leave his body. This is exactly what happened. This was Sai Jaiwatsingh\'s power to decide his own date and time of leaving the material world.',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Sain Vishindas Sahib',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey),
              ),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              childrenPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              children: [
                Text(
                  'Early Life \n\n Son of Shri Karamchand Sainani, Vishindas was born in 1889 as a still baby at Kambar. When Sai Jiwatsingh was informed about this, he said the child is very much alive and is merely pretending to be lifeless, in protest against Sai Jiwatsingh\'s absence at the time of child\'s birth. As soon as Sai Jiwatsingh reached near him, the child started moving his limbs and crying. Vishindas was a King in his last birth, who had renounced his kingdom and spent his life in Yoga and meditation. He had taken birth again to complete the balance Yogic work left over in his previous birth. \n\n Young Age \n\n Expectedly Vishin was very bright in his young age and grasped school lessons very fast, but did not have much interest in learning at school. He stayed with his sister in a distant city of Sukkur for better schooling. Once he told his sister he didn\'t want to study and would like to go to Kambar to his parents, for which he was scolded by his sister. Within few hours of this instance, a telegram came from his father to his sister to send Vishin immediately to Kambar as he has to take charge of Darbar, seeing which the sister was shocked, as to how Vishin knew everything in advance.Thus at the age of 14 he was asked to take charge of Kambar Darbar, which his father was looking after as caretaker for about 4 years after Sai Jiwatsingh left for heavenly abode. Vishindas was the second youngest of five brothers and remained a bachelor and dedicated his life totally to the shewa of Kambar Darbar. The Saint in him always prevailed and Sai Vishindas continued the learning of various Shastras (including the Granth Saheb) in great depth and also practiced what he learnt. \n\n Spiritual Domain \n\n Sai Vishindas lived a life full of humility and kindness, compassion and love. He practiced intense meditation. His speedy spiritual advancement bestowed on him divine powers which along with above virtues pulled the Darbar\'s devotees and satsangis towards him. Sai Vishindas continued the free dispensary started by Guru Sai Jiwatsingh, for alleviating the troubles of whoever came to him. This practice of FREE/lowest medical cost treatment is still continuing, and covered many specialities, as Ophtal, (Eyes), Nephro (Kidney), Skin, Ortho (Bones), Gyanac (Including Cervial Cancer), Dental, Child-specialist, Heart & Diabetes, Spine, Homeo, ENT, etc. \n\n Miracles \n\n Sai Vishindas used his divine powers on numerous occasions for helping people in agony. He was very humble and always told the people that Saijans (his Gurus) were bestowing the Grace and not he himself. \n\n Formation of Trust: \n\n Sai Vishindas had the vision to foresee the problems expected during partition and the expected migration of Hindus to India. Hence, he decided to create a Trust for managing the affairs of Kambar Darbar. The Board of Trustees have constructed Kambar Darbar at Kandivali (Mumbai) and are managing the affairs in consultation with the spiritual head. He entered Maha-Samadhi in 1942, at the age of 53.',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Mata Chaini Bai',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey),
              ),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              childrenPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              children: [
                Text(
                  'Early Days \n\n Mata Chaini Bai was born in Larkana, in Bhambhani family. She was sister of Diwan Rupchand Bhambhani, husband of Adi Ganga, who was the adopted daughter of Sai Jiwatsingh. Mata Chaini Bai was married at a young age in Tawarmalani family. Her husband Tulsidas was in Land Revenue Department at Kambar and came close to Sai Jiwat Singh. He passed away at a very young age. He was a great yogi and had indicated the coming of his death and died peacefully in sleep. \n\n Dedication To Kambar Darbar \n\n After death of her husband, Mata Chaini Bai dedicated herself to Sai Jiwat Singh and was totally devoted to Kambar Darbar Sahib.She had surrendered herself completely to the Darbar. She treated Sai Vishindas as her own son and brought him up in the same manner as Mata Yashoda had brought up Krishna. Her selfless shewa of Darbar Sahib\'s devotees and satsangis is incomparable. She was ever ready to serve the devotees at any time of day or night and was always concerned about their comfort. It was this quality, among many others, which in later years Sai Vishindas adopted and it continues to be the main ethos of Darbar Sahib even today. \n\n Divine Powers \n\nMata Chaini Bai gained great spiritual advancement due to her devotion to Sai Jiwatsingh and flawless shewa of devotees coupled, with \'Jaap\' of \'Om\' and her high purity of thoughts and deeds. She attained divine powers and helped in alleviating agony of many devotees. She had the vision to look into future. One of the young devotees an Engineering Student, had booked his train ticket to return to his place of residence (Secunderabad), when he had come to Kandivali Darbar during holidays. Mata Chaini Bai told him to stay back for one day more, which he agreed immediately due to his faith in her. When he went back to Secunderabad he came to know that the train from Bombay which left on the earlier day had met with a serious accident due to derailment and a number of people had died in that accident. Thus, she avoided the trouble for the young devotee. There are many such narrations of her divine powers. \n\n End of an Era \n\n Mata Chaini Bai continued to stay at Kambar Darbar in Pakistan after partition until the Samadhis were shifted to India. She was willing to face any consequences. She left Kambar only when she was assured by Vali Vilayatrai\'s great grandson (Dada Kishinchand) that the Samadhis were being taken to India. She was weeping even after reaching India until the containers having the Ashes of the Gurus were actually given to her. This was her devotion to her Gurus. She stayed at Kambar Darbar at Kandivali till her end. Mata Chaini Bai left for Nijdham in 1966 at the age of 95, after she had prepared Dadi Gopi to take on the spiritual responsibilities at Darbar Sahib.',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Dadi Gopi',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey),
              ),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              childrenPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              children: [
                Text(
                  'Early Life - Born in 1921 at Larkana in Pakistan, Dadi Gopi was the eldest daughter of Shri Brahmanand Sainani, brother of Sai Vishindas. He was also one of thefirst four Trustees chosen by Sai Vishindas. Dadi Gopi was very muchattached to her uncle and Guru Sai Vishindas from her young age andspent considerable time with him. She received continuous spiritual and moral guidance from him. \n\n Sai Vishindas advised his brother Brahmanand not to get Gopi marriedand also she should not study beyond matric, which initially disturbed DadiGopi as she was a bright student and wanted to become a doctor. But Saijan"s words meant a lot to her and she knew that she had to follow hiswords, which she did. Dadi Gopi had intermittently been living at KambarDarbar, Kandivali when her father Dada Brahmanand Sainani was livingthere. She got her Naam; from Adi Ganga after she started living at Darbar full time;. She continued the sacred system of giving Naam; orUpadesh; to satsangis. \n Along with Dadiji, Bhabhi Kalp Sainani had alsobeen bestowed with the blessings to give Naam;. Dadiji started continuously living at the Darbar Sahib from 1963. She learnt from MataChaini Bai the customs and traditions of the Gurus and the way to do Shewa of the devotees. Dadi Gopi"s life has been a life of total devotion toGurus and dedication to Satsang. \n Missions in Life \n Dadi Gopi started the Sunday morning Satsang at Kambar Darbar Sahib at Kandivali. Gradually satsangis started coming regularly and it became aritual with one and all. The best thing that happened was that the younger generation also started coming regularly. Dadiji through her advice,guidance and Pravachans; brought the & Sangat on path of parmarath. Darbar devotees sing Sai Jiwatsingh"s bhajans, Kafis and other devotionalsongs. Every one derives benefit from the life, teachings and preachings of Saijans. Sunday morning congregations have not been the only thing.Every evening locals from Kandivali gather at the Darbar Sahib and Dadiji started evening Katha for them. Thus the age old tradition and custom of evening Katha and Aarti were started. Gopi Dadi used to travel frequently to other cities to propagate Saijans’ teachings and values, and also guide people on the spiritual path through satsang. A number of devotees came closer to darbar through this and visited Kandivali more often and in greater numbers.Many devotees came to the Darbar Sahib, discussed their problems with Dadiji, and got their solutions. Such had been her influence that Devotees had been requesting her to come to their towns, cities and homes and bless them. Dadiji had been showering blessings of the Gurus on the devotees and the benefits are apparent and visible. There are many stories of Dadiji helping devotees in need. Such has been her influence on the devotees that for marriages, buying of houses, starting of new business ventures, and even naming ceremonies of children, devotees have been seeking Dadiji benevolence.Annual Diwali Mela is the rallying point of entire Sangat. Devotees come from far and wide, from within the country and also from foreign countries. Darbar has regular visitors from USA, Canada, Spain, Dubai, etc. At Darbar Sahib every one eagerly awaited Dadiji doing ARDAAS and invoking the names of Gurus to seek their blessings for the entire Sangat who were present and also those who could not come physically for the Mela, but were mentally at the Darbar Sahib. Thus she continued the good work and traditions and customs started by the Gurus and gave them a great fillip. It was during the preparations of Diwali Mela of the year 1998, that Dadiji mentioned casually to the common people that NOW I CAN RETIRE. Within less than a week of Diwali Mela Dadi Gopi chose to release her ATMA from her mortal being and went unto the Gurujis charans on 25 th  Oct 1998. This was end of an era, but with the blessings of Saijans, the activities of Darbar Sahib continue as ever before.',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Dadi Kamla',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey),
              ),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              childrenPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              children: [
                Text(
                  'Dadi Kamla Badlani was born in on 31 st May 1917. Dadi Kamala had faced various tragedies in life. But also got support from various elderly with the result she learnt to be detached from worldly incidents and lead a simple life without desires. She lost her mother while she was an infant 2.5 years old. She lost her father at a tender age of about 12 years. Her upbringing was done by her close aunts Devi Bijlani &amp; others. This influenced her to become vegetarian and came close to various spiritual people like Mata Chaini bai, Elder daughter-in-law of Vali Vilayatrai and others. Biggest blow came when she lost her husband Narayan Badlani at the young age of 25 in 1942. She got support from her father-in-law Gobindram Badlani &amp; her father Sukhramdas Tanwarmalani. Her father had passed away one year before her marriage. She was also close to Sai Vishindas from her young age and made him her Guru. In fact Sai Vishindas took responsibility of getting her married &amp; did her Kanya daan in her marriage. Sai Vishindas has also gave her Naam at the time of marriage and gifted her 3 things:1-18 th Chapter of Bhagwad Gita,2- Sukh sagar and a pen for writing letters to Sai Vishindas after marriage. Dadi Kamala was guided spiritually by her father Sukhramdas and her father-in-law. She was also guided by the enlightened Totaram Hingorani a family-friend. After passing away of her husband, Dadi Kamala spent lot of time with Totaram Hingorani, who taught her from Vedanta and Sami’s shlokas. She also started wearing Khadi as an influence of her father,Totaram, etc. Thus Dadi got highly spiritually enlightened, which showed in her day to day living as NO ANGER, no Desires, No desire to collect things or wealth. She could eat the same vegetable (Turia) 365 days in a year. These are qualities of Param Yogi. Dadi had her schooling in Convent school and her father-in-law encouraged her to do BA, &amp; so Dadi knew good English besides Hindi &amp; some knowledge of Sanskrit. Dadi had love for Krishna as her Isht Dev and had her room filled with Krishna’s pictures. She attended 5 days of Shrimad Bhagwat Saptah at Kambar Darbar in Feb 2015 and left her mortal body (at 97 years age), on 6th day morning focussing her sight on Krishna’s picture in her room.',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'The Trust',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey),
              ),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              childrenPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              children: [
                Text(
                  'Day-to-day activities of Darbar Sahib are presently looked after by the trustees.  \n In 1942, Sai Vishindas had nominated four Trustees, viz, Shri Brahmanand Sainani, Shri Mohanlal Hingorani, Shri Narain Vaswani and Shri Ram Bhambhani. The Trustees main responsibility is to manage the property of Darbar Sahib spread over one acre of land at Kandivali (West), (Shantilal Modi Road, about 10 minutes walking distance from Kandivali Station), Mumbai. \n The Darbar Sahib has three dharamshala buildings and the main Mandir building. The Darbar Sahib runs medical facilities as per today"s needs, i.e.specialists like gynaecologist, eye surgery, skin specialist, orthopedic, ENT, heart, diabetes, etc.',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Trustees',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 18,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                side: BorderSide(color: Colors.grey),
              ),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              collapsedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              children: [
                Text(
                  '(It is the duties of the trustees to run the activities of Darbar as per Trust Deed prepared by Saijans and follow the laws and rules and regulations as applicable at that time.) \n The current trustees are : \n Sai Vilayatrai Sai Jiwatsingh Kambar Darbar Sahib Trust: \n 1. Shri Prabhu S Sainani \n 2. Shri Shamsunder L Sidhwani \n 3. Shri Raveen Chugani \n 4. Narain Chhalwani \n\n Sai Vilayatrai Sai Jiwatsingh Sai Vishindas Charitable Trust: \n 1. Shri Prabhu Sainani \n 2. Shri Shamsunder Sidhwani \n 3. Shri Ashok Dudani \n 4. Dr. Prakash Chandiramani \n Shri Prabhu S Sainani is the resident Trustee who looks after the day-to- day administrative and charitable (medical and educational) activities of the Trust. \n Email: p_sainani@rediffmail.com \n info@kambardarbar.org \n Tele: Kambar Darbar: 8976081672 (Darbar), 9029911644(GeneralClinic), 7400072847(Dental Clinic)',
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            // ExpansionPanelList(
            //   expansionCallback: (int index, bool isExpanded) {
            //     setState(() {
            //       itemData2[index].isExpanded = isExpanded;
            //     });
            //   },
            //   children: itemData2.map<ExpansionPanel>((Item item) {
            //     return ExpansionPanel(
            //       headerBuilder: (BuildContext context, bool isExpanded) {
            //         return ListTile(
            //           title: Text(
            //             item.headerValue,
            //             style: GoogleFonts.poppins(
            //               textStyle: Theme.of(context).textTheme.bodySmall,
            //               fontSize: 20,
            //               color: Colors.blueAccent,
            //               fontWeight: FontWeight.w600,
            //               fontStyle: FontStyle.normal,
            //             ),
            //           ),
            //         );
            //       },
            //       body: Align(
            //         alignment: Alignment.centerLeft,
            //         child: Padding(
            //             padding:
            //                 const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //             child: Text(
            //               item.expandedValue,
            //               style: GoogleFonts.poppins(
            //                 textStyle: Theme.of(context).textTheme.bodySmall,
            //                 fontSize: 18,
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.w400,
            //                 fontStyle: FontStyle.normal,
            //               ),
            //             )),
            //       ),
            //       isExpanded: item.isExpanded,
            //     );
            //   }).toList(),
            // ),
          ],
        ),
      ),
    );
  }

  bool isReadMore = true;

  List<Item> itemData = <Item>[
    Item(
      expandedValue:
          'Adjacent to the Samadhi room, are two other rooms, one with Guru Granth Sahib, and the other, has life-size portraits of the Three Gurus and Shri Nathji. This room also has the Samadhis of Adi Chaini Bai and Dadi Gopi, who have looked after Darbar and provided spiritual guidance to devotees, after Saijan, in India. The last spiritual head was Dadi Kamla Badlani who left this mortal world in 2015.',
      headerValue: "Read More",
      isExpanded: false,
    ),
  ];

  List<Item> itemData2 = <Item>[
    Item(
      expandedValue:
          'The main preachings of the Gurus have been: "JAP" (chanting) of "OM" To live life as per Guru’s expectations Selfless Shewa (service) of others To imbibe Humility, love & care for all.',
      headerValue: "Guru's Preachings",
      isExpanded: false,
    ),
    Item(
      expandedValue:
          'KAMBAR DARBAR had its origin when Sai Jiwatsingh in 1887 decided to make a memorial in the memory of his Guru Vali Vilayatrai at Kambar, Larkana (now in Pakistan) and also to set up his Samadhi there. Darbar Sahib was established at Kambar, since Vali Vilayatrai left his native place  Halla and spent his later years in Kambar. Samadhis of Sai Jiwatsingh and Sai Vishindas were also established adjacent to Sai Vilayatrai’s Samadhi. All samadhis were covered with silver straps.',
      headerValue: "Origin of Darbar",
      isExpanded: false,
    ),
    Item(
      expandedValue:
          'After partition in 1947, most of the devotees migrated to India, majority of them settling in Mumbai (then Bombay). Hence there was an urge to re-establish Kambar Darbar in Bombay, but was difficult to build the Darbar without transferring the Samadhis from Kambar (now in Pakistan)The Samadhis remained at Kambar, in Pakistan, and so did Mata Chaini Bai. Bringing the Samadhis to India was not easy as Vali Vilayatrai"s grandson Sai Radhakrishna who continued to stay in Pakistan did not want the Darbar Sahib to shift to India and he had set up a security system to check this. After unsuccessful attempts by many devotees; Saijan told HIS greatgrandson Dada Kishinchand Villait to go to Kambar (Pakistan) along with 3 other specified devotees and bring a portion of the Samadhis for establishing the Darbar at Mumbai;Dada Kishinchand followed the instructions to the ‘tee’ and his mission proved successful.Darbar was then established in Mumbai, which was  done by beloved Trustee Shri Narain Vaswani in 1960.Mata Chaini Bai was the spiritual head of Darbar after Saijan and always stayed at Darbar. She laid the foundation stone for Darbar at Kandivali, Mumbai, on Cheti Chand day in 1960.Later ,Dada Brahmanand (Trustee as well as Sai Vishindas brother) started staying frequently at Kambar Darbar Kandivali and continued to live there until he passed away in 1980. Dadi Gopi, daughter of Dada Brahmanand who was intermittently living at Darbar Sahib during all this period, finally assumed the spiritual responsibilities of the Darbar Sahib in 1970, after Mata Chaini Bai left this world.Dadi Gopi also passed away in 1998 after more than 25 years of selfless service to Darbar. All the devotees miss her tremendously. Subsequently in 1999, Dadi Kamla Badlani assumed the spiritual responsibilities, in which she excelled. She was a living example of a Poorna Yogi - totally composed and with full peace of mind, yet with concern for everybody.Dadi Kamla was assisted by Trustees for administration and handling current and new activities - religious and charitable (medical, educational and help to poor).The Darbar building where Samadhis, guru Granth Sahib and Saijan\'s Tasveer room stand today was designed by the well-known architect of that time Shri Ram Hingoraney. He did this invaluable Shewa out of his love & devotion for the Satgurus.',
      headerValue: "Establishing of Kambar Darbar at Kandivali",
      isExpanded: false,
    ),
    Item(
      expandedValue:
          'Early Ages \n Saijan was born in 1825 to Munshi Pratab Rai in Halla a village in Sindh, Pakistan. His mother was Mata Cheti Bai. Munshi Pratab Rai was a well to do person & served with the "Mirs" as a munshi. In those days to be a munshi to the Mirs was a great thing as it was the munshis who ran affairs of the State.Right from younger days Vilayatrai was a very intelligent person & used to ask very intellectual questions from his teachers, who in those days were Muslim Kazis. After finishing his education, Vilayatrai applied for service with the Mirs, but by then the Britishers had come in & powers of Mirs were on the wane. Vilayat applied to the British & was appointed as "Tapedar", who used to collect land revenue on behalf of the rulers. After some time in service, a mistake was detected in his accounts. A case was registered against Vilayat Rai & he was sentenced to prison. \n Divine Awakening \n While in Jail, Vilayat got divine visit from Guru Nanak Devji, who told Vilayat, "Why have you forgotten yourself? Discover yourself and remember why you have come in this world. In your previous birth you were a "Jogi". You have a lot to do in this world and people are waiting for you ". After this it was discovered that the charge under which Vilayat was sentenced, was false and Vilayat was released honorably.Vilayat along with his other colleagues, after office hours, used to meditate and they all used to chant Om…. Om….Om……… Vilayat’s spiritual fame started spreading and he kept on working as a Tapedar. On one occasion, their superior, Diwan Chanda Singh rebuked all the Tapedars calling them fools, because of mistake one of the Tapedars. The Tapedars resigned en-masse. Chanda Singh realized his mistake and asked them to withdraw their resignations. All did, but Vilayat didn’t. \n On the Path of Parmarath \n Vali Vilayat Rai\'s fame and his spiritual prowess kept on growing and so was his following. He shifted from Halla to Kambar and his daily religious discourses attracted a lot of \'Sangat\'.Munshi Shamdas, of Kambar was one of Vali\'s devotees.(One day he confided unto Vali about his younger brother who was leading a life of undue luxury, pomp and show. Further Shamdas said about his brother that he had started reading and practicing occult arts and thought himself to be a big occultic personality. He requested Vali Vilayat Rai to show proper path to his brother Jiwatsingh. Vali told Munshi Shamdas to bring Jiwatsingh to him and if does not listen , then tell him that Vilayat Rai is a great practitioner of the Occult and he will teach him some things. This evoked interest in Jiwatsingh and he presented himself before Vali Vilayat Rai and asked him, "Where are your powers? Show me." Vali Vilayat Rai looked into eyes of Jiwatsingh, eye contact was established between the two men of God, the true spiritual leaders. That was the turning point in the life of Jiwatsingh. He went into a trance and started shouting, "Oh Jiwat! What have you done. Oh Jiwat! What have you done." Jiwatsingh went into a shell which worried his brother, Munshi Shamdas and he came back to Vali Vilayat Rai and was reassured that this is only a passing phase, Jiwat has a lot to achieve in this world. He has Karmas of his previous birth to complete and attain great spiritual heights. Thereafter Jiwatsingh became the most devoted Shewak of Vali Vilayat Rai.) \n Divinity \n Vali Vilayat Rai always protected his disciples and led them on the path of divinity. There are many tales demonstrating his divine prowess. One such incident is of year 1885 when Vali along with his followers visited Bhai Dayaram who was seriously ill and unable to even get up. As soon as Vali entered the room of Bhai Dayaram, amazingly Dayaram got tremendous strength, he got up from his cot and started doing \'parikarma\' of the cot where Vali Vilayat Rai was sitting.\n (Everyone sitting there was taken aback and one woman shouted "Oh God, Where was a man like this, when my only son was on his death bed". After Parikarma, Bhai Dayaram came back to his cot and his pulse rate started going down. His wife beseeched Vali Vilayat Rai and said, "Oh Vali, don\'t make me a widow". Vali said " What can I do. Someone has to go at this moment, if you people are not ready then I will have to go myself". The lady replied, "I don\'t know but I will not be a widow". Upon this Vali Vilayatrai prepared himself for journey from this world but his own wife who was there said "Oh Lord, you are saving one woman from being a widow and in turn you are making me a widow. It would be better that you take my life.” Vali replied “OK. Be that as it may. Be prepared to depart from this world". Having said that Vali Vilayat Rai moved away from there. His wife acquired the same disease as Bhai Dayaram and within a short time she departed from this world, in the hands of her husband. Vali Vilayat Rai completed the 12th day ceremony of his wife\'s demise and came back to Kambar. Bhai Dayaram lived his normal life.)That was the greatness of Vali Vilayat Rai, who always said that you can be closer to God even while doing day to day chores of mortal world. He preached "Bhakti in Grahasti", and said God is nearer than your own eyes, but you need to make yourself capable to realize him through love, shewa and Jap. \n Last Days \n In year 1887 Vali Vilayat Rai decided to move to Vainkunthdham. Read more  --(In order to bid goodbye to all his friends, he went on a tour. In the end he fell slightly ill at Sehwan and came to Larkana to his friend Diwan Chandumal Motwani and told him that, "I now want to depart". Chandumal Motwani said, "if that be so, then do it here at Larkana". But Vali Vilayat Rai said that, "I desire to depart from Kambar".) \n On 14th January,1887, Vali Vilayat Rai at the age of 62 years, was doing Satsang and in the end he told Sai Jiwatsingh, "Alright get ready, I am just going round the corner and then I shall depart". Everyone was stunned.Vali Vilayat Rai got up from the chair, went round the corner, came back, lied down on the floor and his atma merged with paramatma exactly at 4:00 am on 15th January, 1887.',
      headerValue: "Sain Vilayatrai Sahib",
      isExpanded: false,
    ),
    Item(
      expandedValue:
          'Early Life Born in 1831 to a rich "Zamindar" Shewaram Sainani at Kambar, Jiwat lost his father at a young age and was brought up by his mother and elder brothers, viz. Alimchand and Shamdas. Being the youngest, he was pampered and sort of spoilt.Inspite of vast possessions of land, he joined the Police force to enjoy life. He was handsome, smartly dressed and used his physical powers and police influence to overcome his critics. Nobody dared to challenge him. He had also learnt black magic. His mother and brothers shed tears on his such indulgences. \n \n Spiritual Upliftment \n\n Jiwat\'s brother Shamdas approached Vali Vilayat Rai in desperation, in whom he had unflinching faith. Tempted by the prospect of learning even more about black magic from Vali Vilayat Rai, Jiwatsingh went to meet him. A single glance of Grace from the Guru was sufficient to transform Jiwat into a Saint. For some time, he lead a life of repentance and used to say "Oh Jiwat, what have you done? You have wasted your life?" Very soon, he became such a devoted disciple of Vali Vilayat Rai that anybody would like to emulate him. Vali Vilayat Rai bestowed his abundant grace on his beloved disciple who became a great saint, and also gave him a lot of divine powers. \n\n Subsequent Life \n\n Sai Jiwatsingh’s life is that of a humble family man. He devoted his life to  selfless \'Sheva\' of his Guru and surrendered himself completely to the Guru. \n\n Miracles \n\n In the process, Sai Jiwatsingh was bestowed by his Guru such divine powers that he could even bring even dead back to life. Quite a few such incidents happened. This practice did not meet his Guru\'s approval and so was asked to dispense medicines and give \'Rakhyas\' and sacred thread to alleviate the agony of others which he started doing immediately; and this tradition continues till today. The dispensary also had its beginning at that  time.today it is multi-specialty medical centre with diagnostics, and other special features. \n\n Own Bhajans/Shabads \n\n Besides being a great \'Bhakta\' he was also a great poet. His devotion and love for his Guru brought out spontaneous flow of hymns (bhajans) from within. He sang in praise of his Guru and his \'Ishtdev\' - Lord Krishna. His Shabads are also indicators of the gradual stages of his spiritual advancement and his level of bliss for self-fulfilment. These bhajans are sung even today with great devotion. \n\n Leaving the world as per his own choice \n\n Sai Jiwatsingh had been bestowed by his Guru the boon of Ichha-Mrityu. He wanted to depart from this world on same day and time as his Guru. He had to stay one year more for the same. To meet this objective he decided to leave this mortal world on 14 Jan 1899 although he was totally healthy, and nobody believed that he would depart on that night(early morning next day), which he had mentioned a year ago. Late evening on 14th Jan, he bid goodbye to all the well-wishers. He told them that he would sleep on the floor at 10:00 pm and started chanting "Om" which will stop exactly at 4:00 am on 15 Jan 1899 and at that time his atma would leave his body. This is exactly what happened. This was Sai Jaiwatsingh\'s power to decide his own date and time of leaving the material world.',
      headerValue: "Sain Jiwatsingh Sahib",
      isExpanded: false,
    ),
    Item(
      expandedValue:
          'Early Life \n\n Son of Shri Karamchand Sainani, Vishindas was born in 1889 as a still baby at Kambar. When Sai Jiwatsingh was informed about this, he said the child is very much alive and is merely pretending to be lifeless, in protest against Sai Jiwatsingh\'s absence at the time of child\'s birth. As soon as Sai Jiwatsingh reached near him, the child started moving his limbs and crying. Vishindas was a King in his last birth, who had renounced his kingdom and spent his life in Yoga and meditation. He had taken birth again to complete the balance Yogic work left over in his previous birth. \n\n Young Age \n\n Expectedly Vishin was very bright in his young age and grasped school lessons very fast, but did not have much interest in learning at school. He stayed with his sister in a distant city of Sukkur for better schooling. Once he told his sister he didn\'t want to study and would like to go to Kambar to his parents, for which he was scolded by his sister. Within few hours of this instance, a telegram came from his father to his sister to send Vishin immediately to Kambar as he has to take charge of Darbar, seeing which the sister was shocked, as to how Vishin knew everything in advance.Thus at the age of 14 he was asked to take charge of Kambar Darbar, which his father was looking after as caretaker for about 4 years after Sai Jiwatsingh left for heavenly abode. Vishindas was the second youngest of five brothers and remained a bachelor and dedicated his life totally to the shewa of Kambar Darbar. The Saint in him always prevailed and Sai Vishindas continued the learning of various Shastras (including the Granth Saheb) in great depth and also practiced what he learnt. \n\n Spiritual Domain \n\n Sai Vishindas lived a life full of humility and kindness, compassion and love. He practiced intense meditation. His speedy spiritual advancement bestowed on him divine powers which along with above virtues pulled the Darbar\'s devotees and satsangis towards him. Sai Vishindas continued the free dispensary started by Guru Sai Jiwatsingh, for alleviating the troubles of whoever came to him. This practice of FREE/lowest medical cost treatment is still continuing, and covered many specialities, as Ophtal, (Eyes), Nephro (Kidney), Skin, Ortho (Bones), Gyanac (Including Cervial Cancer), Dental, Child-specialist, Heart & Diabetes, Spine, Homeo, ENT, etc. \n\n Miracles \n\n Sai Vishindas used his divine powers on numerous occasions for helping people in agony. He was very humble and always told the people that Saijans (his Gurus) were bestowing the Grace and not he himself. \n\n Formation of Trust: \n\n Sai Vishindas had the vision to foresee the problems expected during partition and the expected migration of Hindus to India. Hence, he decided to create a Trust for managing the affairs of Kambar Darbar. The Board of Trustees have constructed Kambar Darbar at Kandivali (Mumbai) and are managing the affairs in consultation with the spiritual head. He entered Maha-Samadhi in 1942, at the age of 53.',
      headerValue: "Sain Vishindas Sahib",
      isExpanded: false,
    ),
    Item(
      expandedValue:
          'Early Days \n\n Mata Chaini Bai was born in Larkana, in Bhambhani family. She was sister of Diwan Rupchand Bhambhani, husband of Adi Ganga, who was the adopted daughter of Sai Jiwatsingh. Mata Chaini Bai was married at a young age in Tawarmalani family. Her husband Tulsidas was in Land Revenue Department at Kambar and came close to Sai Jiwat Singh. He passed away at a very young age. He was a great yogi and had indicated the coming of his death and died peacefully in sleep. \n\n Dedication To Kambar Darbar \n\n After death of her husband, Mata Chaini Bai dedicated herself to Sai Jiwat Singh and was totally devoted to Kambar Darbar Sahib.She had surrendered herself completely to the Darbar. She treated Sai Vishindas as her own son and brought him up in the same manner as Mata Yashoda had brought up Krishna. Her selfless shewa of Darbar Sahib\'s devotees and satsangis is incomparable. She was ever ready to serve the devotees at any time of day or night and was always concerned about their comfort. It was this quality, among many others, which in later years Sai Vishindas adopted and it continues to be the main ethos of Darbar Sahib even today. \n\n Divine Powers \n\nMata Chaini Bai gained great spiritual advancement due to her devotion to Sai Jiwatsingh and flawless shewa of devotees coupled, with \'Jaap\' of \'Om\' and her high purity of thoughts and deeds. She attained divine powers and helped in alleviating agony of many devotees. She had the vision to look into future. One of the young devotees an Engineering Student, had booked his train ticket to return to his place of residence (Secunderabad), when he had come to Kandivali Darbar during holidays. Mata Chaini Bai told him to stay back for one day more, which he agreed immediately due to his faith in her. When he went back to Secunderabad he came to know that the train from Bombay which left on the earlier day had met with a serious accident due to derailment and a number of people had died in that accident. Thus, she avoided the trouble for the young devotee. There are many such narrations of her divine powers. \n\n End of an Era \n\n Mata Chaini Bai continued to stay at Kambar Darbar in Pakistan after partition until the Samadhis were shifted to India. She was willing to face any consequences. She left Kambar only when she was assured by Vali Vilayatrai\'s great grandson (Dada Kishinchand) that the Samadhis were being taken to India. She was weeping even after reaching India until the containers having the Ashes of the Gurus were actually given to her. This was her devotion to her Gurus. She stayed at Kambar Darbar at Kandivali till her end. Mata Chaini Bai left for Nijdham in 1966 at the age of 95, after she had prepared Dadi Gopi to take on the spiritual responsibilities at Darbar Sahib.',
      headerValue: "Mata Chaini Bai",
      isExpanded: false,
    ),
    Item(
      expandedValue:
          'Early Life - Born in 1921 at Larkana in Pakistan, Dadi Gopi was the eldest daughter of Shri Brahmanand Sainani, brother of Sai Vishindas. He was also one of thefirst four Trustees chosen by Sai Vishindas. Dadi Gopi was very muchattached to her uncle and Guru Sai Vishindas from her young age andspent considerable time with him. She received continuous spiritual and moral guidance from him. \n\n Sai Vishindas advised his brother Brahmanand not to get Gopi marriedand also she should not study beyond matric, which initially disturbed DadiGopi as she was a bright student and wanted to become a doctor. But Saijan"s words meant a lot to her and she knew that she had to follow hiswords, which she did. Dadi Gopi had intermittently been living at KambarDarbar, Kandivali when her father Dada Brahmanand Sainani was livingthere. She got her Naam; from Adi Ganga after she started living at Darbar full time;. She continued the sacred system of giving Naam; orUpadesh; to satsangis. \n Along with Dadiji, Bhabhi Kalp Sainani had alsobeen bestowed with the blessings to give Naam;. Dadiji started continuously living at the Darbar Sahib from 1963. She learnt from MataChaini Bai the customs and traditions of the Gurus and the way to do Shewa of the devotees. Dadi Gopi"s life has been a life of total devotion toGurus and dedication to Satsang. \n Missions in Life \n Dadi Gopi started the Sunday morning Satsang at Kambar Darbar Sahib at Kandivali. Gradually satsangis started coming regularly and it became aritual with one and all. The best thing that happened was that the younger generation also started coming regularly. Dadiji through her advice,guidance and Pravachans; brought the & Sangat on path of parmarath. Darbar devotees sing Sai Jiwatsingh"s bhajans, Kafis and other devotionalsongs. Every one derives benefit from the life, teachings and preachings of Saijans. Sunday morning congregations have not been the only thing.Every evening locals from Kandivali gather at the Darbar Sahib and Dadiji started evening Katha for them. Thus the age old tradition and custom of evening Katha and Aarti were started. Gopi Dadi used to travel frequently to other cities to propagate Saijans’ teachings and values, and also guide people on the spiritual path through satsang. A number of devotees came closer to darbar through this and visited Kandivali more often and in greater numbers.Many devotees came to the Darbar Sahib, discussed their problems with Dadiji, and got their solutions. Such had been her influence that Devotees had been requesting her to come to their towns, cities and homes and bless them. Dadiji had been showering blessings of the Gurus on the devotees and the benefits are apparent and visible. There are many stories of Dadiji helping devotees in need. Such has been her influence on the devotees that for marriages, buying of houses, starting of new business ventures, and even naming ceremonies of children, devotees have been seeking Dadiji benevolence.Annual Diwali Mela is the rallying point of entire Sangat. Devotees come from far and wide, from within the country and also from foreign countries. Darbar has regular visitors from USA, Canada, Spain, Dubai, etc. At Darbar Sahib every one eagerly awaited Dadiji doing ARDAAS and invoking the names of Gurus to seek their blessings for the entire Sangat who were present and also those who could not come physically for the Mela, but were mentally at the Darbar Sahib. Thus she continued the good work and traditions and customs started by the Gurus and gave them a great fillip. It was during the preparations of Diwali Mela of the year 1998, that Dadiji mentioned casually to the common people that NOW I CAN RETIRE. Within less than a week of Diwali Mela Dadi Gopi chose to release her ATMA from her mortal being and went unto the Gurujis charans on 25 th  Oct 1998. This was end of an era, but with the blessings of Saijans, the activities of Darbar Sahib continue as ever before.',
      headerValue: "Dadi Gopi",
      isExpanded: false,
    ),
    Item(
      expandedValue:
          'Dadi Kamla Badlani was born in on 31 st May 1917. Dadi Kamala had faced various tragedies in life. But also got support from various elderly with the result she learnt to be detached from worldly incidents and lead a simple life without desires. She lost her mother while she was an infant 2.5 years old. She lost her father at a tender age of about 12 years. Her upbringing was done by her close aunts Devi Bijlani &amp; others. This influenced her to become vegetarian and came close to various spiritual people like Mata Chaini bai, Elder daughter-in-law of Vali Vilayatrai and others. Biggest blow came when she lost her husband Narayan Badlani at the young age of 25 in 1942. She got support from her father-in-law Gobindram Badlani &amp; her father Sukhramdas Tanwarmalani. Her father had passed away one year before her marriage. She was also close to Sai Vishindas from her young age and made him her Guru. In fact Sai Vishindas took responsibility of getting her married &amp; did her Kanya daan in her marriage. Sai Vishindas has also gave her Naam at the time of marriage and gifted her 3 things:1-18 th Chapter of Bhagwad Gita,2- Sukh sagar and a pen for writing letters to Sai Vishindas after marriage. Dadi Kamala was guided spiritually by her father Sukhramdas and her father-in-law. She was also guided by the enlightened Totaram Hingorani a family-friend. After passing away of her husband, Dadi Kamala spent lot of time with Totaram Hingorani, who taught her from Vedanta and Sami’s shlokas. She also started wearing Khadi as an influence of her father,Totaram, etc. Thus Dadi got highly spiritually enlightened, which showed in her day to day living as NO ANGER, no Desires, No desire to collect things or wealth. She could eat the same vegetable (Turia) 365 days in a year. These are qualities of Param Yogi. Dadi had her schooling in Convent school and her father-in-law encouraged her to do BA, &amp; so Dadi knew good English besides Hindi &amp; some knowledge of Sanskrit. Dadi had love for Krishna as her Isht Dev and had her room filled with Krishna’s pictures. She attended 5 days of Shrimad Bhagwat Saptah at Kambar Darbar in Feb 2015 and left her mortal body (at 97 years age), on 6th day morning focussing her sight on Krishna’s picture in her room.',
      headerValue: "Dadi Kamla",
      isExpanded: false,
    ),
    Item(
      expandedValue:
          'Day-to-day activities of Darbar Sahib are presently looked after by the trustees.  \n In 1942, Sai Vishindas had nominated four Trustees, viz, Shri Brahmanand Sainani, Shri Mohanlal Hingorani, Shri Narain Vaswani and Shri Ram Bhambhani. The Trustees main responsibility is to manage the property of Darbar Sahib spread over one acre of land at Kandivali (West), (Shantilal Modi Road, about 10 minutes walking distance from Kandivali Station), Mumbai. \n The Darbar Sahib has three dharamshala buildings and the main Mandir building. The Darbar Sahib runs medical facilities as per today"s needs, i.e.specialists like gynaecologist, eye surgery, skin specialist, orthopedic, ENT, heart, diabetes, etc.',
      headerValue: "The Trust",
      isExpanded: false,
    ),
    Item(
      expandedValue:
          '(It is the duties of the trustees to run the activities of Darbar as per Trust Deed prepared by Saijans and follow the laws and rules and regulations as applicable at that time.) \n The current trustees are : \n Sai Vilayatrai Sai Jiwatsingh Kambar Darbar Sahib Trust: \n 1. Shri Prabhu S Sainani \n 2. Shri Shamsunder L Sidhwani \n 3. Shri Raveen Chugani \n 4. Narain Chhalwani \n\n Sai Vilayatrai Sai Jiwatsingh Sai Vishindas Charitable Trust: \n 1. Shri Prabhu Sainani \n 2. Shri Shamsunder Sidhwani \n 3. Shri Ashok Dudani \n 4. Dr. Prakash Chandiramani \n Shri Prabhu S Sainani is the resident Trustee who looks after the day-to- day administrative and charitable (medical and educational) activities of the Trust. \n Email: p_sainani@rediffmail.com \n info@kambardarbar.org \n Tele: Kambar Darbar: 8976081672 (Darbar), 9029911644(GeneralClinic), 7400072847(Dental Clinic)',
      headerValue: "Trustees",
      isExpanded: false,
    ),
  ];
}
