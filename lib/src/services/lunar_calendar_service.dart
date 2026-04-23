import '../models/lunar_date.dart';
import '../models/solar_term_model.dart';
import 'solar_term_calculator.dart';

/// Traditional Chinese festival
enum TraditionalFestival {
  springFestival,      // 春节 (正月初一)
  lanternFestival,     // 元宵节 (正月十五)
  dragonBoatFestival,  // 端午节 (五月初五)
  midAutumnFestival,   // 中秋节 (八月十五)
  doubleNinthFestival, // 重阳节 (九月九日)
  labaFestival,        // 腊八节 (腊月初八)
  winterSolstice,      // 冬至
}

/// Traditional festival info
class FestivalInfo {
  const FestivalInfo({
    required this.festival,
    required this.name,
    required this.lunarMonth,
    required this.lunarDay,
    this.description,
  });

  final TraditionalFestival festival;
  final String name;
  final int lunarMonth;
  final int lunarDay;
  final String? description;

  @override
  String toString() => 'FestivalInfo($name)';
}

/// Lunar calendar service
class LunarCalendarService {
  LunarCalendarService._();

  /// Get singleton instance
  static final instance = LunarCalendarService._();

  /// Convert solar date to lunar date (simplified algorithm)
  ///
  /// Note: This is a simplified approximation. For accurate conversion,
  /// you should use a comprehensive lunar calendar library.
  ///
  /// [solarDate] - Solar date to convert
  /// Returns lunar date information
  LunarDate getLunarDate(DateTime solarDate) {
    // Simplified conversion: estimate based on solar term
    // This is NOT accurate and should be replaced with proper algorithm

    // Get current solar term
    final calculator = AstronomicalCalculator.chinaTime();
    final currentTerm = calculator.getCurrentSolarTerm(solarDate);

    // Estimate lunar month based on solar term
    int lunarYear = solarDate.year;
    int lunarMonth = 1;
    int lunarDay = solarDate.day;

    // Rough approximation based on solar term
    switch (currentTerm.index) {
      case 0: case 1: lunarMonth = 1; break;
      case 2: case 3: lunarMonth = 2; break;
      case 4: case 5: lunarMonth = 3; break;
      case 6: case 7: lunarMonth = 4; break;
      case 8: case 9: lunarMonth = 5; break;
      case 10: case 11: lunarMonth = 6; break;
      case 12: case 13: lunarMonth = 7; break;
      case 14: case 15: lunarMonth = 8; break;
      case 16: case 17: lunarMonth = 9; break;
      case 18: case 19: lunarMonth = 10; break;
      case 20: case 21: lunarMonth = 11; break;
      case 22: case 23: lunarMonth = 12; break;
    }

    return LunarDate(
      year: lunarYear,
      month: lunarMonth,
      day: lunarDay,
      isLeapMonth: false,
      solarDate: solarDate,
    );
  }

  /// Calculate Ganzhi (干支) for a given date
  ///
  /// [solarDate] - Solar date
  /// Returns Ganzhi (year, month, day)
  Ganzhi calculateGanzhi(DateTime solarDate) {
    // Year Ganzhi
    final yearStem = (solarDate.year - 4) % 10;
    final yearBranch = (solarDate.year - 4) % 12;

    // Month Ganzhi (based on year stem and solar term)
    final lunarDate = getLunarDate(solarDate);
    final monthStem = (yearStem * 2 + lunarDate.month) % 10;
    final monthBranch = (lunarDate.month + 2) % 12;

    // Day Ganzhi (based on fixed reference date)
    final daysSince1900 = solarDate.difference(DateTime(1900, 1, 1)).inDays;
    final dayStem = (daysSince1900 + 10) % 10;
    final dayBranch = (daysSince1900 + 5) % 12;

    final stems = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
    final branches = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

    return Ganzhi(
      year: '${stems[yearStem]}${branches[yearBranch]}',
      month: '${stems[monthStem]}${branches[monthBranch]}',
      day: '${stems[dayStem]}${branches[dayBranch]}',
    );
  }

  /// Get traditional festival for a given date
  ///
  /// [solarDate] - Solar date
  /// Returns festival info if the date is a traditional festival, null otherwise
  FestivalInfo? getFestival(DateTime solarDate) {
    final lunarDate = getLunarDate(solarDate);

    for (final festival in _festivals) {
      if (lunarDate.month == festival.lunarMonth &&
          lunarDate.day == festival.lunarDay) {
        return festival;
      }
    }

    return null;
  }

  /// Check if a date is a traditional festival
  bool isFestival(DateTime solarDate) {
    return getFestival(solarDate) != null;
  }

  /// Get all festivals in a year
  List<FestivalInfo> getFestivalsInYear(int year) {
    return _festivals.toList();
  }

  /// Get festivals related to a solar term
  List<FestivalInfo> getFestivalsForSolarTerm(SolarTerm term) {
    switch (term.name) {
      case '冬至':
        return _festivals.where((f) => f.festival == TraditionalFestival.winterSolstice).toList();
      default:
        return [];
    }
  }

  /// List of traditional festivals
  static const List<FestivalInfo> _festivals = [
    FestivalInfo(
      festival: TraditionalFestival.springFestival,
      name: '春节',
      lunarMonth: 1,
      lunarDay: 1,
      description: '农历新年，中华民族最隆重的传统佳节',
    ),
    FestivalInfo(
      festival: TraditionalFestival.lanternFestival,
      name: '元宵节',
      lunarMonth: 1,
      lunarDay: 15,
      description: '正月十五，赏花灯、吃元宵',
    ),
    FestivalInfo(
      festival: TraditionalFestival.dragonBoatFestival,
      name: '端午节',
      lunarMonth: 5,
      lunarDay: 5,
      description: '五月初五，赛龙舟、吃粽子',
    ),
    FestivalInfo(
      festival: TraditionalFestival.midAutumnFestival,
      name: '中秋节',
      lunarMonth: 8,
      lunarDay: 15,
      description: '八月十五，赏月、吃月饼',
    ),
    FestivalInfo(
      festival: TraditionalFestival.doubleNinthFestival,
      name: '重阳节',
      lunarMonth: 9,
      lunarDay: 9,
      description: '九月九日，登高、赏菊',
    ),
    FestivalInfo(
      festival: TraditionalFestival.labaFestival,
      name: '腊八节',
      lunarMonth: 12,
      lunarDay: 8,
      description: '腊月初八，喝腊八粥',
    ),
    FestivalInfo(
      festival: TraditionalFestival.winterSolstice,
      name: '冬至',
      lunarMonth: 11,
      lunarDay: 29,
      description: '冬至日，吃饺子、数九',
    ),
  ];
}
