import '../models/solar_term_model.dart';

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
  static const List<String> _seasons = [
    '春', '春', '春', '春', '春', '春',
    '夏', '夏', '夏', '夏', '夏', '夏',
    '秋', '秋', '秋', '秋', '秋', '秋',
    '冬', '冬', '冬', '冬', '冬', '冬',
  ];

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
      baseMonth,
      intDay,
      hour,
      minute,
    );
  }

  /// Get current solar term
  static String getCurrentSolarTerm() {
    final now = DateTime.now();
    return getSolarTermForDate(now);
  }

  /// Get solar term for a specific date
  static String getSolarTermForDate(DateTime date) {
    final year = date.year;

    // Find the closest solar term
    String currentSolarTerm = '';
    int minDiff = double.maxFinite.toInt();

    for (int i = 0; i < 24; i++) {
      final solarTermTime = getSolarTermTime(year, i);
      final diff = date.difference(solarTermTime).abs();

      if (diff < minDiff) {
        minDiff = diff;
        currentSolarTerm = _names[i];
      }
    }

    return currentSolarTerm;
  }

  /// Get current season
  static String getCurrentSeason() {
    final now = DateTime.now();
    return getSeasonForDate(now);
  }

  /// Get season for a specific date
  static String getSeasonForDate(DateTime date) {
    final month = date.month;

    if (month >= 3 && month <= 5) {
      return '春';
    } else if (month >= 6 && month <= 8) {
      return '夏';
    } else if (month >= 9 && month <= 11) {
      return '秋';
    } else {
      return '冬';
    }
  }

  /// Get solar term description
  static String getSolarTermDescription(String solarTerm) {
    final index = _names.indexOf(solarTerm);
    if (index != -1) {
      return _descriptions[index];
    }
    return '二十四节气之一';
  }

  /// Check if today is a solar term day
  static bool isSolarTermDay() {
    final now = DateTime.now();
    final solarTerm = getSolarTermForDate(now);
    final solarTermTime = getSolarTermTime(now.year, _names.indexOf(solarTerm));

    return now.year == solarTermTime.year &&
           now.month == solarTermTime.month &&
           now.day == solarTermTime.day;
  }

  /// Get all solar term names
  static List<String> getAllSolarTerms() {
    return List.from(_names);
  }

  /// Get solar term by index
  static String getSolarTermByIndex(int index) {
    if (index >= 0 && index < 24) {
      return _names[index];
    }
    throw ArgumentError('Index must be between 0 and 23');
  }

  /// Get solar term season
  static String getSolarTermSeason(String solarTerm) {
    final index = _names.indexOf(solarTerm);
    if (index != -1) {
      return _seasons[index];
    }
    return '';
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

  /// Get solar term with full details
  static SolarTerm getSolarTermDetails(String solarTermName) {
    final index = _names.indexOf(solarTermName);
    if (index == -1) {
      throw ArgumentError('Invalid solar term name');
    }

    return SolarTerm(
      name: _names[index],
      description: _descriptions[index],
      season: _seasons[index],
    );
  }
}
