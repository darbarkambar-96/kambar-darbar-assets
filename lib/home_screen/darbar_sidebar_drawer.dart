import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';

class DarbarSidebarDrawer extends StatelessWidget {
  final int currentLang;
  final bool isDarkMode;

  const DarbarSidebarDrawer({
    super.key,
    required this.currentLang,
    required this.isDarkMode,
  });

  Future<void> _launchUrlString(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color drawerBg = isDarkMode ? const Color(0xFF1E1E24) : Colors.white;
    final Color primaryText = isDarkMode ? Colors.white : const Color(0xFF2C221E);
    final Color secondaryText = isDarkMode ? Colors.white60 : const Color(0xFF7A6B63);
    const Color brandSaffron = Color(0xFFE65100);

    final double drawerWidth = MediaQuery.of(context).size.width * 0.86;

    return Drawer(
      width: drawerWidth,
      backgroundColor: drawerBg,
      elevation: 20,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset((1 - value) * -60, 0),
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [const Color(0xFF2C221E), const Color(0xFF1E1714)]
                      : [const Color(0xFFFFE0B2), const Color(0xFFFFF3E0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Image.asset('assets/img/vjvlogo.png', width: 52, height: 52),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Kambar Darbar',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: brandSaffron,
                    ),
                  ),
                  Text(
                    currentLang == 0
                        ? 'Service with Love & Humility'
                        : 'प्रेम और नम्रता से सेवा',
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildDrawerTile(
                    icon: Icons.info_outline_rounded,
                    title: currentLang == 0 ? "About Darbar" : "दरबार परिचय",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/about');
                    },
                    primaryText: primaryText,
                    accentColor: brandSaffron,
                  ),
                  _buildDrawerTile(
                    icon: Icons.history_edu_rounded,
                    title: currentLang == 0 ? "Sacred History" : "पावन इतिहास",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/history');
                    },
                    primaryText: primaryText,
                    accentColor: brandSaffron,
                  ),
                  _buildDrawerTile(
                    icon: Icons.contact_support_outlined,
                    title: currentLang == 0 ? "Contact & Directions" : "संपर्क व मार्ग",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/contact');
                    },
                    primaryText: primaryText,
                    accentColor: brandSaffron,
                  ),
                  _buildDrawerTile(
                    icon: Icons.language_rounded,
                    title: currentLang == 0 ? "Kambar Website" : "कंबर दरबार वेबसाइट",
                    onTap: () {
                      Navigator.pop(context);
                      _launchUrlString("https://www.kambardarbar.org");
                    },
                    primaryText: primaryText,
                    accentColor: brandSaffron,
                  ),
                  _buildDrawerTile(
                    icon: Icons.rate_review_outlined,
                    title: currentLang == 0
                        ? "Not Happy? Give feedback"
                        : "संतुष्ट नहीं हैं? सुझाव दें",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/feedback');
                    },
                    primaryText: primaryText,
                    accentColor: brandSaffron,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentLang == 0 ? "Connect With Us" : "सोशल मीडिया",
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: secondaryText,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSocialButton(
                        icon: FontAwesome.youtube_play,
                        color: const Color(0xFFFF0000),
                        label: "YouTube",
                        onTap: () => _launchUrlString("https://www.youtube.com/@KambarDarbar"),
                      ),
                      _buildSocialButton(
                        icon: FontAwesome.instagram,
                        color: const Color(0xFFE4405F),
                        label: "Instagram",
                        onTap: () => _launchUrlString("https://instagram.com/kambardarbar/"),
                      ),
                      _buildSocialButton(
                        icon: FontAwesome.facebook_square,
                        color: const Color(0xFF1877F2),
                        label: "Facebook",
                        onTap: () => _launchUrlString("https://facebook.com/KambarDarbar/"),
                      ),
                      _buildSocialButton(
                        icon: FontAwesome.whatsapp,
                        color: const Color(0xFF25D366),
                        label: "WhatsApp",
                        onTap: () => _launchUrlString("https://wa.me/919820000000"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color primaryText,
    required Color accentColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: accentColor, size: 21),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: primaryText,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded, size: 18, color: primaryText.withValues(alpha: 0.4)),
      onTap: onTap,
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 19),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}