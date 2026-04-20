// ignore_for_file: avoid_print

/// Benchmark tests for SolarTermKit.
///
/// Run with: dart run benchmark/solar_term_benchmark.dart
library;

import 'package:solar_term_kit/solar_term_kit.dart';

void main() {
  print('=== SolarTermKit Performance Benchmark ===\n');

  // Warm up
  print('Warming up...');
  for (int i = 0; i < 100; i++) {
    SolarTerms.getCurrentSolarTerm(DateTime.now());
  }
  print('Warm up complete.\n');

  // Run benchmarks
  benchmarkGetCurrentSolarTerm();
  benchmarkGetCurrentSeason();
  benchmarkGetSolarTermTime();
  benchmarkGetAllSolarTerms();
  benchmarkSeasonColorScheme();

  print('\n=== Benchmark Complete ===');
}

void benchmarkGetCurrentSolarTerm() {
  print('--- Get Current Solar Term Benchmark ---');

  final stopwatch = Stopwatch()..start();
  const iterations = 10000;

  for (int i = 0; i < iterations; i++) {
    SolarTerms.getCurrentSolarTerm(DateTime.now());
  }

  stopwatch.stop();
  final avgTime = stopwatch.elapsedMicroseconds / iterations;
  print(
    '  getCurrentSolarTerm: ${avgTime.toStringAsFixed(2)} μs/op ($iterations ops)',
  );
  print('');
}

void benchmarkGetCurrentSeason() {
  print('--- Get Current Season Benchmark ---');

  final stopwatch = Stopwatch()..start();
  const iterations = 10000;

  for (int i = 0; i < iterations; i++) {
    SolarTerms.getCurrentSeason(DateTime.now());
  }

  stopwatch.stop();
  final avgTime = stopwatch.elapsedMicroseconds / iterations;
  print(
    '  getCurrentSeason: ${avgTime.toStringAsFixed(2)} μs/op ($iterations ops)',
  );
  print('');
}

void benchmarkGetSolarTermTime() {
  print('--- Get Solar Term Time Benchmark ---');

  final years = [2024, 2025, 2026, 2027, 2028];

  for (final year in years) {
    final stopwatch = Stopwatch()..start();
    const iterations = 10000;

    for (int i = 0; i < iterations; i++) {
      SolarTerms.getSolarTermTime(year, i % 24);
    }

    stopwatch.stop();
    final avgTime = stopwatch.elapsedMicroseconds / iterations;
    print(
      '  getSolarTermTime($year): ${avgTime.toStringAsFixed(2)} μs/op ($iterations ops)',
    );
  }
  print('');
}

void benchmarkGetAllSolarTerms() {
  print('--- Get All Solar Terms Benchmark ---');

  final stopwatch = Stopwatch()..start();
  const iterations = 10000;

  for (int i = 0; i < iterations; i++) {
    SolarTerms.all;
  }

  stopwatch.stop();
  final avgTime = stopwatch.elapsedMicroseconds / iterations;
  print(
    '  SolarTerms.all: ${avgTime.toStringAsFixed(2)} μs/op ($iterations ops)',
  );

  // Benchmark iteration
  stopwatch.reset();
  stopwatch.start();

  int totalIterations = 0;
  const outerIterations = 1000;

  for (int i = 0; i < outerIterations; i++) {
    for (final _ in SolarTerms.all) {
      totalIterations++;
    }
  }

  stopwatch.stop();
  final avgTime2 = stopwatch.elapsedMicroseconds / totalIterations;
  print(
    '  SolarTerms.all (iteration): ${avgTime2.toStringAsFixed(2)} μs/op ($totalIterations ops)',
  );
  print('');
}

void benchmarkSeasonColorScheme() {
  print('--- Season Color Scheme Benchmark ---');

  final seasons = Season.values;

  for (final season in seasons) {
    final stopwatch = Stopwatch()..start();
    const iterations = 10000;

    for (int i = 0; i < iterations; i++) {
      SeasonService.getSeasonColorScheme(season);
    }

    stopwatch.stop();
    final avgTime = stopwatch.elapsedMicroseconds / iterations;
    print(
      '  getSeasonColorScheme($season): ${avgTime.toStringAsFixed(2)} μs/op ($iterations ops)',
    );
  }
  print('');
}

void benchmarkSolarTermLookup() {
  print('--- Solar Term Lookup Benchmark ---');

  final solarTerms = SolarTerms.all;

  for (final term in solarTerms) {
    final stopwatch = Stopwatch()..start();
    const iterations = 10000;

    for (int i = 0; i < iterations; i++) {
      SolarTerms.getSolarTermByName(term.name);
    }

    stopwatch.stop();
    final avgTime = stopwatch.elapsedMicroseconds / iterations;
    print(
      '  getSolarTermByName("${term.name}"): ${avgTime.toStringAsFixed(2)} μs/op ($iterations ops)',
    );
  }
  print('');
}
