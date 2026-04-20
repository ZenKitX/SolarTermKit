/// Benchmark tests for SolarTermKit.
///
/// Run with: dart run benchmark/solar_term_benchmark.dart
library;

import 'package:flutter/material.dart';
import 'package:solar_term_kit/solar_term_kit.dart';

void main() {
  print('=== SolarTermKit Performance Benchmark ===\n');

  benchmarkSolarTermCreation();
  benchmarkSolarTermRetrieval();
  benchmarkSeasonService();
  benchmarkAllSolarTerms();

  print('\n=== Benchmark Complete ===');
}

void benchmarkSolarTermCreation() {
  print('--- SolarTerm Creation Benchmark ---');

  const iterations = 10000;

  // Benchmark minimal solar term
  final stopwatch = Stopwatch()..start();

  for (int i = 0; i < iterations; i++) {
    SolarTerm(
      name: '立春',
      description: '二十四节气之首，春季开始',
      season: Season.spring,
      color: Colors.green.shade300,
    );
  }

  stopwatch.stop();
  final avgTime1 = stopwatch.elapsedMicroseconds / iterations;
  print(
    '  SolarTerm (minimal): ${avgTime1.toStringAsFixed(2)} μs/op ($iterations ops)',
  );

  // Benchmark full solar term
  stopwatch.reset();
  stopwatch.start();

  for (int i = 0; i < iterations; i++) {
    SolarTerm(
      name: '立春',
      description: '二十四节气之首，春季开始',
      date: DateTime(2024, 2, 4),
      season: Season.spring,
      color: Colors.green.shade300,
    );
  }

  stopwatch.stop();
  final avgTime2 = stopwatch.elapsedMicroseconds / iterations;
  print(
    '  SolarTerm (full): ${avgTime2.toStringAsFixed(2)} μs/op ($iterations ops)',
  );
  print('');
}

void benchmarkSolarTermRetrieval() {
  print('--- SolarTerm Retrieval Benchmark ---');

  const iterations = 100000;

  // Benchmark getCurrentSolarTerm
  final stopwatch = Stopwatch()..start();

  for (int i = 0; i < iterations; i++) {
    SolarTerms.getCurrentSolarTerm();
  }

  stopwatch.stop();
  final avgTime1 = stopwatch.elapsedMicroseconds / iterations;
  print(
    '  getCurrentSolarTerm(): ${avgTime1.toStringAsFixed(2)} μs/op ($iterations ops)',
  );

  // Benchmark getSolarTermByIndex
  stopwatch.reset();
  stopwatch.start();

  for (int i = 0; i < iterations; i++) {
    SolarTerms.getSolarTermByIndex(0);
  }

  stopwatch.stop();
  final avgTime2 = stopwatch.elapsedMicroseconds / iterations;
  print(
    '  getSolarTermByIndex(0): ${avgTime2.toStringAsFixed(2)} μs/op ($iterations ops)',
  );
  print('');
}

void benchmarkSeasonService() {
  print('--- SeasonService Benchmark ---');

  const iterations = 100000;

  // Benchmark getCurrentSeason
  final stopwatch = Stopwatch()..start();

  for (int i = 0; i < iterations; i++) {
    SolarTerms.getCurrentSeason();
  }

  stopwatch.stop();
  final avgTime1 = stopwatch.elapsedMicroseconds / iterations;
  print(
    '  getCurrentSeason(): ${avgTime1.toStringAsFixed(2)} μs/op ($iterations ops)',
  );

  // Benchmark getSeasonColor
  stopwatch.reset();
  stopwatch.start();

  for (int i = 0; i < iterations; i++) {
    SeasonService.getSeasonColor(Season.spring);
  }

  stopwatch.stop();
  final avgTime2 = stopwatch.elapsedMicroseconds / iterations;
  print(
    '  getSeasonColor(Season.spring): ${avgTime2.toStringAsFixed(2)} μs/op ($iterations ops)',
  );

  // Benchmark getSeasonColorScheme
  stopwatch.reset();
  stopwatch.start();

  for (int i = 0; i < iterations; i++) {
    SeasonService.getSeasonColorScheme(Season.spring);
  }

  stopwatch.stop();
  final avgTime3 = stopwatch.elapsedMicroseconds / iterations;
  print(
    '  getSeasonColorScheme(Season.spring): ${avgTime3.toStringAsFixed(2)} μs/op ($iterations ops)',
  );
  print('');
}

void benchmarkAllSolarTerms() {
  print('--- All Solar Terms Benchmark ---');

  const iterations = 10000;

  // Benchmark getting all solar terms
  final stopwatch = Stopwatch()..start();

  for (int i = 0; i < iterations; i++) {
    SolarTerms.all;
  }

  stopwatch.stop();
  final avgTime1 = stopwatch.elapsedMicroseconds / iterations;
  print(
    '  SolarTerms.all: ${avgTime1.toStringAsFixed(2)} μs/op ($iterations ops)',
  );

  // Benchmark getSolarTermByName
  stopwatch.reset();
  stopwatch.start();

  for (int i = 0; i < iterations; i++) {
    SolarTerms.getSolarTermByName('立春');
  }

  stopwatch.stop();
  final avgTime2 = stopwatch.elapsedMicroseconds / iterations;
  print(
    '  getSolarTermByName("立春"): ${avgTime2.toStringAsFixed(2)} μs/op ($iterations ops)',
  );
  print('');
}
