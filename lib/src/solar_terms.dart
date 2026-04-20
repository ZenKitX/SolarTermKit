import 'package:flutter/material.dart';
import 'models/solar_term_model.dart';
import 'services/season_service.dart';

/// Solar terms calculation service
///
/// Provides accurate calculation of 24 solar terms using astronomical algorithms.
class SolarTerms {
  // Base dates for each solar term (year 2000)
  // Format: [month, day + decimal hours]
  static const List<List<double>> _baseDates = [
    [2, 4.79],   // 0: 立春
    [2, 19.43],  // 1: 雨水
    [3, 6.44],   // 2: 惊蛰
    [3, 21.15],  // 3: 春分
    [4, 5.59],   // 4: 清明
    [4, 21.03],  // 5: 谷雨
    [5, 6.38],   // 6: 立夏
    [5, 21.76],  // 7: 小满
    [6, 6.44],   // 8: 芒种
    [6, 21.65],  // 9: 夏至
    [7, 7.70],   // 10: 小暑
    [7, 23.35],  // 11: 大暑
    [8, 8.23],   // 12: 立秋
    [8, 23.79],  // 13: 处暑
    [9, 8.46],   // 14: 白露
    [9, 23.64],  // 15: 秋分
    [10, 9.00],  // 16: 寒露
    [10, 24.00], // 17: 霜降
    [11, 8.32],  // 18: 立冬
    [11, 23.15], // 19: 小雪
    [12, 7.88],  // 20: 大雪
    [12, 22.29], // 21: 冬至
    [1, 6.30],   // 22: 小寒
    [1, 20.89],  // 23: 大寒
  ];

  // Solar term names
  static const List<String> _names = [
    '立春', '雨水', '惊蛰', '春分', '清明', '谷雨',
    '立夏', '小满', '芒种', '夏至', '小暑', '大暑',
    '立秋', '处暑', '白露', '秋分', '寒露', '霜降',
    '立冬', '小雪', '大雪', '冬至', '小寒', '大寒',
  ];

  // Solar term descriptions
  static const List<String> _descriptions = [
    '立春，二十四节气之首，春季开始',
    '雨水，降雨开始，雨量渐增',
    '惊蛰，春雷乍动，惊醒蛰伏昆虫',
    '春分，昼夜平分，春色正中分',
    '清明，气清景明，万物皆显',
    '谷雨，雨生百谷，播种移苗',
    '立夏，夏季开始，万物繁茂',
    '小满，麦类等夏熟作物籽粒开始饱满',
    '芒种，麦类等有芒作物成熟',
    '夏至，太阳直射北回归线，白昼最长',
    '小暑，气候开始炎热',
    '大暑，一年中最热的时期',
    '立秋，秋季开始，暑去凉来',
    '处暑，炎热暑天结束',
    '白露，天气转凉，露水凝结',
    '秋分，昼夜平分，秋色正中分',
    '寒露，露水已寒，将要结冰',
    '霜降，天气渐冷，开始有霜',
    '立冬，冬季开始，万物收藏',
    '小雪，开始下雪，雪量不大',
    '大雪，雪量增大，地面积雪',
    '冬至，太阳直射南回归线，白昼最短',
    '小寒，气候开始寒冷',
    '大寒，一年中最冷的时期',
  ];

  // Season for each solar term
  static const List<Season> _seasons = [
    Season.spring, Season.spring, Season.spring, Season.spring, Season.spring, Season.spring,
    Season.summer, Season.summer, Season.summer, Season.summer, Season.summer, Season.summer,
    Season.autumn, Season.autumn, Season.autumn, Season.autumn, Season.autumn, Season.autumn,
    Season.winter, Season.winter, Season.winter, Season.winter, Season.winter, Season.winter,
  ];

  // Colors for each solar term
  static const List<Color> _colors = [
    Color(0xFF81C784), // Green 300
    Color(0xFFA5D6A7), // Green 300
    Color(0xFF66BB6A), // Green 400
    Color(0xFF4CAF50), // Green 500
    Color(0xFF43A047), // Green 600
    Color(0xFF388E3C), // Green 700
    Color(0xFFE57373), // Red 300
    Color(0xFFEF5350), // Red 400
    Color(0xFFF44336), // Red 500
    Color(0xFFE53935), // Red 600
    Color(0xFFD32F2F), // Red 700
    Color(0xFFC62828), // Red 800
    Color(0xFFFFB74D), // Orange 300
    Color(0xFFFFA726), // Orange 400
    Color(0xFFFF9800), // Orange 500
    Color(0xFFFF8A65), // Orange 500
    Color(0xFFF57C00), // Orange 700
    Color(0xFFEF6C00), // Orange 800
    Color(0xFF64B5F6), // Blue 300
    Color(0xFF42A5F5), // Blue 400
    Color(0xFF2196F3), // Blue 500
    Color(0xFF1E88E5), // Blue 600
    Color(0xFF1976D2), // Blue 700
    Color(0xFF1565C0), // Blue 800
  ];

  /// Get all solar terms
  static List<SolarTerm> get all {
    final now = DateTime.now();
    return List.generate(24, (index) {
      final time = getSolarTermTime(now.year, index);
      return SolarTerm(
        name: _names[index],
        description: _descriptions[index],
        date: time,
        season: _seasons[index],
        color: _colors[index],
      );
    });
  }

  /// Calculate solar term time for a specific year and index
  ///
  /// [year] - The year
  /// [solarTermIndex] - Index of solar term (0-23)
  /// Returns: DateTime of the solar term
  static DateTime getSolarTermTime(int year, int solarTermIndex) {
    if (solarTermIndex < 0 || solarTermIndex >= 24) {
      throw ArgumentError('Solar term index must be between 0 and 23');
    }

    final baseDate = _baseDates[solarTermIndex];
    final baseMonth = baseDate[0];
    final baseDay = baseDate[1];

    // Calculate year offset (approximately 0.2422 days per year)
    final yearOffset = (year - 2000) * 0.2422;

    // Adjust for leap years
    final leapYearOffset = _isLeapYear(year) ? -1 : 0;

    final totalDay = baseDay + yearOffset + leapYearOffset;
    final intDay = totalDay.floor();
    final decimalDay = totalDay - intDay;

    final hour = (decimalDay * 24).floor();
    final minute = ((decimalDay * 24) % 1 * 60).floor();

    // Handle year boundary for 小寒 and 大寒
    final targetYear = solarTermIndex >= 22 ? year + 1 : year;

    return DateTime(
      targetYear,
      baseMonth.toInt(),
      intDay,
      hour,
      minute,
    );
  }

  /// Get current solar term
  static SolarTerm getCurrentSolarTerm() {
    final now = DateTime.now();
    return getSolarTermForDate(now);
  }

  /// Get solar term for a specific date
  static SolarTerm getSolarTermForDate(DateTime date) {
    final year = date.year;

    // Find the closest solar term
    int minDiff = double.maxFinite.toInt();
    int closestIndex = 0;

    for (int i = 0; i < 24; i++) {
      final solarTermTime = getSolarTermTime(year, i);
      final diff = date.difference(solarTermTime).abs().inDays;

      if (diff < minDiff) {
        minDiff = diff;
        closestIndex = i;
      }
    }

    final time = getSolarTermTime(year, closestIndex);
    return SolarTerm(
      name: _names[closestIndex],
      description: _descriptions[closestIndex],
      date: time,
      season: _seasons[closestIndex],
      color: _colors[closestIndex],
    );
  }

  /// Get current season
  static Season getCurrentSeason() {
    return SeasonService.getCurrentSeason();
  }

  /// Get season for a specific date
  static Season getSeasonForDate(DateTime date) {
    return SeasonService.getSeasonForDate(date);
  }

  /// Get solar term by name
  static SolarTerm? getSolarTermByName(String name) {
    final index = _names.indexOf(name);
    if (index == -1) return null;
    
    final now = DateTime.now();
    final time = getSolarTermTime(now.year, index);
    return SolarTerm(
      name: _names[index],
      description: _descriptions[index],
      date: time,
      season: _seasons[index],
      color: _colors[index],
    );
  }

  /// Check if today is a solar term day
  static bool isSolarTermDay() {
    final now = DateTime.now();
    final solarTerm = getSolarTermForDate(now);
    return now.year == solarTerm.date!.year &&
           now.month == solarTerm.date!.month &&
           now.day == solarTerm.date!.day;
  }

  /// Get all solar term names
  static List<String> getAllSolarTerms() {
    return List.from(_names);
  }

  /// Get solar term by index
  static SolarTerm getSolarTermByIndex(int index) {
    if (index >= 0 && index < 24) {
      final now = DateTime.now();
      final time = getSolarTermTime(now.year, index);
      return SolarTerm(
        name: _names[index],
        description: _descriptions[index],
        date: time,
        season: _seasons[index],
        color: _colors[index],
      );
    }
    throw ArgumentError('Index must be between 0 and 23');
  }

  /// Check if a year is a leap year
  static bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  /// Get days until next solar term
  static int getDaysUntilNextSolarTerm() {
    final now = DateTime.now();
    final year = now.year;

    // Find the next solar term
    for (int i = 0; i < 24; i++) {
      final solarTermTime = getSolarTermTime(year, i);
      if (solarTermTime.isAfter(now)) {
        return solarTermTime.difference(now).inDays;
      }
    }

    // If no solar term found this year, get first of next year
    final firstNextYear = getSolarTermTime(year + 1, 0);
    return firstNextYear.difference(now).inDays;
  }
}
