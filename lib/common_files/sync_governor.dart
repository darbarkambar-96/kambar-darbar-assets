import 'package:shared_preferences/shared_preferences.dart';

class SyncGovernor {
  static const int maxDailyRefreshes = 6;

  /// Checks if a Firebase network read is permitted under the daily 6-call cap.
  static Future<bool> canSyncWithBackend({bool isMandatoryDaily = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final String today = DateTime.now().toIso8601String().substring(0, 10); // YYYY-MM-DD
    final String lastDate = prefs.getString('governor_last_date') ?? '';

    int currentCount = prefs.getInt('governor_sync_count') ?? 0;

    // Reset counter at midnight
    if (today != lastDate) {
      currentCount = 0;
      await prefs.setString('governor_last_date', today);
      await prefs.setInt('governor_sync_count', 0);
    }

    // Block if user has exhausted their 6 daily cloud checks
    if (currentCount >= maxDailyRefreshes) {
      return false;
    }

    // Increment and allow
    await prefs.setInt('governor_sync_count', currentCount + 1);
    return true;
  }

  /// Checks whether today's single mandatory calendar fetch has occurred.
  static Future<bool> isDailyCalendarDue() async {
    final prefs = await SharedPreferences.getInstance();
    final String today = DateTime.now().toIso8601String().substring(0, 10);
    final String lastCalendarDate = prefs.getString('last_calendar_fetch_date') ?? '';
    return today != lastCalendarDate;
  }

  /// Marks today's mandatory calendar sync as completed.
  static Future<void> markDailyCalendarSynced() async {
    final prefs = await SharedPreferences.getInstance();
    final String today = DateTime.now().toIso8601String().substring(0, 10);
    await prefs.setString('last_calendar_fetch_date', today);
  }
}