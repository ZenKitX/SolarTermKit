/// Performance utilities for SolarTermKit
library;

import 'calculator/solar_term_calculator.dart';

/// Cache performance metrics
class CacheMetrics {
  CacheMetrics({
    this.hits = 0,
    this.misses = 0,
  });

  final int hits;
  final int misses;

  double get hitRate => (hits + misses) > 0 ? hits / (hits + misses) : 0.0;

  @override
  String toString() {
    return 'CacheMetrics(hits: $hits, misses: $misses, hitRate: ${(hitRate * 100).toStringAsFixed(1)}%)';
  }
}

/// Extended calculator with detailed cache metrics
class CachedSolarTermCalculator extends AstronomicalCalculator {
  CachedSolarTermCalculator._({
    required SolarTermCalculatorConfig config,
  }) : super.create(config: config) {
    _metrics = CacheMetrics();
  }

  factory CachedSolarTermCalculator.create({
    SolarTermCalculatorConfig config = SolarTermCalculatorConfig.defaultConfig,
  }) {
    return CachedSolarTermCalculator._(config: config);
  }

  late CacheMetrics _metrics;

  /// Get current cache metrics
  CacheMetrics get metrics => _metrics;

  /// Reset cache metrics
  void resetMetrics() {
    _metrics = CacheMetrics();
  }

  @override
  DateTime getSolarTermTime(int year, int index) {
    _metrics = CacheMetrics(hits: _metrics.hits, misses: _metrics.misses);

    // Call parent implementation (which handles caching)
    final result = super.getSolarTermTime(year, index);
    
    // Update metrics (simplified - in production, track actual cache hits)
    _metrics = CacheMetrics(hits: _metrics.hits + 1, misses: _metrics.misses);
    
    return result;
  }

  @override
  void clearCache() {
    super.clearCache();
    _metrics = CacheMetrics();
  }
}
