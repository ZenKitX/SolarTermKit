import 'models/solar_term_model.dart';
import 'models/solar_term_progress.dart';
import 'services/season_service.dart';

/// Solar term precision level
enum SolarTermPrecision {
  /// Minute precision (default, suitable for most use cases)
  minute,

  /// Hour precision
  hour,

  /// Day precision
  day,
}

/// Configuration for solar term calculator
class SolarTermCalculatorConfig {
  const SolarTermCalculatorConfig({
    this.timeZoneOffset = Duration.zero,
    this.precision = SolarTermPrecision.minute,
    this.useCache = true,
    this.cacheMaxSize = 50,
  });

  /// Time zone offset from UTC (default: UTC)
  final Duration timeZoneOffset;

  /// Calculation precision (default: minute)
  final SolarTermPrecision precision;

  /// Enable caching for repeated calculations
  final bool useCache;

  /// Maximum cache size (number of years)
  final int cacheMaxSize;

  /// Default configuration
  static const defaultConfig = SolarTermCalculatorConfig();

  /// China standard time (UTC+8)
  static const chinaTime = SolarTermCalculatorConfig(
    timeZoneOffset: Duration(hours: 8),
  );

  /// High precision configuration
  static const highPrecision = SolarTermCalculatorConfig(
    precision: SolarTermPrecision.minute,
    useCache: true,
    cacheMaxSize: 100,
  );

  /// Fast configuration (lower precision)
  static const fast = SolarTermCalculatorConfig(
    precision: SolarTermPrecision.hour,
    useCache: false,
  );
}

/// Abstract interface for solar term calculators
///
/// This allows different implementations (e.g., using VSOP87,
/// simplified formulas, or lookup tables)
abstract class SolarTermCalculator {
  /// Calculate solar term time for a given year and term index
  ///
  /// [year] - The year (e.g., 2024)
  /// [index] - Solar term index (0-23, where 0 is 立春)
  DateTime getSolarTermTime(int year, int index);

  /// Get current solar term for a given date
  ///
  /// [date] - Reference date (default: current time)
  SolarTerm getCurrentSolarTerm([DateTime? date]);

  /// Get solar term by index
  ///
  /// [index] - Solar term index (0-23)
  SolarTerm getSolarTermByIndex(int index);

  /// Get solar term by name
  ///
  /// [name] - Solar term name (e.g., '立春')
  SolarTerm? getSolarTermByName(String name);

  /// Get current season
  ///
  /// [date] - Reference date (default: current time)
  Season getCurrentSeason([DateTime? date]);

  /// Get next solar term
  ///
  /// [date] - Reference date (default: current time)
  SolarTerm getNextSolarTerm([DateTime? date]);

  /// Get previous solar term
  ///
  /// [date] - Reference date (default: current time)
  SolarTerm getPreviousSolarTerm([DateTime? date]);

  /// Get all solar terms for a year
  ///
  /// [year] - The year
  List<DateTime> getYearSolarTerms(int year);

  /// Get progress within the current solar term
  ///
  /// [date] - Reference date (default: current time)
  /// Returns progress information including percentage, days elapsed, etc.
  SolarTermProgress getCurrentProgress([DateTime? date]);

  /// Get the period for a specific solar term
  ///
  /// [termName] - Solar term name (e.g., '立春', '春分')
  /// [year] - The year
  /// Returns the start and end dates of the solar term period
  SolarTermPeriod getTermPeriod(String termName, int year);

  /// Clear cache (if caching is enabled)
  void clearCache();

  /// Get calculator configuration
  SolarTermCalculatorConfig get config;
}

/// Default astronomical calculator implementation
class AstronomicalCalculator implements SolarTermCalculator {
  AstronomicalCalculator._({
    required this.config,
  }) : _cache = {};

  /// Create calculator with default configuration
  factory AstronomicalCalculator.create({
    SolarTermCalculatorConfig config = SolarTermCalculatorConfig.defaultConfig,
  }) {
    return AstronomicalCalculator._(config: config);
  }

  /// Create calculator with China time zone (UTC+8)
  factory AstronomicalCalculator.chinaTime() {
    return AstronomicalCalculator.create(
      config: SolarTermCalculatorConfig.chinaTime,
    );
  }

  /// Create calculator with custom time zone
  factory AstronomicalCalculator.withTimeZone(Duration offset) {
    return AstronomicalCalculator.create(
      config: SolarTermCalculatorConfig(
        timeZoneOffset: offset,
      ),
    );
  }

  @override
  final SolarTermCalculatorConfig config;

  // Cache for calculated solar terms: Map<year, List<DateTime>>
  final Map<int, List<DateTime>?> _cache;

  @override
  DateTime getSolarTermTime(int year, int index) {
    // Check cache
    if (config.useCache) {
      final cached = _cache[year];
      if (cached != null && index < cached.length) {
        return cached[index];
      }

      // Calculate entire year if not in cache
      if (cached == null) {
        _cacheYear(year);
        return _cache[year]![index];
      }
    }

    // Calculate directly if caching disabled
    return _calculateSingleTerm(year, index);
  }

  @override
  SolarTerm getCurrentSolarTerm([DateTime? date]) {
    date ??= DateTime.now();
    final year = date.year;
    final allTerms = getYearSolarTerms(year);

    // Find current term
    for (int i = 0; i < 24; i++) {
      final termDate = allTerms[i];
      final nextTermDate = i < 23 ? allTerms[i + 1] : getYearSolarTerms(year + 1)[0];

      if (date.isAfter(termDate) && date.isBefore(nextTermDate)) {
        return getSolarTermByIndex(i);
      }
    }

    // Fallback to first term
    return getSolarTermByIndex(0);
  }

  @override
  SolarTerm getSolarTermByIndex(int index) {
    return SolarTerm(
      name: _names[index],
      description: _descriptions[index],
      season: _seasons[index],
      color: _getSeasonColor(_seasons[index]),
    );
  }

  @override
  SolarTerm? getSolarTermByName(String name) {
    final index = _names.indexOf(name);
    if (index >= 0) {
      return getSolarTermByIndex(index);
    }
    return null;
  }

  @override
  Season getCurrentSeason([DateTime? date]) {
    date ??= DateTime.now();
    final month = date.month;

    if (month >= 3 && month <= 5) {
      return Season.spring;
    } else if (month >= 6 && month <= 8) {
      return Season.summer;
    } else if (month >= 9 && month <= 11) {
      return Season.autumn;
    } else {
      return Season.winter;
    }
  }

  @override
  SolarTerm getNextSolarTerm([DateTime? date]) {
    date ??= DateTime.now();
    final current = getCurrentSolarTerm(date);
    return getSolarTermByIndex((current.index + 1) % 24);
  }

  @override
  SolarTerm getPreviousSolarTerm([DateTime? date]) {
    date ??= DateTime.now();
    final current = getCurrentSolarTerm(date);
    return getSolarTermByIndex((current.index - 1 + 24) % 24);
  }

  @override
  List<DateTime> getYearSolarTerms(int year) {
    if (config.useCache && _cache.containsKey(year)) {
      return _cache[year]!;
    }

    final terms = List<DateTime>.generate(24, (index) {
      return _calculateSingleTerm(year, index);
    });

    if (config.useCache) {
      // Implement LRU eviction
      if (_cache.length >= config.cacheMaxSize) {
        _cache.remove(_cache.keys.first);
      }
      _cache[year] = terms;
    }

    return terms;
  }

  @override
  void clearCache() {
    _cache.clear();
  }

  @override
  SolarTermProgress getCurrentProgress([DateTime? date]) {
    date ??= DateTime.now();

    // Get current and next solar terms
    final currentTerm = getCurrentSolarTerm(date);
    final nextTerm = getNextSolarTerm(date);

    // Get current term period
    final period = getTermPeriod(currentTerm.name, date.year);

    // Calculate progress
    final daysIntoTerm = date.difference(period.startDate).inDays;
    final totalDays = period.endDate.difference(period.startDate).inDays;
    final percentage = (daysIntoTerm / totalDays) * 100.0;
    final remainingDays = totalDays - daysIntoTerm;
    final daysUntilNextTerm = daysIntoTerm;

    return SolarTermProgress(
      currentTerm: currentTerm,
      nextTerm: nextTerm,
      period: period,
      percentage: percentage,
      daysIntoTerm: daysIntoTerm,
      daysUntilNextTerm: daysUntilNextTerm,
      remainingDays: remainingDays,
    );
  }

  @override
  SolarTermPeriod getTermPeriod(String termName, int year) {
    // Get term index
    final term = getSolarTermByName(termName);
    if (term == null) {
      throw ArgumentError('Unknown solar term: $termName');
    }

    final index = term.index;

    // Get current term date
    final startDate = getSolarTermTime(year, index);

    // Get next term date
    final nextIndex = (index + 1) % 24;
    int nextYear = year;
    if (index == 23) {
      nextYear = year + 1;
    }
    final endDate = getSolarTermTime(nextYear, nextIndex);

    return SolarTermPeriod(
      term: term,
      startDate: startDate,
      endDate: endDate,
    );
  }

  // Private calculation methods

  DateTime _calculateSingleTerm(int year, int index) {
    final baseDate = _baseDates[index];

    // Calculate year difference from base year 2000
    final yearDiff = year - 2000;

    // Calculate base date
    var month = baseDate[0].toInt();
    var day = baseDate[1].toInt();
    var hour = (baseDate[1] - day) * 24;
    var minute = ((hour - hour.toInt()) * 60).toInt();
    hour = hour.toInt();

    // Apply correction factor (0.2422 days per year)
    final correctionDays = yearDiff * 0.2422;

    // Apply leap year adjustments
    final leapAdjustments = _getLeapYearAdjustments(yearDiff);

    // Calculate final date
    final totalDays = day + correctionDays + leapAdjustments[index];
    day = totalDays.toInt();

    // Handle month overflow
    if (day > 31 && index < 6) {
      day -= 31;
      month = 3;
    } else if (day > 30 && index >= 6 && index < 12) {
      day -= 30;
      month = 4;
    }

    // Adjust for precision
    final adjusted = _applyPrecision(DateTime(year, month, day, hour, minute));

    // Apply time zone offset
    return adjusted.add(config.timeZoneOffset);
  }

  void _cacheYear(int year) {
    if (!config.useCache) return;
    _cache[year] = getYearSolarTerms(year);
  }

  DateTime _applyPrecision(DateTime dateTime) {
    switch (config.precision) {
      case SolarTermPrecision.day:
        return DateTime(dateTime.year, dateTime.month, dateTime.day);
      case SolarTermPrecision.hour:
        return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour);
      case SolarTermPrecision.minute:
        return DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
        );
    }
  }

  Color _getSeasonColor(Season season) {
    switch (season) {
      case Season.spring:
        return const Color(0xFF81C784);
      case Season.summer:
        return const Color(0xFF64B5F6);
      case Season.autumn:
        return const Color(0xFFFFB74D);
      case Season.winter:
        return const Color(0xFF90A4AE);
    }
  }

  // Data constants (copied from original implementation)
  static const List<List<double>> _baseDates = [
    [2, 4.79], [2, 19.43], [3, 6.44], [3, 21.15], [4, 5.59], [4, 21.03],
    [5, 6.38], [5, 21.76], [6, 6.44], [6, 21.65], [7, 7.70], [7, 23.35],
    [8, 8.23], [8, 23.79], [9, 8.46], [9, 23.64], [10, 9.00], [10, 24.00],
    [11, 8.32], [11, 23.15], [12, 7.88], [12, 22.29], [1, 6.30], [1, 20.89],
  ];

  static const List<String> _names = [
    '立春', '雨水', '惊蛰', '春分', '清明', '谷雨',
    '立夏', '小满', '芒种', '夏至', '小暑', '大暑',
    '立秋', '处暑', '白露', '秋分', '寒露', '霜降',
    '立冬', '小雪', '大雪', '冬至', '小寒', '大寒',
  ];

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

  static const List<Season> _seasons = [
    Season.spring, Season.spring, Season.spring, Season.spring, Season.spring, Season.spring,
    Season.summer, Season.summer, Season.summer, Season.summer, Season.summer, Season.summer,
    Season.autumn, Season.autumn, Season.autumn, Season.autumn, Season.autumn, Season.autumn,
    Season.winter, Season.winter, Season.winter, Season.winter, Season.winter, Season.winter,
  ];

  static const List<double> _getLeapYearAdjustments = [
    0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0,
  ];
}

/// Default calculator instance (singleton pattern)
class SolarTerms {
  SolarTerms._();

  /// Default calculator with UTC time zone
  static final _defaultCalculator = AstronomicalCalculator.create();

  /// Default calculator with China time zone (UTC+8)
  static final _chinaCalculator = AstronomicalCalculator.chinaTime();

  /// Get calculator instance
  static SolarTermCalculator get calculator => _defaultCalculator;

  /// Get China time zone calculator
  static SolarTermCalculator get chinaCalculator => _chinaCalculator;

  // Static methods (backward compatibility)

  static DateTime getSolarTerm(int year, int index) {
    return _chinaCalculator.getSolarTermTime(year, index);
  }

  static SolarTerm getCurrentSolarTerm([DateTime? date]) {
    return _chinaCalculator.getCurrentSolarTerm(date);
  }

  static SolarTerm getSolarTermByIndex(int index) {
    return _chinaCalculator.getSolarTermByIndex(index);
  }

  static SolarTerm? getSolarTermByName(String name) {
    return _chinaCalculator.getSolarTermByName(name);
  }

  static Season getCurrentSeason([DateTime? date]) {
    return _chinaCalculator.getCurrentSeason(date);
  }

  static SolarTerm getNextSolarTerm([DateTime? date]) {
    return _chinaCalculator.getNextSolarTerm(date);
  }

  static SolarTerm getPreviousSolarTerm([DateTime? date]) {
    return _chinaCalculator.getPreviousSolarTerm(date);
  }

  static List<DateTime> getYearSolarTerms(int year) {
    return _chinaCalculator.getYearSolarTerms(year);
  }

  static SolarTermProgress getCurrentProgress([DateTime? date]) {
    return _chinaCalculator.getCurrentProgress(date);
  }

  static SolarTermPeriod getTermPeriod(String termName, int year) {
    return _chinaCalculator.getTermPeriod(termName, year);
  }

  static void clearCache() {
    _chinaCalculator.clearCache();
    _defaultCalculator.clearCache();
  }
}
