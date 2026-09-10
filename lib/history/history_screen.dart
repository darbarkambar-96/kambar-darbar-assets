import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([themeNotifier, languageNotifier]),
      builder: (context, _) {
        final bool isDark = themeNotifier.value == ThemeMode.dark;
        final int lang = languageNotifier.value; // 0 = English, 1 = Hindi

        final Color scaffoldBg = isDark
            ? const Color(0xFF131315)
            : const Color.fromRGBO(235, 236, 222, 1);
        final Color cardBg = isDark ? const Color(0xFF1E1E24) : Colors.white;
        final Color primaryText = isDark ? Colors.white : const Color(0xFF2C221E);
        final Color secondaryText = isDark ? Colors.white70 : Colors.black87;
        final Color appBarColor = isDark ? const Color(0xFF1E1E24) : Colors.white;
        final Color accentColor = isDark ? const Color(0xFFFF9E80) : const Color(0xFFE65100);
        final Color dividerColor = isDark ? Colors.white12 : Colors.black12;

        final List<Map<String, String>> historySections = [
          {
            'title': lang == 0
                ? '🌟 Kambar Darbar: A Sacred Legacy of Sindh'
                : '🌟 कांबर दरबार: सिंध की पावन आध्यात्मिक धरोहर',
            'body': lang == 0
                ? 'The region of Sindh—now in Pakistan—has been graced by many saints, darvishes, and aulias. Among them, three profoundly powerful spiritual masters stand out: Sain Vali Vilayatrai of Old Hala, Sain Jiwatsingh Sainani, and Sain Vishindas Sainani of Kambar. These enlightened souls manifested on Earth to guide seekers toward divine realization and spiritual elevation.'
                : 'सिंध की पावन भूमि को अनेक संतों, दरवेशों और औलियाओं का आशीर्वाद प्राप्त रहा है। इनमें तीन परम पूज्य संत शिरोमणि हैं: पुरानी हाला के सांईं वली विलायतराय साहिब, कांबर के सांईं जीवतसिंह सैनाणी साहिब और सांईं विशिनदास सैनाणी साहिब। इन दिव्य विभूतियों ने धरा पर अवतरित होकर जन-कल्याण और आत्म-साक्षात्कार का मार्ग प्रशस्त किया।',
          },
          {
            'title': lang == 0
                ? '🕉️ Sain Vali Vilayatrai: Supreme Knowledge'
                : '🕉️ सांईं वली विलायतराय: परम ज्ञान स्वरूप',
            'body': lang == 0
                ? 'As noted by Padam Shri Professor Shri Ram Panjwani in his book Sindh Ja Sant, Sain Vali Vilayatrai was one of the most revered saints of Sindh. He manifested on Janmashtami night in 1825, and astonishingly, foretold the date of his departure from this world nearly a year in advance.\n\nHis spiritual power was so immense that devotees would enter a trance merely by meeting his gaze. One glance from him could liberate souls. A remarkable incident mirrors the story of Rishi Markandeya from the Shrimad Bhagwatam, who witnessed the Lord’s Maya. Similarly, a devotee Bhai Lilaram burdened by sixty years of sin was instantly absolved by Vali’s divine grace. He was the epitome of Gnan—Supreme Knowledge.'
                : 'पद्मश्री प्रो. राम पंजवाणी ने अपनी पुस्तक "सिंध जा संत" में सांईं विलायतराय साहिब को सिंध के महानतम संतों में स्थान दिया है। सांईंजन का प्राकट्य 1825 की जन्माष्टमी की रात हुआ। उन्होंने अपने निर्वाण की तिथि एक वर्ष पूर्व ही प्रकट कर दी थी।\n\nउनकी दिव्य दृष्टि में ऐसा अलौकिक तेज था कि मात्र दृष्टिपात से भक्तजन समाधिलीन हो जाते थे। जिस प्रकार श्रीमद्भागवत में ऋषि मार्कंडेय को प्रभु की माया के दर्शन हुए, उसी प्रकार भाई लीलाराम के साठ वर्षों के पाप सांईं की एक कृपा दृष्टि से नष्ट हो गए। वे ज्ञान के साक्षात स्वरूप थे।',
          },
          {
            'title': lang == 0
                ? '🙏 Sain Jiwatsingh Sainani: Bhakti Marg'
                : '🙏 सांईं जीवतसिंह सैनाणी: पावन भक्ति मार्ग',
            'body': lang == 0
                ? 'Born in Kambar, Sain Jiwatsingh was initially immersed in worldly pleasures. Yet, a single glance from Sain Vilayatrai transformed him into one of Sindh’s most humble and powerful saints. His devotion to his Guru and to Bhagwan Krishna was unwavering. He emphasized Bhakti and the chanting of Parmatma’s name, composing over a hundred and twenty five Kalaams in praise of his Guru and Krishna. Like his Guru, he too announced his departure a year in advance.'
                : 'कांबर में जन्मे सांईं जीवतसिंह जी पहले सांसारिक सुखों में लीन थे। परंतु सांईं विलायतराय साहिब की एक पावन दृष्टि ने उनका जीवन पूरी तरह रूपांतरित कर दिया। वे परम विनम्र संत बने। उनकी अपने गुरु और भगवान श्रीकृष्ण के प्रति अनन्य भक्ति थी। उन्होंने गुरु महिमा और प्रभु प्रेम में 125 से अधिक पावन कलामों की रचना की। अपने गुरु की भांति उन्होंने भी अपने प्रयाण की घोषणा एक वर्ष पूर्व कर दी थी।',
          },
          {
            'title': lang == 0
                ? '🌼 Sain Vishindas Sainani: The Karam Yogi'
                : '🌼 सांईं विशिनदास सैनाणी: निष्काम कर्मयोगी',
            'body': lang == 0
                ? 'From childhood, Sain Vishindas displayed the qualities of a truly enlightened soul. He inherited the spiritual legacy of both Sain Vilaytrai and Sain Jiwatsingh. A true Karma Yogi, he dedicated his life to selfless Seva, always attributing reverence to his Satgurus and never allowing anyone to touch his feet. He announced his departure 40 days in advance, continuing the tradition of divine foresight.'
                : 'बाल्यावस्था से ही सांईं विशिनदास साहिब एक प्रबुद्ध संत के गुणों से संपन्न थे। उन्हें सांईं विलायतराय और सांईं जीवतसिंह जी का पूर्ण आशीर्वाद प्राप्त हुआ। वे सच्चे कर्मयोगी थे जिन्होंने अपना संपूर्ण जीवन निःस्वार्थ सेवा में समर्पित कर दिया। वे सारा श्रेय अपने सतगुरुओं को देते थे और कभी किसी को अपने चरण स्पर्श नहीं करने देते थे। उन्होंने अपने निर्वाण की पूर्व सूचना 40 दिन पहले दी थी।',
          },
          {
            'title': lang == 0
                ? '🛕 The Establishment of Kambar Darbar'
                : '🛕 कांबर दरबार की पावन स्थापना',
            'body': lang == 0
                ? 'Kambar Darbar was founded in the village of Kambar by Sain Jiwatsingh in sacred memory of his Satguru, Sain Vilayatrai, who later made Kambar his final abode. Upon Sain Vilaytai’s departure in 1987, Sain Jiwatsingh constructed his Samadhi there, and the site became known as Sain Vali Vilayatrai’s Darbar.\n\nLater, Sain Jiwatsingh’s Samadhi was built adjacent to Vali’s by Sain Vishindas. When Sain Vishindas left his mortal body, his Samadhi was added to the same podium by the trustees.'
                : 'कांबर दरबार की स्थापना सांईं जीवतसिंह साहिब द्वारा अपने सतगुरु सांईं विलायतराय साहिब की स्मृति में कांबर गांव में की गई। सांईं विलायतराय जी के महाप्रयाण के पश्चात वहां उनकी पावन समाधि बनाई गई, जिसे "सांईं वली विलायतराय जो दरबार" कहा गया।\n\nकालांतर में सांईं विशिनदास जी द्वारा सांईं जीवतसिंह जी की समाधि भी समीप बनाई गई। जब सांईं विशिनदास जी ज्योति-जोत समाए, तो ट्रस्टियों द्वारा उसी पावन चबूतरे पर उनकी समाधि भी स्थापित की गई।',
          },
          {
            'title': lang == 0
                ? '🪔 The Journey to India'
                : '🪔 भारत आगमन एवं पवित्र स्थापना',
            'body': lang == 0
                ? 'Adi Chainibai, lovingly known as Adi Darbar Wari, took care of Darbar after Sain Vishindas left this world. As the devotees who had migrated to India after the partition insisted that she must migrate too, so she migrated to India. With the help of Shri Hari Dilgir, a respected civil engineer and renowned Sindhi poet, she took a portion of sacred ash from the Samadhis in Kambar. Similar majestic Samadhis were constructed in a serene location in Kandivli, Mumbai.'
                : 'सांईं विशिनदास जी के पश्चात "आदी दरबार वारी" के नाम से पूजनीय आदी चैनीबाई ने दरबार की सेवा संभाली। विभाजन के बाद भारत आए श्रद्धालुओं के विशेष आग्रह पर आदी चैनीबाई भारत पधारीं। प्रसिद्ध सिंधी कवि व सिविल इंजीनियर श्री हरी दिलगीर के सहयोग से, वे कांबर की समाधियों से पवित्र भस्म (धूल) लेकर आईं और कांदिवली, मुंबई के शांत वातावरण में वैसा ही भव्य समाधि स्थल निर्मित किया गया।',
          },
          {
            'title': lang == 0
                ? '🏢 Kambar Darbar in Kandivli, Mumbai'
                : '🏢 कांदिवली, मुंबई में कांबर दरबार',
            'body': lang == 0
                ? 'Spread across a large plot in Kandivli, the Darbar comprises four buildings:\n\nThe main Darbar building has three rooms:\n• The first houses the Guru Granth Sahibji.\n• The middle room enshrines the three Samadhis of the Satgurus.\n• The third room displays large portraits of the Satgurus, Sain Vishindas’ Sukshma Sareer(Phul), Mata Sahib’s Phul and picture, Dadi Gopi Sahib’s Phul and picture, Dadi Kamla Sahib’s picture, and a life-size image of Shrinathji.\n\nA spacious Otla (Thalla) connects the rooms and serves as the venue for Satsangs and spiritual programs.'
                : 'कांदिवली में विशाल भूखंड पर स्थित दरबार में चार प्रमुख भवन हैं:\n\nमुख्य दरबार भवन में तीन पावन कक्ष हैं:\n• प्रथम कक्ष में श्री गुरु ग्रंथ साहिब जी का पावन प्रकाश है।\n• मध्य कक्ष में पूज्य सतगुरुओं की तीन पवित्र समाधियां सुशोभित हैं।\n• तीसरे कक्ष में सतगुरुओं के भव्य चित्र, सांईं विशिनदास जी का सूक्ष्म शरीर (फूल), माता साहिब का फूल व चित्र, दादी गोपी साहिब का फूल व चित्र, दादी कमला साहिब का चित्र तथा श्रीनाथजी का विग्रह विराजमान है।\n\nविशाल ओटला (थल्ला) इन कक्षों को जोड़ता है जहां नियमित सत्संग एवं आध्यात्मिक आयोजन होते हैं।',
          },
          {
            'title': lang == 0
                ? '🏘️ Expansion and Facilities'
                : '🏘️ विस्तार एवं विश्राम सुविधाएं',
            'body': lang == 0
                ? '• Block A, adjacent to the Darbar, initially had a few rooms. As the number of devotees grew, Blocks C and D were added.\n\n• In 2008, Block E was constructed to house a well-planned medical center.\n\n• Together, the buildings offer over 100 rooms to accommodate guests from across India and countries like the USA, UK, Spain, New Zealand, UAE, Singapore, and more.\n\n• The 3-day Diwali Mela attracts over a thousand devotees, making it a truly grand celebration.'
                : '• मुख्य दरबार के पास स्थित ब्लॉक A में प्रारंभ में कुछ कमरे थे। भक्तों की बढ़ती संख्या को देखते हुए ब्लॉक C और D जोड़े गए।\n\n• वर्ष 2008 में सुव्यवस्थित चिकित्सा केंद्र के लिए ब्लॉक E का निर्माण किया गया।\n\n• सभी भवनों में मिलाकर 100 से अधिक कमरे हैं जहां देश-विदेश (अमेरिका, इंग्लैंड, स्पेन, न्यूजीलैंड, दुबई, सिंगापुर आदि) से आने वाले श्रद्धालुओं के ठहरने की उत्तम व्यवस्था है।\n\n• 3 दिवसीय दीपावली मेला एक अत्यंत भव्य उत्सव होता है जिसमें सहस्रों श्रद्धालु सम्मिलित होते हैं।',
          },
          {
            'title': lang == 0
                ? '🍛 Hospitality and Seva'
                : '🍛 अतिथि सत्कार एवं निःस्वार्थ सेवा',
            'body': lang == 0
                ? 'Every effort is made to ensure the comfort of the Sangat. Tea and Langar—including breakfast, lunch, and dinner—are served with immense love. There are no charges for any service, and donations are never solicited.\n\nThere are no signboards asking for donations. Yet, contributions flow abundantly, guided purely by devotion. If someone wishes to donate for a specific cause, they are respectfully guided—without expectation.'
                : 'संगत की सुख-सुविधा का संपूर्ण ध्यान रखा जाता है। चाय एवं गुरु का लंगर (नाश्ता, दोपहर व रात्रि का भोजन) अगाध प्रेम से परोसा जाता है। किसी भी सेवा का कोई शुल्क नहीं लिया जाता और न ही कभी दान की मांग की जाती है।\n\nदरबार में दान मांगने का कोई बोर्ड नहीं है। फिर भी श्रद्धावश दान स्वतः प्रवाहित होता है। यदि कोई किसी विशेष सेवा हेतु दान देना चाहे, तो उन्हें बिना किसी अपेक्षा के सम्मानपूर्वक मार्गदर्शन दिया जाता है।',
          },
          {
            'title': lang == 0
                ? '📚 Literature and Medical Services'
                : '📚 आध्यात्मिक साहित्य एवं चिकित्सा सेवा',
            'body': lang == 0
                ? '• Biographies (Jeevan Charitra) of the Satgurus are available in Arabic Sindhi, Devanagari Sindhi, Hindi, and English.\n\n• Sain Jiwatsingh Sahib’s Kalaams are available in Arabic and Devanagari Sindhi, with meanings.\n\n• All books are distributed free of charge.\n\n• The charitable dispensary offers OPD and specialized medical services at minimal fees, among the lowest in similar trusts. Many doctors, highly specialized in their fields, have remained associated with the Darbar for years—drawn by its spirit of selfless service and humility, as taught by the Satgurus.'
                : '• पूज्य सतगुरुओं के जीवन चरित्र अरबी सिंधी, देवनागरी सिंधी, हिंदी एवं अंग्रेजी में उपलब्ध हैं।\n\n• सांईं जीवतसिंह साहिब के कलाम अरबी व देवनागरी सिंधी में अर्थ सहित उपलब्ध हैं।\n\n• सभी धार्मिक पुस्तकें निःशुल्क वितरित की जाती हैं।\n\n• चेरिटेबल डिस्पेंसरी में ओपीडी और विशेषज्ञ चिकित्सा सेवाएं अत्यंत न्यूनतम दर पर दी जाती हैं। अनेक प्रख्यात डॉक्टर सतगुरुओं की सेवा और विनम्रता की शिक्षा से प्रेरित होकर वर्षों से दरबार से जुड़े हुए हैं।',
          },
        ];

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            backgroundColor: appBarColor,
            elevation: 0.5,
            centerTitle: true,
            title: Text(
              lang == 0 ? 'History of Kambar Darbar' : 'कांबर दरबार का पावन इतिहास',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: accentColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: accentColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: historySections.length,
            itemBuilder: (context, index) {
              final item = historySections[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.black.withOpacity(0.04),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black45 : Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    colorScheme: ColorScheme.fromSwatch().copyWith(
                      secondary: accentColor,
                    ),
                  ),
                  child: ExpansionTile(
                    initiallyExpanded: index == 0,
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    title: Text(
                      item['title']!,
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                      ),
                    ),
                    iconColor: accentColor,
                    collapsedIconColor: isDark ? Colors.white54 : Colors.grey,
                    children: [
                      Divider(height: 1, color: dividerColor),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item['body']!,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                            color: secondaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}