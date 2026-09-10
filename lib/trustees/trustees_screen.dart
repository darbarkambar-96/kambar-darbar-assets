import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';

class TrusteesScreen extends StatelessWidget {
  const TrusteesScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([themeNotifier, languageNotifier]),
      builder: (context, _) {
        final bool isDark = themeNotifier.value == ThemeMode.dark;
        final int lang = languageNotifier.value; // 0 = English, 1 = Hindi

        final Color scaffoldBg =
        isDark ? const Color(0xFF131315) : const Color.fromRGBO(235, 236, 222, 1);
        final Color cardBg = isDark ? const Color(0xFF1E1E24) : Colors.white;
        final Color primaryText = isDark ? Colors.white : const Color(0xFF2C221E);
        final Color secondaryText = isDark ? Colors.white60 : const Color(0xFF7A6B63);
        const Color accentColor = Color(0xFFE65100);

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            backgroundColor: cardBg,
            elevation: 0.5,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: accentColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              lang == 0 ? 'Trust & Trustees' : 'ट्रस्ट और ट्रस्टी',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: accentColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Founding Vision & Collective Leadership
                _buildHeaderVisionCard(
                  isDark: isDark,
                  cardBg: cardBg,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                  accentColor: accentColor,
                  lang: lang,
                ),
                const SizedBox(height: 18),

                // 2. Management Committee (March 2025)
                _buildManagementCommitteeCard(
                  isDark: isDark,
                  cardBg: cardBg,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                  accentColor: accentColor,
                  lang: lang,
                ),
                const SizedBox(height: 18),

                // 3. Active Trusts
                _buildSectionHeader(
                  lang == 0 ? "Darbar Trusts" : "दरबार के पावन ट्रस्ट",
                  primaryText,
                ),
                const SizedBox(height: 10),

                // Trust 1: Medical / Charitable
                _buildTrustCard(
                  isDark: isDark,
                  cardBg: cardBg,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                  accentColor: accentColor,
                  icon: Icons.local_hospital_rounded,
                  title: lang == 0
                      ? "Sain Vilayatrai Sain Jiwatsingh Sain Vishindas Charitable Trust"
                      : "सांईं विलायतराय सांईं जीवतसिंह सांईं विशिनदास चैरिटेबल ट्रस्ट",
                  purpose: lang == 0
                      ? "Provides high-grade medical facilities to the needy, infirm, and underprivileged members of society at minimal or reasonable costs, regardless of caste, religious beliefs, or residence."
                      : "जाति, धर्म या निवास स्थान के भेदभाव के बिना समाज के निर्धन, असहाय व जरूरतमंद लोगों को अत्यधिक रियायती दरों पर चिकित्सा सेवाएं उपलब्ध कराना।",
                  trustees: [
                    "Shri Shamsunder Sidhwani",
                    "Shri Ashok Dudani",
                    "Dr. Prakash Chandiramani",
                    "Ms Toni Vaswani"
                  ],
                  trusteesHi: [
                    "श्री शमसुंदर सिधवाणी",
                    "श्री अशोक दुदानी",
                    "डॉ. प्रकाश चंदिरमाणी",
                    "सुश्री टोनी वासवानी"
                  ],
                  lang: lang,
                ),
                const SizedBox(height: 14),

                // Trust 2: Cultural / Spiritual / Darbar Sahib
                _buildTrustCard(
                  isDark: isDark,
                  cardBg: cardBg,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                  accentColor: accentColor,
                  icon: Icons.temple_hindu_rounded,
                  title: lang == 0 ? "Kambar Darbar Sahib Trust" : "कांबर दरबार साहिब ट्रस्ट",
                  purpose: lang == 0
                      ? "Oversees spiritual and cultural observances—including Diwali Mela, Sainjan’s Varsi, Janmashtami, Cheti Chand, Guru Purnima, and weekly Sunday morning Satsang—along with guest accommodation arrangements."
                      : "दीपावली मेला, सांईंजन की वरसी, श्रीकृष्ण जन्माष्टमी, चेटीचंड, गुरु पूर्णिमा और साप्ताहिक रविवार प्रभात सत्संग का सुचारू आयोजन व पधारे श्रद्धालुओं के ठहरने की समुचित व्यवस्था करना।",
                  trustees: [
                    "Shri Prabhu Sainani",
                    "Shri Raveen Chugani",
                    "Shri Narain Chhalwani",
                    "Shri Manoj Nairyani"
                  ],
                  trusteesHi: [
                    "श्री प्रभु सैनाणी",
                    "श्री रवीण चुगानी",
                    "श्री नारायण छलवाणी",
                    "श्री मनोज नैर्याणी"
                  ],
                  lang: lang,
                ),
                const SizedBox(height: 18),

                // 4. Milestones & Initiatives
                _buildMilestonesCard(
                  isDark: isDark,
                  cardBg: cardBg,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                  accentColor: accentColor,
                  lang: lang,
                ),
                const SizedBox(height: 18),

                // 5. Past Trustees of Darbar Sahib
                _buildPastTrusteesCard(
                  isDark: isDark,
                  cardBg: cardBg,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                  accentColor: accentColor,
                  lang: lang,
                ),
                const SizedBox(height: 18),

                // 6. Contact Information & Helpdesk
                _buildContactCard(
                  isDark: isDark,
                  cardBg: cardBg,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                  accentColor: accentColor,
                  lang: lang,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, Color textColor) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16.5,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
    );
  }

  Widget _buildHeaderVisionCard({
    required bool isDark,
    required Color cardBg,
    required Color primaryText,
    required Color secondaryText,
    required Color accentColor,
    required int lang,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accentColor.withValues(alpha: isDark ? 0.25 : 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.04),
            blurRadius: 10,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.groups_rounded, color: accentColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  lang == 0
                      ? "Heritage of Collective Leadership"
                      : "सामूहिक नेतृत्व की पावन परंपरा",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            lang == 0
                ? "Before departing from this world, Sain Vishindas Sahib established a trust comprising four noble individuals to ensure that the legacy of Seva with humility would continue uninterrupted. His vision was to create a transparent, team-based management structure that would not rely on any single person. This tradition of collective leadership continues to guide the Darbar to this day."
                : "इस लोक से महाप्रयाण करने से पूर्व, पूज्य सांईं विशिनदास साहिब ने चार निष्ठावान महानुभावों का एक ट्रस्ट गठित किया ताकि प्रेम व नम्रता से निष्काम सेवा की अखंड परंपरा अविराम चलती रहे। सांईंजन की पावन दृष्टि एक पारदर्शी और सामूहिक प्रबंधन व्यवस्था स्थापित करने की थी, जो किसी एक व्यक्ति पर निर्भर न रहे। सामूहिक नेतृत्व की यही परंपरा आज भी दरबार का मार्गदर्शन कर रही है।",
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 1.6,
              color: secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementCommitteeCard({
    required bool isDark,
    required Color cardBg,
    required Color primaryText,
    required Color secondaryText,
    required Color accentColor,
    required int lang,
  }) {
    final committeeMembers = [
      {
        'roleEn': 'Chairman',
        'roleHi': 'अध्यक्ष',
        'nameEn': 'Shri Shamsunder Sidhwani',
        'nameHi': 'श्री शमसुंदर सिधवाणी',
        'icon': Icons.account_balance_rounded,
      },
      {
        'roleEn': 'Secretary',
        'roleHi': 'सचिव',
        'nameEn': 'Shri Narain Chhalwani',
        'nameHi': 'श्री नारायण छलवाणी',
        'icon': Icons.assignment_ind_rounded,
      },
      {
        'roleEn': 'Treasurer',
        'roleHi': 'कोषाध्यक्ष',
        'nameEn': 'Shri Ashok Dudani',
        'nameHi': 'श्री अशोक दुदानी',
        'icon': Icons.account_balance_wallet_rounded,
      },
      {
        'roleEn': 'IT In-Charge',
        'roleHi': 'आईटी प्रभारी',
        'nameEn': 'Shri Raveen Chugani',
        'nameHi': 'श्री रवीण चुगानी',
        'icon': Icons.computer_rounded,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accentColor.withValues(alpha: isDark ? 0.3 : 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.04),
            blurRadius: 10,
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
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.admin_panel_settings_rounded, color: accentColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang == 0 ? "Management Committee" : "प्रबंधन समिति",
                      style: GoogleFonts.poppins(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: primaryText,
                      ),
                    ),
                    Text(
                      lang == 0 ? "Formed March 2025" : "गठन: मार्च २०२५",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            lang == 0
                ? "To streamline operations and uphold the values of humility and service, this dedicated committee handles executive and operational responsibilities under the motto of “Seva with a smile”."
                : "व्यवस्थाओं को सुगम बनाने तथा सेवा और नम्रता के मूल्यों को जीवंत रखने हेतु यह समिति 'मुस्कान के साथ सेवा' के पावन भाव से समस्त दायित्वों का निर्वहन करती है।",
            style: GoogleFonts.poppins(fontSize: 12.5, height: 1.55, color: secondaryText),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          ...committeeMembers.map((m) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: [
                  Icon(m['icon'] as IconData, size: 18, color: accentColor),
                  const SizedBox(width: 10),
                  Text(
                    "${lang == 0 ? m['roleEn'] : m['roleHi']}: ",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: primaryText,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      lang == 0 ? m['nameEn'] as String : m['nameHi'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTrustCard({
    required bool isDark,
    required Color cardBg,
    required Color primaryText,
    required Color secondaryText,
    required Color accentColor,
    required IconData icon,
    required String title,
    required String purpose,
    required List<String> trustees,
    required List<String> trusteesHi,
    required int lang,
  }) {
    final list = lang == 0 ? trustees : trusteesHi;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            purpose,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              height: 1.55,
              color: secondaryText,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            lang == 0 ? "Present Trustees:" : "वर्तमान ट्रस्टीगण:",
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: list.map((name) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_outline_rounded, size: 14, color: accentColor),
                    const SizedBox(width: 4),
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: primaryText,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestonesCard({
    required bool isDark,
    required Color cardBg,
    required Color primaryText,
    required Color secondaryText,
    required Color accentColor,
    required int lang,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.celebration_rounded, color: accentColor, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  lang == 0
                      ? "New Initiatives & Milestones"
                      : "नवीन प्रकल्प एवं पावन आयोजन",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            lang == 0
                ? "• Sain Vilayatrai’s 200th Birth Anniversary:"
                : "• सांईं विलायतराय साहिब की २००वीं जयंती महोत्सव:",
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            lang == 0
                ? "Celebrated with a historic Rath Yatra carrying the sacred original portrait of Sainjan (brought to India by Adi Chainibai) on a chariot from Darbar’s main gate, amidst rain and heartfelt devotion."
                : "दरबार के मुख्य द्वार से पूज्य सांईंजन के मूल पावन स्वरूप (जो आदी चैनी बाई द्वारा भारत लाया गया था) को रथ पर विराजमान कर भव्य रथ यात्रा निकाली गई, जिसमें संगत ने आनंदपूर्वक भाग लिया।",
            style: GoogleFonts.poppins(fontSize: 12.5, height: 1.55, color: secondaryText),
          ),
          const SizedBox(height: 12),
          Text(
            lang == 0
                ? "• Common Kitchen & Room Renovations:"
                : "• सामुदायिक रसोई एवं कक्ष नवीनीकरण योजना:",
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            lang == 0
                ? "A common kitchen equipped with amenities such as a gas stove and refrigerator has been instituted to prepare meals for infants, toddlers, and senior citizens. Comprehensive room repairs and renovations are also underway."
                : "नवजात शिशुओं, बच्चों एवं वरिष्ठ नागरिकों के भोजन हेतु गैस चूल्हा और रेफ्रिजरेटर युक्त सामुदायिक रसोई प्रारंभ की गई है। साथ ही समय के प्रभाव से जर्जर कक्षों के जीर्णोद्धार का कार्य प्रगति पर है।",
            style: GoogleFonts.poppins(fontSize: 12.5, height: 1.55, color: secondaryText),
          ),
        ],
      ),
    );
  }

  Widget _buildPastTrusteesCard({
    required bool isDark,
    required Color cardBg,
    required Color primaryText,
    required Color secondaryText,
    required Color accentColor,
    required int lang,
  }) {
    final pastTrustees = [
      {'nameEn': 'Shri Brahamanand Karamchand Sainani', 'nameHi': 'श्री ब्रह्मानंद करमचंद सैनाणी', 'tenure': '1942–1979'},
      {'nameEn': 'Shri Mohanlal Vishindas Hingorani', 'nameHi': 'श्री मोहनलाल विशिनदास हिंगोराणी', 'tenure': '1942–1946'},
      {'nameEn': 'Shri Naraindas Sadhusingh Vaswani', 'nameHi': 'श्री नारायणदास साधुसिंह वासवानी', 'tenure': '1942–1960'},
      {'nameEn': 'Shri Ramchand Roopchand Bhambhani', 'nameHi': 'श्री रामचंद रूपचंद भंभाणी', 'tenure': '1942–1971'},
      {'nameEn': 'Shri Totaram Sidhwani', 'nameHi': 'श्री तोताराम सिधवाणी', 'tenure': '1961–1981'},
      {'nameEn': 'Shri Ratan Sainani', 'nameHi': 'श्री रतन सैनाणी', 'tenure': '1971–1992'},
      {'nameEn': 'Shri Lal Mohanlal Vilayat', 'nameHi': 'श्री लाल मोहनलाल विलायत', 'tenure': '1972–2007'},
      {'nameEn': 'Dr. Madhavdas Sainani', 'nameHi': 'डॉ. माधवदास सैनाणी', 'tenure': '1980–1982'},
      {'nameEn': 'Shri Niranjan Hingorani', 'nameHi': 'श्री निरंजन हिंगोराणी', 'tenure': '1993–1995'},
      {'nameEn': 'Brig. Manu Bhambhani', 'nameHi': 'ब्रिगे. मनु भंभाणी', 'tenure': '1992–2021'},
      {'nameEn': 'Shri Anand Sidhwani', 'nameHi': 'श्री आनंद सिधवाणी', 'tenure': '1997–2008'},
      {'nameEn': 'Shri Hashu Vazirani', 'nameHi': 'श्री हाशू वज़ीराणी', 'tenure': '1997–2009'},
      {'nameEn': 'Shri Ishwar Chaudhary', 'nameHi': 'श्री ईश्वर चौधरी', 'tenure': '2018–2021'},
    ];

    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          leading: Icon(Icons.history_edu_rounded, color: accentColor),
          title: Text(
            lang == 0 ? "Past Trustees (1942–2021)" : "दरबार के पूर्व ट्रस्टीगण (१९४२–२०२१)",
            style: GoogleFonts.poppins(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          subtitle: Text(
            lang == 0 ? "Tap to view list of revered past trustees" : "सम्मानित पूर्व ट्रस्टियों की सूची देखने हेतु स्पर्श करें",
            style: GoogleFonts.poppins(fontSize: 11, color: secondaryText),
          ),
          children: [
            const Divider(height: 1),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pastTrustees.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04),
              ),
              itemBuilder: (context, index) {
                final item = pastTrustees[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          lang == 0 ? item['nameEn']! : item['nameHi']!,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: primaryText,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['tenure']!,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required bool isDark,
    required Color cardBg,
    required Color primaryText,
    required Color secondaryText,
    required Color accentColor,
    required int lang,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accentColor.withValues(alpha: isDark ? 0.3 : 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.support_agent_rounded, color: accentColor, size: 24),
              const SizedBox(width: 10),
              Text(
                lang == 0 ? "Helpdesk & Contact" : "संपर्क एवं मार्गदर्शन",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Shri Narain (Nari) Chhalwani
          _buildContactTile(
            title: lang == 0
                ? "Shri Narain (Nari) Chhalwani (Overall Responsibilities)"
                : "श्री नारायण (नारी) छलवाणी (समस्त व्यवस्थाएं)",
            phone: "+919892454043",
            displayPhone: "+91 98924 54043",
            email: "nari.chhalwani@gmail.com",
            primaryText: primaryText,
            secondaryText: secondaryText,
            accentColor: accentColor,
          ),
          const SizedBox(height: 12),

          // Shri Raveen Chugani
          _buildContactTile(
            title: lang == 0
                ? "Shri Raveen Chugani (Information Technology)"
                : "श्री रवीण चुगानी (सूचना प्रौद्योगिकी / IT)",
            phone: "+919820414597",
            displayPhone: "+91 98204 14597",
            email: "raveenchugani@gmail.com",
            primaryText: primaryText,
            secondaryText: secondaryText,
            accentColor: accentColor,
          ),
          const SizedBox(height: 12),

          // General Darbar Contact
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.email_outlined, color: accentColor, size: 20),
            ),
            title: Text(
              lang == 0 ? "Kambar Darbar Official Email" : "कांबर दरबार आधिकारिक ईमेल",
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: primaryText,
              ),
            ),
            subtitle: Text(
              "kambardarbar@gmail.com",
              style: GoogleFonts.poppins(fontSize: 12, color: secondaryText),
            ),
            onTap: () => _launchUrl("mailto:kambardarbar@gmail.com"),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile({
    required String title,
    required String phone,
    required String displayPhone,
    required String email,
    required Color primaryText,
    required Color secondaryText,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              InkWell(
                onTap: () => _launchUrl("https://wa.me/$phone"),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                  child: Row(
                    children: [
                      const Icon(FontAwesome.whatsapp, size: 16, color: Color(0xFF25D366)),
                      const SizedBox(width: 6),
                      Text(
                        displayPhone,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => _launchUrl("mailto:$email"),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                  child: Row(
                    children: [
                      Icon(Icons.mail_outline_rounded, size: 16, color: accentColor),
                      const SizedBox(width: 4),
                      Text(
                        "Email",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}