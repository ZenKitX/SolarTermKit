# SolarTermKit

> Accurate calculation of 24 solar terms and seasons for Flutter apps with astronomical algorithm support.

[![CI](https://github.com/ZenKitX/SolarTermKit/workflows/SolarTermKit%20CI/badge.svg)](https://github.com/ZenKitX/SolarTermKit/actions)
[![pub package](https://img.shields.io/pub/v/solar_term_kit)](https://pub.dev/packages/solar_term_kit)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Features

- ✅ **Accurate Calculation**: Astronomical algorithm for precise solar term dates
- ✅ **24 Solar Terms**: Complete set of traditional Chinese solar terms
- ✅ **Season Detection**: Automatic season identification
- ✅ **Configurable**: Time zone support, precision control, caching
- ✅ **Progress Tracking**: Track progress within current solar term
- ✅ **Lunar Calendar**: Simplified lunar date conversion and Ganzhi calculation
- ✅ **High Performance**: LRU caching for frequently accessed dates
- ✅ **Validation**: Accuracy verified against official astronomical data

## Installation

```yaml
dependencies:
  solar_term_kit: ^0.1.0
```

## Quick Start

### Basic Usage (Static Methods)

```dart
import 'package:solar_term_kit/solar_term_kit.dart';

// Get current solar term
final solarTerm = SolarTerms.getCurrentSolarTerm();
print('🌱 Current term: ${solarTerm.name}');
print('📅 Date: ${solarTerm.date}');
print('🎨 Color: ${solarTerm.color}');
print('📖 ${solarTerm.description}');

// Get current season
final season = SolarTerms.getCurrentSeason();
print('🍂 Season: $season');

// Get all solar terms for a year
final terms = SolarTerms.getSolarTermsForYear(2024);
for (final term in terms) {
  print('${term.name}: ${term.date}');
}
```

### Configurable Calculator

```dart
import 'package:solar_term_kit/solar_term_kit.dart';

// Create calculator with custom configuration
final calculator = AstronomicalCalculator.create(
  config: SolarTermCalculatorConfig(
    timeZoneOffset: Duration(hours: 8), // China time
    precision: SolarTermPrecision.minute,
    useCache: true,
  ),
);

// Get solar term
final solarTerm = calculator.getCurrentSolarTerm();
```

### Progress Tracking

```dart
// Track progress within current solar term
final progress = calculator.getCurrentProgress();
print('Current: ${progress.currentTerm.name}');
print('Progress: ${progress.percentage}%');
print('Days until next: ${progress.daysUntilNextTerm}');
```

### Lunar Calendar (Simplified)

```dart
final service = LunarCalendarService.instance;
final lunarDate = service.getLunarDate(DateTime(2024, 2, 10));
print('Lunar: ${lunarDate.fullString}');  // 龙年 正月 初一
print('Zodiac: ${lunarDate.zodiac.emoji}');  // 🐲

final ganzhi = service.calculateGanzhi(DateTime(2024, 1, 1));
print('Year: ${ganzhi.year}, Month: ${ganzhi.month}, Day: ${ganzhi.day}');
```

## API Reference

### SolarTerm Model

```dart
class SolarTerm {
  final String name;           // Name in Chinese (e.g., "春分")
  final int index;             // Index (1-24)
  final DateTime date;         // Date of the solar term
  final String description;    // Description
  final Color color;           // Associated color
}
```

## Documentation

- [Progress Tracking API](docs/progress_api.md)
- [Lunar Calendar API](docs/lunar_calendar_api.md)
- [API Reference](https://pub.dev/documentation/solar_term_kit/latest/)

## License

MIT License - see [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

Made with ❤️ by [ZenKit Team](https://github.com/ZenKitX)
