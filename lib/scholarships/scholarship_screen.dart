import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';

class ScholarshipScreen extends StatefulWidget {
  const ScholarshipScreen({Key? key}) : super(key: key);

  @override
  State<ScholarshipScreen> createState() => _ScholarshipScreenState();
}

class _ScholarshipScreenState extends State<ScholarshipScreen> {
  static const String _formUrl =
      'https://www.classic24digital.com/kambardarbar/Scholarship_form.pdf';
  static const String _fallbackWebsite = 'https://www.kambardarbar.org';

  Future<void> _downloadForm(BuildContext context, int lang) async {
    final Uri uri = Uri.parse(_formUrl);
    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(
          Uri.parse(_fallbackWebsite),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              lang == 0
                  ? 'Could not download form. Please visit www.kambardarbar.org'
                  : 'फॉर्म डाउनलोड करने में असमर्थ। कृपया www.kambardarbar.org पर जाएं।',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.deepOrange,
          ),
        );
      }
    }
  }

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

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            backgroundColor: appBarColor,
            elevation: 0.5,
            centerTitle: true,
            title: Text(
              lang == 0 ? 'Educational Support' : 'शैक्षिक छात्रवृत्ति योजना',
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
            children: [
              // Hero Banner Card
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(18),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.school_rounded, color: accentColor, size: 26),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang == 0
                                    ? "SAI VILAYATRAI SCHOLARSHIP"
                                    : "सांईं विलायतराय छात्रवृत्ति योजना",
                                style: GoogleFonts.poppins(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                  color: accentColor,
                                ),
                              ),
                              Text(
                                lang == 0
                                    ? "For Higher Professional Courses"
                                    : "उच्च व्यावसायिक पाठ्यक्रमों हेतु",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: primaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      lang == 0
                          ? "Sai Vilayatrai Charitable Trust, Mumbai grants educational scholarships ranging up to ₹20,000/- per year to meritorious and needy students pursuing recognized higher professional education."
                          : "सांईं विलायतराय चेरिटेबल ट्रस्ट, मुंबई द्वारा उच्च व्यावसायिक शिक्षा ग्रहण कर रहे प्रतिभावान एवं जरूरतमंद विद्यार्थियों को प्रतिवर्ष ₹20,000/- तक की शैक्षिक छात्रवृत्ति प्रदान की जाती है।",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        height: 1.55,
                        color: primaryText,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                      ),
                      onPressed: () => _downloadForm(context, lang),
                      icon: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
                      label: Text(
                        lang == 0 ? "Download Application Form" : "आवेदन पत्र डाउनलोड करें",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Eligibility Card
              _buildSectionCard(
                isDark: isDark,
                cardBg: cardBg,
                accentColor: accentColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                dividerColor: dividerColor,
                icon: Icons.checklist_rtl_rounded,
                title: lang == 0 ? "Eligible Courses & Students" : "पात्रता एवं पाठ्यक्रम",
                content: lang == 0
                    ? "1. Professional Degrees & Programs:\nStudents pursuing Engineering, MBBS / Medicine, BDS, MCA, BIT, CA (CPT / IPCC / Final), CFA, CS, Pharmacy, B.Arch, or MBA (from a reputed institute with above 70% marks in graduation).\n\n2. Higher Secondary Students:\nHigh school students who have secured more than 80% marks in SSC (English medium) and are diligently preparing for higher professional degree courses.\n\n3. Community Preference:\nPreference is accorded to students from the Sindhi community, especially those residing in the proximity of Darbar Sahib."
                    : "1. व्यावसायिक पाठ्यक्रम:\nइंजीनियरिंग, एमबीबीएस / चिकित्सा, बीडीएस, एमसीए, बीआईटी, सीए (फाउंडेशन / इंटर / फाइनल), सीएफए, सीएस, फार्मेसी, बी.आर्क, अथवा एमबीए (प्रतिष्ठित संस्थान से स्नातक में 70% से अधिक अंक प्राप्त)।\n\n2. उच्च माध्यमिक स्तर:\nएसएससी (अंग्रेजी माध्यम) में 80% से अधिक अंक प्राप्त करने वाले तथा व्यावसायिक पाठ्यक्रमों की तैयारी में जुटे मेधावी छात्र।\n\n3. वरीयता:\nसिंधी समुदाय तथा दरबार साहिब के निकटवर्ती क्षेत्रों में निवास करने वाले निर्धन व पात्र छात्रों को प्राथमिकता दी जाती है।",
              ),

              // Application Process & Guidelines
              _buildSectionCard(
                isDark: isDark,
                cardBg: cardBg,
                accentColor: accentColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                dividerColor: dividerColor,
                icon: Icons.assignment_outlined,
                title: lang == 0 ? "Application Instructions" : "आवेदन प्रक्रिया एवं निर्देश",
                content: lang == 0
                    ? "• Application Submission:\nApplications for the grant of scholarship must be submitted strictly in the prescribed format, downloadable from the app or official website (www.kambardarbar.org).\n\n• Enclosures:\nApplications must always be accompanied by attested photocopies of ALL required certificates, marks sheets, fee receipts, and income proofs indicated on the form.\n\n• Clarifications & Queries:\nFor any questions or guidance, please email:\np_sainani@rediffmail.com\n\n⚠️ NOTE: Please communicate via email only. No phone calls regarding scholarships will be accepted."
                    : "• आवेदन जमा करना:\nछात्रवृत्ति हेतु आवेदन केवल निर्धारित प्रारूप में ही स्वीकार किया जाएगा, जिसे ऐप अथवा वेबसाइट (www.kambardarbar.org) से डाउनलोड किया जा सकता है।\n\n• आवश्यक दस्तावेज:\nआवेदन पत्र के साथ मांगे गए सभी अंकपत्रों, शुल्क रसीदों, आय प्रमाण पत्रों आदि की स्व-प्रमाणित प्रतियां संलग्न करना अनिवार्य है।\n\n• पूछताछ एवं मार्गदर्शन:\nकिसी भी स्पष्टीकरण हेतु केवल ईमेल द्वारा संपर्क करें:\np_sainani@rediffmail.com\n\n⚠️ ध्यान दें: छात्रवृत्ति के संबंध में फोन कॉल्स स्वीकार नहीं किए जाएंगे।",
              ),

              // Subsidized Notebooks Card
              _buildSectionCard(
                isDark: isDark,
                cardBg: cardBg,
                accentColor: accentColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                dividerColor: dividerColor,
                icon: Icons.menu_book_rounded,
                title: lang == 0 ? "Subsidized Notebooks Seva" : "रियायती नोटबुक वितरण सेवा",
                content: lang == 0
                    ? "As part of its ongoing educational empowerment mission, Kambar Darbar distributes approximately 15,000 full-length / A4 quality notebooks annually at half the open-market price to school and college students.\n\nNotebooks can be collected from the Darbar office in Kandivli (West), Mumbai prior to the commencement of each academic year."
                    : "शिक्षा को प्रोत्साहन देने के उद्देश्य से कांबर दरबार द्वारा प्रतिवर्ष लगभग 15,000 उत्तम गुणवत्ता वाली फुल-लेंथ (A4) कॉपियां खुले बाजार से आधी कीमत (50% रियायत) पर वितरित की जाती हैं।\n\nप्रत्येक शैक्षणिक सत्र के प्रारंभ में विद्यार्थी इन्हें कांदिवली स्थित दरबार कार्यालय से प्राप्त कर सकते हैं।",
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({
    required bool isDark,
    required Color cardBg,
    required Color accentColor,
    required Color primaryText,
    required Color secondaryText,
    required Color dividerColor,
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: accentColor, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(height: 1, color: dividerColor),
            const SizedBox(height: 12),
            Text(
              content,
              style: GoogleFonts.poppins(
                fontSize: 13,
                height: 1.6,
                fontWeight: FontWeight.w400,
                color: secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}