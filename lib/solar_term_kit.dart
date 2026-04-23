/// SolarTermKit - A solar terms package for Flutter apps
///
/// This package provides:
/// - Accurate calculation of 24 solar terms
/// - Season determination
/// - Solar term descriptions and colors
/// - Astronomical algorithm implementation
/// - Configurable calculator with time zone support
///
/// Usage (static methods - backward compatible):
/// ```dart
/// final solarTerm = SolarTerms.getCurrentSolarTerm();
/// final season = SolarTerms.getCurrentSeason();
/// ```
///
/// Usage (configurable calculator - new API):
/// ```dart
/// // Create calculator with custom configuration
/// final calculator = AstronomicalCalculator.create(
///   config: SolarTermCalculatorConfig(
///     timeZoneOffset: Duration(hours: 8), // China time
///     precision: SolarTermPrecision.minute,
///     useCache: true,
///   ),
/// );
///
/// final solarTerm = calculator.getCurrentSolarTerm();
/// ```
library;

export 'src/calculator/solar_term_calculator.dart';
export 'src/performance/cache_performance.dart';
export 'src/solar_terms.dart';
export 'src/models/solar_term_model.dart';
export 'src/models/solar_term_progress.dart';
export 'src/services/season_service.dart';
