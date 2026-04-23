import 'package:flutter/material.dart';

/// Lunar date model
class LunarDate {
  const LunarDate({
    required this.year,
    required this.month,
    required this.day,
    this.isLeapMonth = false,
    this.solarDate,
  });

  /// Lunar year (e.g., 2024)
  final int year;

  /// Lunar month (1-12)
  final int month;

  /// Lunar day (1-30)
  final int day;

  /// Is this a leap month (闰月)?
  final bool isLeapMonth;

  /// Corresponding solar date
  final DateTime? solarDate;

  /// Get heavenly stem for the year
  HeavenlyStem get yearStem {
    return HeavenlyStem.values[(year - 4) % 10];
  }

  /// Get earthly branch for the year
  EarthlyBranch get yearBranch {
    return EarthlyBranch.values[(year - 4) % 12];
  }

  /// Get zodiac animal for the year
  ZodiacAnimal get zodiac {
    return ZodiacAnimal.values[(year - 4) % 12];
  }

  /// Get Ganzhi (干支) for the year
  String get yearGanzhi {
    return '${yearStem.chineseCharacter}${yearBranch.chineseCharacter}';
  }

  /// Get lunar month name
  String get monthName {
    final monthNames = [
      '', '正月', '二月', '三月', '四月', '五月', '六月',
      '七月', '八月', '九月', '十月', '十一月', '十二月',
    ];
    final prefix = isLeapMonth ? '闰' : '';
    return '$prefix${monthNames[month]}';
  }

  /// Get lunar day name
  String get dayName {
    final dayNames = [
      '', '初一', '初二', '初三', '初四', '初五', '初六', '初七', '初八', '初九', '初十',
      '十一', '十二', '十三', '十四', '十五', '十六', '十七', '十八', '十九', '二十',
      '廿一', '廿二', '廿三', '廿四', '廿五', '廿六', '廿七', '廿八', '廿九', '三十',
    ];
    return dayNames[day];
  }

  /// Get full lunar date string
  String get fullString {
    return '${zodiac.chineseCharacter}年 $monthName $dayName';
  }

  @override
  String toString() {
    return 'LunarDate(year: $year, month: $month, day: $day, isLeapMonth: $isLeapMonth)';
  }
}

/// Heavenly Stems (天干)
enum HeavenlyStem {
  jia,    // 甲
  yi,     // 乙
  bing,   // 丙
  ding,   // 丁
  wu,     // 戊
  ji,     // 己
  geng,   // 庚
  xin,    // 辛
  ren,    // 壬
  gui,    // 癸
}

/// Earthly Branches (地支)
enum EarthlyBranch {
  zi,     // 子
  chou,   // 丑
  yin,    // 寅
  mao,    // 卯
  chen,   // 辰
  si,     // 巳
  wu,     // 午
  wei,    // 未
  shen,   // 申
  you,    // 酉
  xu,     // 戌
  hai,    // 亥
}

/// Zodiac animals associated with earthly branches
enum ZodiacAnimal {
  rat,     // 鼠 (子)
  ox,      // 牛 (丑)
  tiger,   // 虎 (寅)
  rabbit,  // 兔 (卯)
  dragon,  // 龙 (辰)
  snake,   // 蛇 (巳)
  horse,   // 马 (午)
  goat,    // 羊 (未)
  monkey,  // 猴 (申)
  rooster, // 鸡 (酉)
  dog,     // 狗 (戌)
  pig,     // 猪 (亥)
}

/// Extensions for heavenly stems
extension HeavenlyStemExtension on HeavenlyStem {
  String get chineseCharacter {
    const characters = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
    return characters[index];
  }

  String get element {
    const elements = ['木', '木', '火', '火', '土', '土', '金', '金', '水', '水'];
    return elements[index];
  }
}

/// Extensions for earthly branches
extension EarthlyBranchExtension on EarthlyBranch {
  String get chineseCharacter {
    const characters = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];
    return characters[index];
  }

  ZodiacAnimal get zodiac {
    return ZodiacAnimal.values[index];
  }
}

/// Extensions for zodiac animals
extension ZodiacAnimalExtension on ZodiacAnimal {
  String get chineseCharacter {
    const characters = ['鼠', '牛', '虎', '兔', '龙', '蛇', '马', '羊', '猴', '鸡', '狗', '猪'];
    return characters[index];
  }

  String get emoji {
    const emojis = ['🐭', '🐮', '🐯', '🐰', '🐲', '🐍', '🐴', '🐑', '🐵', '🐔', '🐕', '🐖'];
    return emojis[index];
  }
}

/// Ganzhi (干支) calculation result
class Ganzhi {
  const Ganzhi({
    required this.year,
    required this.month,
    required this.day,
  });

  final String year;
  final String month;
  final String day;

  @override
  String toString() {
    return 'Ganzhi(year: $year, month: $month, day: $day)';
  }
}
