import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darbar_app_of_kambar_darbar/main.dart';

class DarbarNavActions extends StatelessWidget {
  const DarbarNavActions({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([themeNotifier, languageNotifier]),
      builder: (context, _) {
        final bool isDark = themeNotifier.value == ThemeMode.dark;
        final int lang = languageNotifier.value;
        const Color brandSaffron = Color(0xFFE65100);

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: isDark ? "Light Mode" : "Dark Mode",
              icon: Icon(
                isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                color: isDark ? Colors.amber : const Color(0xFFD84315),
                size: 20,
              ),
              onPressed: toggleAppTheme,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: brandSaffron.withValues(alpha: 0.12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: toggleAppLanguage,
                icon: const Icon(Icons.translate_rounded, size: 13, color: brandSaffron),
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