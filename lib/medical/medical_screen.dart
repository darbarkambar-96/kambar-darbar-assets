import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';

class MedicalScreen extends StatelessWidget {
  const MedicalScreen({Key? key}) : super(key: key);

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

        final List<Map<String, String>> medicalSections = [
          {
            'title': lang == 0
                ? '🏥 Healing Through Medicine: Our Mission'
                : '🏥 चिकित्सा द्वारा सेवा: हमारा पावन संकल्प',
            'body': lang == 0
                ? 'Kambar Darbar continues the sacred legacy of its Satgurus, transitioning from performing miracles to healing through medicine.\n\n• Dedicated Facility: In 2008, Block E was constructed to house a fully equipped, well-planned medical center.\n\n• Charitable Trust: Managed by the Sain Vilayatrai Sain Jiwatsingh Sain Vishindas Charitable Trust, dedicated to providing high-quality medical care to the needy, infirm, and underprivileged at highly subsidized rates.\n\n• Inclusive Seva: All healthcare services are provided irrespective of caste, religious beliefs, or place of residence.\n\n• Dedicated Doctors: Many highly experienced specialist doctors have remained associated with the Darbar dispensary for years, inspired by the Satgurus’ message of selfless service and humility.'
                : 'कांबर दरबार पूज्य सतगुरुओं की पावन परंपरा को आगे बढ़ाते हुए चमत्कारों के स्थान पर चिकित्सा द्वारा आरोग्य प्रदान करने की सेवा में समर्पित है।\n\n• सुसज्जित भवन: वर्ष 2008 में एक सर्व-सुविधायुक्त एवं आधुनिक चिकित्सा केंद्र हेतु ब्लॉक E का निर्माण किया गया।\n\n• चेरिटेबल ट्रस्ट: इसका संचालन सांईं विलायतराय सांईं जीवतसिंह सांईं विशिनदास चेरिटेबल ट्रस्ट द्वारा किया जाता है, जो निर्धनों व जरूरतमंदों को रियायती दरों पर गुणवत्तापूर्ण स्वास्थ्य सेवा प्रदान करने हेतु संकल्पित है।\n\n• समदर्शी सेवा: सभी स्वास्थ्य सेवाएं बिना किसी जाति, धर्म या निवास स्थान के भेदभाव के प्रदान की जाती हैं।\n\n• निष्काम चिकित्सक: सतगुरुओं की निःस्वार्थ सेवा भावना से प्रेरित होकर कई विशेषज्ञ डॉक्टर वर्षों से दरबार के औषधालय से जुड़े हुए हैं।',
          },
          {
            'title': lang == 0
                ? '🩺 General OPD & Dispensary'
                : '🩺 सामान्य ओपीडी एवं औषधालय',
            'body': lang == 0
                ? '• Nominal Fee: Complete doctor consultation and necessary prescribed medicines are provided for a nominal token fee of just ₹20/-.\n\n• Accessible Healthcare: The charitable dispensary operates daily with fees ranked among the lowest across comparable charitable trusts in the region.'
                : '• सांकेतिक शुल्क: डॉक्टर का परामर्श एवं आवश्यक दवाएं मात्र ₹20/- के न्यूनतम सांकेतिक शुल्क पर उपलब्ध कराई जाती हैं।\n\n• सुलभ स्वास्थ्य सेवा: चेरिटेबल औषधालय प्रतिदिन संचालित होता है और इसकी दरें अन्य सभी समतुल्य ट्रस्टों की तुलना में अत्यंत न्यूनतम हैं।',
          },
          {
            'title': lang == 0
                ? '👁️ Cataract Surgery (Eye Care)'
                : '👁️ मोतियाबिंद ऑपरेशन (नेत्र सुरक्षा)',
            'body': lang == 0
                ? '• Free Surgeries: Complete cataract procedures and post-operative care are provided 100% free of charge for individuals living below the poverty line.\n\n• Subsidized Care: For all other patients, surgeries are offered at approximately one-third the cost of private clinics, depending on the chosen lens type.'
                : '• निःशुल्क ऑपरेशन: गरीबी रेखा से नीचे जीवनयापन करने वाले जरूरतमंदों के लिए मोतियाबिंद के संपूर्ण ऑपरेशन व दवाएं 100% निःशुल्क हैं।\n\n• रियायती दरें: अन्य सभी मरीजों के लिए निजी अस्पतालों की तुलना में लगभग एक-तिहाई लागत पर आधुनिक लेंस प्रत्यारोपण व सर्जरी की सुविधा उपलब्ध है।',
          },
          {
            'title': lang == 0
                ? '🎗️ Cervical Cancer Screening & Vaccination'
                : '🎗️ सर्वाइकल कैंसर जांच एवं टीकाकरण',
            'body': lang == 0
                ? '• Free Examination: Comprehensive screening tests and examinations for early detection of cervical cancer are conducted free of charge.\n\n• Subsidized Vaccination: Preventive vaccination for girls and young women up to age 24 is provided at just ₹500/- (heavily subsidized from the actual market price of ₹2,500/- for branded vaccines from reputed manufacturers).'
                : '• निःशुल्क परीक्षण: सर्वाइकल कैंसर की प्रारंभिक अवस्था में पहचान हेतु संपूर्ण जांच व परीक्षण शिविर पूर्णतः निःशुल्क आयोजित किए जाते हैं।\n\n• रियायती टीका: 24 वर्ष तक की बालिकाओं एवं युवतियों के लिए यह जीवनरक्षक टीका मात्र ₹500/- में लगाया जाता है (प्रतिष्ठित कंपनियों के इस टीके का बाजार मूल्य लगभग ₹2,500/- है)।',
          },
          {
            'title': lang == 0
                ? '🔬 Diagnostic Services (Pathology & Imaging)'
                : '🔬 पैथोलॉजी एवं डायग्नोस्टिक सेवाएं',
            'body': lang == 0
                ? '• Affordable Diagnostics: X-rays, pathology blood tests, and routine diagnostic laboratory procedures are available to all patients at half the standard market rate.'
                : '• रियायती परीक्षण: डिजिटल एक्स-रे, रक्त परीक्षण एवं अन्य सभी आवश्यक लैब जांचें बाजार दरों से लगभग आधी कीमत पर की जाती हैं।',
          },
          {
            'title': lang == 0
                ? '🦷 Dental Care & Treatments'
                : '🦷 दंत चिकित्सा एवं आधुनिक उपचार',
            'body': lang == 0
                ? '• Comprehensive Dental Clinic: Routine checkups, fillings, cleanings, and specialized dental procedures are available at highly subsidized rates.'
                : '• आधुनिक डेंटल क्लिनिक: नियमित दांतों की जांच, रूट कैनाल, स्केलिंग, फिलिंग व अन्य सभी विशेष दंत उपचार अत्यधिक रियायती दरों पर उपलब्ध हैं।',
          },
        ];

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            backgroundColor: appBarColor,
            elevation: 0.5,
            centerTitle: true,
            title: Text(
              lang == 0 ? 'Medical Facilities' : 'चिकित्सा एवं स्वास्थ्य सेवा',
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
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              // Contact Card for Direct Medical Inquiries
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [const Color(0xFF2C221E), const Color(0xFF1E1714)]
                        : [const Color(0xFFFFF3E0), const Color(0xFFFFE0B2)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFFFFB74D).withOpacity(0.4),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.08),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.local_hospital_rounded, color: accentColor, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang == 0 ? "Charitable Clinic Helpline" : "चिकित्सा केंद्र संपर्क सूत्र",
                            style: GoogleFonts.poppins(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: accentColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lang == 0
                                ? "General Clinic: 9029911644\nDental Clinic: 7400072847"
                                : "सामान्य चिकित्सालय: 9029911644\nदंत चिकित्सालय: 7400072847",
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              height: 1.45,
                              fontWeight: FontWeight.w500,
                              color: primaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Medical Modules
              ...medicalSections.asMap().entries.map((entry) {
                final int index = entry.key;
                final Map<String, String> item = entry.value;

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
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}