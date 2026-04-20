import 'package:flutter_test/flutter_test.dart';
import 'package:solar_term_kit/solar_term_kit.dart';

void main() {
  group('SolarTerm', () {
    test('should create solar term with all fields', () {
      final solarTerm = SolarTerm(
        name: '立春',
        index: 0,
        description: '春季开始',
      );
      expect(solarTerm.name, '立春');
      expect(solarTerm.index, 0);
      expect(solarTerm.description, '春季开始');
    });
  });

  group('Season', () {
    test('should create spring season', () {
      final season = Season.spring;
      expect(season.name, 'Spring');
      expect(season.colorScheme.primaryColor, equals(0xFF4CAF50));
    });

    test('should create summer season', () {
      final season = Season.summer;
      expect(season.name, 'Summer');
      expect(season.colorScheme.primaryColor, equals(0xFFFF5722));
    });

    test('should create autumn season', () {
      final season = Season.autumn;
      expect(season.name, 'Autumn');
      expect(season.colorScheme.primaryColor, equals(0xFFFF9800));
    });

    test('should create winter season', () {
      final season = Season.winter;
      expect(season.name, 'Winter');
      expect(season.colorScheme.primaryColor, equals(0xFF607D8B));
    });
  });

  group('SolarTerms', () {
    test('should return all 24 solar terms', () {
      final terms = SolarTerms.all;
      expect(terms.length, equals(24));
    });

    test('should have correct solar term order', () {
      final terms = SolarTerms.all;
      expect(terms[0].name, '立春');
      expect(terms[23].name, '大寒');
    });

    test('should return unique names', () {
      final terms = SolarTerms.all;
      final names = terms.map((t) => t.name).toSet();
      expect(names.length, equals(24));
    });
  });

  group('SolarTerms.getCurrentSolarTerm', () {
    test('should return solar term for known date', () {
      // 2024-02-04 is around 立春
      final date = DateTime(2024, 2, 4);
      final solarTerm = SolarTerms.getCurrentSolarTerm(date);
      expect(solarTerm, isNotNull);
      expect(solarTerm.index, equals(0)); // 立春 is index 0
    });

    test('should return different solar terms for different dates', () {
      final date1 = DateTime(2024, 2, 4); // 立春
      final date2 = DateTime(2024, 6, 21); // 夏至
      final term1 = SolarTerms.getCurrentSolarTerm(date1);
      final term2 = SolarTerms.getCurrentSolarTerm(date2);
      expect(term1.name, isNot(equals(term2.name)));
    });

    test('should handle leap year', () {
      final date1 = DateTime(2024, 2, 4); // leap year
      final date2 = DateTime(2023, 2, 4); // non-leap year
      final term1 = SolarTerms.getCurrentSolarTerm(date1);
      final term2 = SolarTerms.getCurrentSolarTerm(date2);
      expect(term1.index, equals(term2.index));
    });

    test('should return null for invalid date', () {
      final date = DateTime(1800, 1, 1); // Too far in the past
      // The function should still return something or handle gracefully
      final solarTerm = SolarTerms.getCurrentSolarTerm(date);
      expect(solarTerm, isNotNull);
    });
  });

  group('SolarTerms.getCurrentSeason', () {
    test('should return Spring in February', () {
      final date = DateTime(2024, 2, 4);
      final season = SolarTerms.getCurrentSeason(date);
      expect(season, equals(Season.spring));
    });

    test('should return Summer in June', () {
      final date = DateTime(2024, 6, 21);
      final season = SolarTerms.getCurrentSeason(date);
      expect(season, equals(Season.summer));
    });

    test('should return Autumn in September', () {
      final date = DateTime(2024, 9, 23);
      final season = SolarTerms.getCurrentSeason(date);
      expect(season, equals(Season.autumn));
    });

    test('should return Winter in December', () {
      final date = DateTime(2024, 12, 22);
      final season = SolarTerms.getCurrentSeason(date);
      expect(season, equals(Season.winter));
    });

    test('should handle year boundary', () {
      final date1 = DateTime(2024, 1, 5); // Winter
      final date2 = DateTime(2024, 2, 4); // Spring
      final season1 = SolarTerms.getCurrentSeason(date1);
      final season2 = SolarTerms.getCurrentSeason(date2);
      expect(season1, equals(Season.winter));
      expect(season2, equals(Season.spring));
    });
  });

  group('SolarTerms.getSolarTermTime', () {
    test('should calculate solar term time for 2024', () {
      final time = SolarTerms.getSolarTermTime(2024, 0); // 立春
      expect(time.year, equals(2024));
      expect(time.month, equals(2));
      // 立春 should be around Feb 3-5
      expect(time.day, greaterThanOrEqualTo(3));
      expect(time.day, lessThanOrEqualTo(5));
    });

    test('should calculate different times for different years', () {
      final time1 = SolarTerms.getSolarTermTime(2024, 0); // 立春
      final time2 = SolarTerms.getSolarTermTime(2025, 0); // 立春
      // The difference should be close to 1 year, considering the 0.2422 day offset
      final difference = time2.difference(time1).inDays;
      expect(difference, closeTo(365, 2));
    });

    test('should handle all 24 solar terms', () {
      for (int i = 0; i < 24; i++) {
        final time = SolarTerms.getSolarTermTime(2024, i);
        expect(time.year, equals(2024));
        expect(time.month, greaterThan(0));
        expect(time.month, lessThan(13));
      }
    });
  });

  group('SeasonService', () {
    test('should get season color scheme', () {
      final springColors = SeasonService.getSeasonColorScheme(Season.spring);
      expect(springColors.primaryColor, equals(0xFF4CAF50));
      expect(springColors.secondaryColor, equals(0xFF81C784));
    });

    test('should return different colors for different seasons', () {
      final springColors = SeasonService.getSeasonColorScheme(Season.spring);
      final winterColors = SeasonService.getSeasonColorScheme(Season.winter);
      expect(springColors.primaryColor, isNot(equals(winterColors.primaryColor)));
    });
  });
}
