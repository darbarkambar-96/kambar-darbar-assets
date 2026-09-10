import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  static const String _mapAddressQuery =
      "Kambar Darbar, Shantilal Modi Road, Kandivali West, Mumbai, Maharashtra 400067";

  Future<void> _openGoogleMaps() async {
    final String encodedQuery = Uri.encodeComponent(_mapAddressQuery);
    final Uri googleMapsUri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$encodedQuery",
    );

    try {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not launch maps: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.deepOrange,
          ),
        );
      }
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not initiate call: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.deepOrange,
          ),
        );
      }
    }
  }

  Future<void> _sendEmail(String emailAddress) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      queryParameters: {'subject': 'Enquiry - Kambar Darbar Devotee'},
    );
    try {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not launch email app: $e',
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
        final Color subHeadingText = isDark ? Colors.white54 : Colors.grey.shade600;
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
              lang == 0 ? 'Contact Darbar' : 'संपर्क सूत्र एवं पता',
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
              // Interactive Map Preview Card
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.black.withOpacity(0.04),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black45 : Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _openGoogleMaps,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Image.asset(
                                'assets/img/map.png',
                                height: 165,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                margin: const EdgeInsets.all(12),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.directions_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      lang == 0 ? "Get Directions" : "दिशा-निर्देश",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.location_on_rounded,
                                        color: accentColor, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        lang == 0
                                            ? "Kambar Darbar Mandir"
                                            : "कांबर दरबार मंदिर",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: primaryText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  lang == 0
                                      ? "Near Mayur Cinema, Shantilal Modi Road, Opp. Bhurabhai Arogya Bhuvan, Kandivali (West), Mumbai - 400067, Maharashtra, India."
                                      : "मयूर सिनेमा के पास, शांतिलाल मोदी रोड, भूराभाई आरोग्य भवन के सामने, कांदिवली (पश्चिम), मुंबई - 400067, महाराष्ट्र, भारत।",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    height: 1.5,
                                    color: secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Darshan & Visiting Timings Card
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
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
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.access_time_rounded,
                          color: accentColor, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang == 0 ? "Visiting & Darshan Hours" : "दर्शन एवं भेंट का समय",
                            style: GoogleFonts.poppins(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: primaryText,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            lang == 0
                                ? "Morning: 10:00 AM – 02:00 PM\nEvening: 06:00 PM – 08:00 PM"
                                : "प्रातःकाल: 10:00 बजे से 02:00 बजे तक\nसायंकाल: 06:00 बजे से 08:00 बजे तक",
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              height: 1.45,
                              fontWeight: FontWeight.w500,
                              color: secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Telephone & Helpline Numbers Card
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang == 0 ? "Helpline & Contact Directory" : "दूरभाष एवं संपर्क निर्देशिका",
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(height: 1, color: dividerColor),
                      const SizedBox(height: 6),

                      // Darbar Office
                      _buildContactRow(
                        icon: Icons.phone_in_talk_rounded,
                        accentColor: accentColor,
                        primaryText: primaryText,
                        subHeadingText: subHeadingText,
                        title: lang == 0 ? "Darbar Main Office" : "दरबार मुख्य कार्यालय",
                        value: "+91 8976081672",
                        onTap: () => _makePhoneCall("+918976081672"),
                      ),
                      Divider(height: 1, color: dividerColor),

                      // General Clinic
                      _buildContactRow(
                        icon: Icons.local_hospital_rounded,
                        accentColor: accentColor,
                        primaryText: primaryText,
                        subHeadingText: subHeadingText,
                        title: lang == 0 ? "General Medical Clinic" : "सामान्य चिकित्सा औषधालय",
                        value: "+91 9029911644",
                        onTap: () => _makePhoneCall("+919029911644"),
                      ),
                      Divider(height: 1, color: dividerColor),

                      // Dental Clinic
                      _buildContactRow(
                        icon: Icons.medical_services_rounded,
                        accentColor: accentColor,
                        primaryText: primaryText,
                        subHeadingText: subHeadingText,
                        title: lang == 0 ? "Charitable Dental Clinic" : "दंत चिकित्सा क्लिनिक",
                        value: "+91 7400072847",
                        onTap: () => _makePhoneCall("+917400072847"),
                      ),
                    ],
                  ),
                ),
              ),

              // Email & Web Enquiries Card
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang == 0 ? "Online Enquiries & Email" : "ऑनलाइन पूछताछ एवं ईमेल",
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(height: 1, color: dividerColor),
                      const SizedBox(height: 6),

                      _buildContactRow(
                        icon: Icons.email_rounded,
                        accentColor: accentColor,
                        primaryText: primaryText,
                        subHeadingText: subHeadingText,
                        title: lang == 0 ? "Trust Secretariat" : "ट्रस्ट आधिकारिक ईमेल",
                        value: "info@kambardarbar.org",
                        onTap: () => _sendEmail("info@kambardarbar.org"),
                      ),
                      Divider(height: 1, color: dividerColor),

                      _buildContactRow(
                        icon: Icons.mail_outline_rounded,
                        accentColor: accentColor,
                        primaryText: primaryText,
                        subHeadingText: subHeadingText,
                        title: lang == 0 ? "Resident Trustee" : "रेजिडेंट ट्रस्टी ईमेल",
                        value: "p_sainani@rediffmail.com",
                        onTap: () => _sendEmail("p_sainani@rediffmail.com"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required Color accentColor,
    required Color primaryText,
    required Color subHeadingText,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: subHeadingText,
                    ),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: primaryText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 13, color: subHeadingText),
          ],
        ),
      ),
    );
  }
}