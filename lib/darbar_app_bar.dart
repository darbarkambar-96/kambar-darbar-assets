import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';

class DarbarAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleEn;
  final String titleHi;
  final List<Widget>? extraActions;
  final bool showBack;

  const DarbarAppBar({
    super.key,
    required this.titleEn,
    required this.titleHi,
    this.extraActions,
    this.showBack = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([themeNotifier, languageNotifier]),
      builder: (context, _) {
        final bool isDarkMode = themeNotifier.value == ThemeMode.dark;
        final int lang = languageNotifier.value;
        const Color brandSaffron = Color(0xFFE65100);
        final Color bg = isDarkMode ? const Color(0xFF1E1E24) : Colors.white;

        return AppBar(
          backgroundColor: bg,
          elevation: 0.5,
          centerTitle: false,
          leading: showBack && Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: brandSaffron, size: 20),
                  onPressed: () => Navigator.pop(context),
                )
              : null,
          title: Text(
            lang == 0 ? titleEn : titleHi,
            style: GoogleFonts.poppins(
              fontSize: 16.5,
              fontWeight: FontWeight.w700,
              color: brandSaffron,
            ),
          ),
          actions: [
            if (extraActions != null) ...extraActions!,
            IconButton(
              tooltip: isDarkMode ? "Light Mode" : "Dark Mode",
              icon: Icon(
                isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                color: isDarkMode ? Colors.amber : const Color(0xFFD84315),
                size: 20,
              ),
              onPressed: toggleAppTheme,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: brandSaffron.withValues(alpha: 0.12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: toggleAppLanguage,
                icon: const Icon(Icons.translate_rounded,
                    size: 13, color: brandSaffron),
                label: Text(
                  lang == 0 ? 'हिंदी' : 'English',
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: brandSaffron,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}