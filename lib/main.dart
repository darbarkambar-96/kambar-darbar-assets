import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_vlc_player_16kb/flutter_vlc_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:refresh_rate/refresh_rate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:darbar_app_of_kambar_darbar/global_audio_manager.dart';
import 'package:darbar_app_of_kambar_darbar/darbar_events/events_screen.dart';
import 'package:darbar_app_of_kambar_darbar/live_darshan/live_stream_screen.dart';
import 'package:darbar_app_of_kambar_darbar/live_darshan/live_stream_categories.dart';
import 'package:darbar_app_of_kambar_darbar/quiz_links.dart';
import 'package:darbar_app_of_kambar_darbar/home_screen/homepage.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
import 'package:darbar_app_of_kambar_darbar/aboutus/about_screen.dart';
import 'package:darbar_app_of_kambar_darbar/programs/programs_screen.dart';
import 'package:darbar_app_of_kambar_darbar/programs/youtube_screen.dart';
import 'package:darbar_app_of_kambar_darbar/contact_us/contact_screen.dart';
import 'package:darbar_app_of_kambar_darbar/medical/medical_screen.dart';
import 'package:darbar_app_of_kambar_darbar/photo_gallery/photo_gallery_screen.dart';
import 'package:darbar_app_of_kambar_darbar/ImageDetail.dart';
import 'package:darbar_app_of_kambar_darbar/scholarships/scholarship_screen.dart';
import 'package:darbar_app_of_kambar_darbar/testnew.dart';
import 'package:darbar_app_of_kambar_darbar/splash_screen.dart';
import 'package:darbar_app_of_kambar_darbar/history/history_screen.dart';
import 'package:darbar_app_of_kambar_darbar/trustees/trustees_screen.dart';
import 'package:darbar_app_of_kambar_darbar/bhajans/bhajans_screen.dart';
import 'package:darbar_app_of_kambar_darbar/publications/publications_screen.dart';
import 'package:darbar_app_of_kambar_darbar/feedback/feedback_screen.dart';
import 'package:darbar_app_of_kambar_darbar/home_screen/darbar_news_screen.dart';

import 'home_screen/image_one/Sai1.dart';
import 'home_screen/image_three/Sai3.dart';
import 'home_screen/image_two/Sai2.dart';
import 'medical/MedicalDetails.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
final ValueNotifier<int> languageNotifier = ValueNotifier(0);
final ValueNotifier<bool> isFullScreenNotifier = ValueNotifier<bool>(false);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel eventNotificationChannel = AndroidNotificationChannel(
  'darbar_events_channel',
  'Darbar Events',
  description: 'Notifications for new Kambar Darbar events and calendar dates.',
  importance: Importance.max,
  playSound: true,
  enableVibration: true,
);

Future<void> showDarbarEventNotification({
  required String title,
  required String body,
}) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'darbar_events_channel',
    'Darbar Events',
    channelDescription: 'Notifications for new Kambar Darbar events and calendar dates.',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    icon: '@mipmap/ic_launcher',
  );

  const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title,
    body,
    platformDetails,
  );
}

Future<void> toggleAppTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final bool isDark = themeNotifier.value == ThemeMode.dark;
  final bool newIsDark = !isDark;
  themeNotifier.value = newIsDark ? ThemeMode.dark : ThemeMode.light;
  await prefs.setBool('is_dark_mode', newIsDark);
}

Future<void> toggleAppLanguage() async {
  final prefs = await SharedPreferences.getInstance();
  final int nextLang = languageNotifier.value == 0 ? 1 : 0;
  languageNotifier.value = nextLang;
  await prefs.setInt('counter', nextLang);
  await prefs.setInt('language', nextLang);
  await prefs.setInt('language_code', nextLang);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RefreshRate.enable();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase init warning: $e");
  }

  const AndroidInitializationSettings initSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings =
  InitializationSettings(android: initSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  final androidPlugin = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  if (androidPlugin != null) {
    await androidPlugin.createNotificationChannel(eventNotificationChannel);
    await androidPlugin.requestNotificationsPermission();
  }

  GlobalAudioManager.instance.init();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isDark = prefs.getBool('is_dark_mode') ?? false;
  final int savedLang = prefs.getInt('language') ?? prefs.getInt('counter') ?? 0;

  themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  languageNotifier.value = savedLang;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          navigatorKey: appNavigatorKey,
          title: 'Kambar Darbar',
          themeMode: currentMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFFE65100),
            scaffoldBackgroundColor: const Color.fromRGBO(235, 236, 222, 1),
            cardColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFFE65100),
              elevation: 0.5,
              centerTitle: true,
              iconTheme: IconThemeData(color: Color(0xFFE65100)),
            ),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.deepOrange,
              brightness: Brightness.light,
            ).copyWith(
              secondary: const Color(0xFFE65100),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFFFF9E80),
            scaffoldBackgroundColor: const Color(0xFF131315),
            cardColor: const Color(0xFF1E1E24),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E24),
              foregroundColor: Color(0xFFFF9E80),
              elevation: 0.5,
              centerTitle: true,
              iconTheme: IconThemeData(color: Color(0xFFFF9E80)),
            ),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.deepOrange,
              brightness: Brightness.dark,
            ).copyWith(
              surface: const Color(0xFF1E1E24),
              secondary: const Color(0xFFFF9E80),
            ),
          ),
          initialRoute: '/',
          builder: (context, child) {
            return Stack(
              children: [
                if (child != null) child,
                const GlobalAudioOverlay(),
                ValueListenableBuilder<bool>(
                  valueListenable: isFullScreenNotifier,
                  builder: (context, isFullScreen, _) {
                    if (isFullScreen) return const SizedBox.shrink();
                    return const GlobalFloatingNavToggle();
                  },
                ),
              ],
            );
          },
          routes: {
            '/': (context) => const HomePage(),
            '/home': (context) => const HomePage(),
            '/splash': (context) => const SplashScreen(),
            '/livestream': (context) => const LiveStreamCategories(),
            '/livevideo': (context) => const LiveStreamScreen(),
            '/quiz': (context) => const QuizLinks(),
            '/events': (context) => const EventsScreen(),
            '/about': (context) => const AboutScreen(),
            '/history': (context) => const HistoryScreen(),
            '/programs': (context) => const ProgramsScreen(),
            '/youtube': (context) => const YoutubeScreen(),
            '/contact': (context) => const ContactScreen(),
            '/medical': (context) => const MedicalScreen(),
            '/photogallery': (context) => const PhotoGalleryScreen(),
            '/imagedetail': (context) => const ImageDetailScreen(),
            '/scholarship': (context) => const ScholarshipScreen(),
            '/medicaldetails': (context) => const MedicalDetailsScreen(),
            '/testnew': (context) => const TestNewScreen(),
            '/sai1': (context) => const Sai1(),
            '/sai2': (context) => const Sai2(),
            '/sai3': (context) => const Sai3(),
            '/tour': (context) => const HomePage(),
            '/trustees': (context) => const TrusteesScreen(),
            '/bhajans': (context) => const BhajansScreen(),
            '/publications': (context) => const PublicationsScreen(),
            '/feedback': (context) => const FeedbackScreen(),
            '/news': (context) => const DarbarNewsScreen(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class GlobalFloatingNavToggle extends StatelessWidget {
  const GlobalFloatingNavToggle({super.key});

  @override
  Widget build(BuildContext context) {
    const Color brandSaffron = Color(0xFFE65100);

    return AnimatedBuilder(
      animation: Listenable.merge([themeNotifier, languageNotifier]),
      builder: (context, _) {
        final bool isDarkMode = themeNotifier.value == ThemeMode.dark;
        final int lang = languageNotifier.value;

        return Positioned(
          right: 14,
          bottom: 14,
          child: SafeArea(
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(22),
              color: isDarkMode ? const Color(0xFF24201D) : Colors.white,
              shadowColor: Colors.black.withValues(alpha: 0.3),
              child: Container(
                width: 44,
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: brandSaffron.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: toggleAppTheme,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                          color: isDarkMode ? Colors.amber : const Color(0xFFD84315),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 22,
                      height: 1,
                      color: isDarkMode ? Colors.white24 : Colors.grey.shade300,
                    ),
                    const SizedBox(height: 4),
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: toggleAppLanguage,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: brandSaffron.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.translate_rounded, size: 13, color: brandSaffron),
                            const SizedBox(height: 2),
                            Text(
                              lang == 0 ? 'हिंदी' : 'EN',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: brandSaffron,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}