import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solar_term_kit/solar_term_kit.dart';

void main() {
  group('Season', () {
    test('should have 4 seasons', () {
      expect(Season.values.length, equals(4));
    });

    test('should include all seasons', () {
      expect(Season.values, contains(Season.spring));
      expect(Season.values, contains(Season.summer));
      expect(Season.values, contains(Season.autumn));
      expect(Season.values, contains(Season.winter));
    });
  });

  group('SolarTerm', () {
    test('should create solar term', () {
      final term = SolarTerm(
        name: '立春',
        description: '二十四节气之首，春季开始',
        season: Season.spring,
        color: Colors.green.shade300,
      );
      expect(term.name, '立春');
      expect(term.description, '二十四节气之首，春季开始');
      expect(term.season, Season.spring);
      expect(term.color, isNotNull);
    });

    test('should have correct index', () {
      final term = SolarTerm(
        name: '立春',
        description: '二十四节气之首，春季开始',
        season: Season.spring,
        color: Colors.green.shade300,
      );
      expect(term.index, equals(0));
    });

    test('should return -1 for invalid name', () {
      final term = SolarTerm(
        name: 'Invalid',
        description: 'Test',
        season: Season.spring,
      );
      expect(term.index, equals(-1));
    });
  });

  group('SolarTerms', () {
    test('should get current solar term', () {
      final term = SolarTerms.getCurrentSolarTerm();
      expect(term, isNotNull);
      expect(term.name, isNotEmpty);
      expect(term.description, isNotEmpty);
    });

    test('should get solar term by index', () {
      final term = SolarTerms.getSolarTermByIndex(0);
      expect(term.name, '立春');
      expect(term.season, Season.spring);
    });

    test('should throw error for invalid index', () {
      expect(
        () => SolarTerms.getSolarTermByIndex(24),
        throwsArgumentError,
      );
    });

    test('should get all solar terms', () {
      final all = SolarTerms.all;
      expect(all.length, equals(24));
      expect(all[0].name, '立春');
      expect(all[23].name, '大寒');
    });

    test('should get solar term by name', () {
      final term = SolarTerms.getSolarTermByName('立春');
      expect(term, isNotNull);
      expect(term!.name, '立春');
    });

    test('should return null for invalid name', () {
      final term = SolarTerms.getSolarTermByName('Invalid');
      expect(term, isNull);
    });

    test('should get solar term for date', () {
      final date = DateTime(2024, 2, 4);
      final term = SolarTerms.getSolarTermForDate(date);
      expect(term, isNotNull);
      expect(term.name, isNotEmpty);
    });

    test('should calculate solar term time', () {
      final time = SolarTerms.getSolarTermTime(2024, 0);
      expect(time.year, equals(2024));
      expect(time.month, greaterThan(0));
      expect(time.day, greaterThan(0));
    });
  });

  group('SeasonService', () {
    test('should get current season', () {
      final season = SeasonService.getCurrentSeason();
      expect(season, isA<Season>());
    });

    test('should get season for date', () {
      final spring = SeasonService.getSeasonForDate(DateTime(2024, 4, 1));
      expect(spring, Season.spring);

      final summer = SeasonService.getSeasonForDate(DateTime(2024, 7, 1));
      expect(summer, Season.summer);

      final autumn = SeasonService.getSeasonForDate(DateTime(2024, 10, 1));
      expect(autumn, Season.autumn);

      final winter = SeasonService.getSeasonForDate(DateTime(2024, 1, 1));
      expect(winter, Season.winter);
    });

    test('should get season color', () {
      final springColor = SeasonService.getSeasonColor(Season.spring);
      expect(springColor, isNotNull);

      final summerColor = SeasonService.getSeasonColor(Season.summer);
      expect(summerColor, isNotNull);

      final autumnColor = SeasonService.getSeasonColor(Season.autumn);
      expect(autumnColor, isNotNull);

      final winterColor = SeasonService.getSeasonColor(Season.winter);
      expect(winterColor, isNotNull);
    });

    test('should get season color scheme', () {
      final springScheme = SeasonService.getSeasonColorScheme(Season.spring);
      expect(springScheme, isNotNull);

      final summerScheme = SeasonService.getSeasonColorScheme(Season.summer);
      expect(summerScheme, isNotNull);

      final autumnScheme = SeasonService.getSeasonColorScheme(Season.autumn);
      expect(autumnScheme, isNotNull);

      final winterScheme = SeasonService.getSeasonColorScheme(Season.winter);
      expect(winterScheme, isNotNull);
    });
  });
}
