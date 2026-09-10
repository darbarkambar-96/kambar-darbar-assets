import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({Key? key}) : super(key: key);

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
        final Color secondaryText = isDark ? Colors.white70 : Colors.black87;
        final Color appBarColor = isDark ? const Color(0xFF1E1E24) : Colors.white;
        final Color accentColor = isDark ? const Color(0xFFFF9E80) : const Color(0xFFE65100);
        final Color dividerColor = isDark ? Colors.white12 : Colors.black12;

        final List<Map<String, String>> programSections = [
          {
            'title': lang == 0
                ? '🏥 Medical Services & Benevolent Initiatives'
                : '🏥 चिकित्सा सेवाएं एवं परोपकारी पहल',
            'body': lang == 0
                ? 'Kambar Darbar continues the legacy of Satgurus, who were known for their divine powers. Guided by his revered Satguru, Sain Vilayatrai Sahib, Sain Jiwatsingh Sahib transitioned from performing miracles to healing through medicine—a tradition that remains alive at the Darbar to this day.\n\nKey medical services offered include:\n\n• Cataract Surgery:\n  - Free for individuals below the poverty line\n  - Subsidized rates for others—approximately one-third the cost of private clinics, depending on lens type\n\n• General OPD:\n  - Consultation and medicines provided for a nominal fee of ₹20/-\n\n• Cervical Cancer Screening:\n  - Free examination for early detection\n  - Vaccination for girls up to age 24 at ₹500/- (actual vaccine market cost: ₹2,500/- from reputed manufacturers)\n\n• Diagnostic Services:\n  - X-rays, blood tests, and other procedures at half the market rate\n\n• Dental Care:\n  - Treatments available at highly subsidized rates'
                : 'कांबर दरबार पूज्य सतगुरुओं की पावन परंपरा को निरंतर आगे बढ़ा रहा है। सतगुरु सांईं विलायतराय साहिब की प्रेरणा से सांईं जीवतसिंह साहिब ने चमत्कारों के स्थान पर चिकित्सा द्वारा सेवा को अपनाया—यह परंपरा दरबार में आज भी श्रद्धापूर्वक जारी है।\n\nप्रमुख चिकित्सा सेवाएं:\n\n• मोतियाबिंद (Cataract) ऑपरेशन:\n  - निर्धन व जरूरतमंदों के लिए पूर्णतः निःशुल्क\n  - अन्य व्यक्तियों के लिए निजी क्लीनिकों की तुलना में लगभग एक-तिहाई लागत पर अत्यंत रियायती दरें\n\n• सामान्य ओपीडी (General OPD):\n  - परामर्श एवं आवश्यक दवाएं मात्र ₹20/- के सांकेतिक शुल्क पर\n\n• सर्वाइकल कैंसर जांच:\n  - प्रारंभिक पहचान हेतु निःशुल्क जांच शिविर\n  - 24 वर्ष तक की बालिकाओं हेतु टीका मात्र ₹500/- में (बाजार मूल्य लगभग ₹2,500/-)\n\n• पैथोलॉजी एवं डायग्नोस्टिक:\n  - एक्स-रे, रक्त परीक्षण आदि बाजार दर से लगभग आधी कीमत पर\n\n• दंत चिकित्सा (Dental Care):\n  - आधुनिक उपचार अत्यंत रियायती दरों पर उपलब्ध',
          },
          {
            'title': lang == 0
                ? '🎓 Educational Support & Scholarships'
                : '🎓 शैक्षिक सहायता एवं छात्रवृत्ति',
            'body': lang == 0
                ? 'Kambar Darbar is deeply committed to empowering youth through education. Each year:\n\n• Scholarships: Awarded to poor and needy students at all levels of studies ranging from primary to graduation. Preference is given to students from the Sindhi community, particularly those residing in the vicinity of Darbar Sahib.\n\n• Application Forms: Available on the official website (www.kambardarbar.org) under the Charitable Activities section.\n\n• Subsidized Notebooks: Around 15,000 full-length/A4 notebooks are distributed annually at half the market price. (For more details, check the Scholarship section from the home page).'
                : 'कांबर दरबार शिक्षा के माध्यम से युवाओं के सशक्तीकरण हेतु पूर्णतः समर्पित है। प्रत्येक वर्ष:\n\n• छात्रवृत्तियां: प्राथमिक स्तर से लेकर स्नातक तक के निर्धन व जरूरतमंद विद्यार्थियों को वार्षिक छात्रवृत्ति प्रदान की जाती है। सिंधी समुदाय तथा दरबार साहिब के निकट रहने वाले विद्यार्थियों को प्राथमिकता दी जाती है।\n\n• आवेदन पत्र: आधिकारिक वेबसाइट (www.kambardarbar.org) पर "Charitable Activities" अनुभाग में उपलब्ध हैं।\n\n• रियायती नोटबुक वितरण: प्रतिवर्ष लगभग 15,000 फुल-लेंथ (A4) कॉपियां बाजार मूल्य से आधी दर पर वितरित की जाती हैं। (विस्तृत जानकारी हेतु होम पेज पर स्कॉलरशिप अनुभाग देखें)।',
          },
          {
            'title': lang == 0
                ? '🕉️ Spiritual Celebrations & Schedule'
                : '🕉️ धार्मिक उत्सव एवं पावन समय-सारणी',
            'body': lang == 0
                ? 'Kambar Darbar hosts a variety of religious events and spiritual gatherings throughout the year at its Kandivli, Mumbai premises:\n\n• Sainjan’s Varsi (Vali Vilayatrai & Sain Jiwatsingh Sahib): Night of 14 Jan to morning of 15 Jan\n• Dadi Kamla’s Tithi: Around 7 Feb\n• Cheti Chand: On the auspicious day\n• Mata Chaini Bai: 14 May\n• Guru Purnima: Morning program\n• Janmashtami: Midnight celebration\n• Sainjans’ Shraadh: 12th day of Shraadh period\n• Sain Vishindas Sahib’s Varsi: Around 6 Oct\n• Dadi Gopi’s Varsi: Around 25 Oct\n• Diwali Mela: Three days and nights of grand celebrations\n• Chand Program: Monthly observance\n• Weekly Sunday Satsang: Every Sunday (8:00 AM – 10:00 AM)\n• Sukhmani Sahib Path: Fourth/Last Sunday of every month (8:00 AM)\n\n*Program dates and timings are announced in advance via Vali Parivar and Kambar Darbar Intimation groups.'
                : 'कांदिवली, मुंबई स्थित कांबर दरबार में वर्ष भर अनेक पावन उत्सव और सत्संग आयोजित किए जाते हैं:\n\n• सांईंजन की वर्षी (सांईं विलायतराय व सांईं जीवतसिंह साहिब): 14 जनवरी की रात से 15 जनवरी सुबह तक\n• दादी कमला साहिब की तिथि: लगभग 7 फरवरी\n• चेटीचंड महोत्सव: चैत्र शुक्ल प्रतिपदा (पावन दिवस पर)\n• माता चैनीबाई साहिब: 14 मई\n• गुरु पूर्णिमा: प्रभात विशेष सत्संग व अरदास\n• श्रीकृष्ण जन्माष्टमी: मध्यरात्रि महा-उत्सव\n• सांईंजन का श्राद्ध: श्राद्ध पक्ष की 12वीं तिथि\n• सांईं विशिनदास साहिब की वर्षी: लगभग 6 अक्टूबर\n• दादी गोपी साहिब की वर्षी: लगभग 25 अक्टूबर\n• दीपावली मेला: तीन दिन व तीन रातों का भव्य महा-उत्सव\n• चाँद कार्यक्रम: प्रत्येक माह का पावन उत्सव\n• साप्ताहिक रविवार सत्संग: प्रत्येक रविवार (प्रातः 8:00 से 10:00)\n• श्री सुखमनी साहिब पाठ: प्रत्येक माह का अंतिम रविवार (प्रातः 8:00 बजे)\n\n*उत्सवों की सटीक तिथियां व समय वली परिवार एवं कांबर दरबार सूचना समूहों के माध्यम से पूर्व में सूचित किए जाते हैं।',
          },
          {
            'title': lang == 0
                ? '🙏 Our Mission & Voluntary Donors'
                : '🙏 हमारा ध्येय एवं स्वैच्छिक दानदाता',
            'body': lang == 0
                ? '• Our Mission:\nBeyond spiritual teachings and Satsang, Kambar Darbar is deeply rooted in service to the poor and deserving. With the blessings of our revered Sains, we remain committed to expanding our charitable and religious initiatives with humility and dedication.\n\n• The Donors:\nThe trustees of Darbar Sahib would like to thank all donors for contributing towards noble causes. Our Satgurus’ kripa will always be on them!\n\nOur Satgurus strictly forbade asking for donations. Treating it as the ultimate order, neither the trustees nor any other persons solicit donations from anyone. Devotees donate voluntarily. There is no shortage of anything at our Sainjans’ Darbar!'
                : '• हमारा ध्येय:\nआध्यात्मिक उपदेशों और सत्संग के साथ-साथ, कांबर दरबार निर्धनों और जरूरतमंदों की सेवा में अटूट निष्ठा रखता है। पूज्य सांईंजन के आशीर्वाद से हम अपने सेवा प्रकल्पों का निरंतर विस्तार कर रहे हैं।\n\n• परम हितैषी दानदाता:\nदरबार साहिब का ट्रस्ट उन सभी श्रद्धालुओं का हृदय से आभार व्यक्त करता है जो इस पुनीत कार्य में सहयोग करते हैं। सतगुरुओं की कृपा सदैव आप पर बनी रहे!\n\nहमारे सतगुरुओं ने दान मांगने का सख्त निषेध किया था। इसे सर्वोच्च आज्ञा मानकर, न तो ट्रस्टी और न ही कोई अन्य व्यक्ति कभी किसी से दान मांगता है। श्रद्धालु अपनी स्वेच्छा और श्रद्धा से दान अर्पण करते हैं। हमारे सांईंजन के दरबार में किसी वस्तु की कोई कमी नहीं है!',
          },
        ];

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            backgroundColor: appBarColor,
            elevation: 0.5,
            centerTitle: true,
            title: Text(
              lang == 0 ? 'Activities & Programs' : 'गतिविधियां एवं कार्यक्रम',
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
            itemCount: programSections.length,
            itemBuilder: (context, index) {
              final item = programSections[index];

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