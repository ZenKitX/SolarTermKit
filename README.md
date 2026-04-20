# SolarTermKit

A solar terms package for Flutter apps. Provides accurate calculation of 24 solar terms and seasons.

## Features

- ✅ Accurate calculation of 24 solar terms using astronomical algorithms
- ✅ Season determination
- ✅ Solar term descriptions and colors
- ✅ No external dependencies
- ✅ Fixed solar term calculation (replaced fixed dates with astronomical algorithm)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  solar_term_kit:
    git:
      url: https://github.com/ZenKitX/SolarTermKit.git
      ref: main
```

## Usage

### Basic Usage

```dart
import 'package:solar_term_kit/solar_term_kit.dart';

void main() {
  // Get current solar term
  final solarTerm = SolarTerms.getCurrentSolarTerm();
  print('Current solar term: $solarTerm');

  // Get current season
  final season = SolarTerms.getCurrentSeason();
  print('Current season: $season');

  // Check if today is a solar term day
  final isSolarTermDay = SolarTerms.isSolarTermDay();
  print('Is solar term day: $isSolarTermDay');
}
```

### Get Solar Term Details

```dart
// Get solar term description
final description = SolarTerms.getSolarTermDescription('立春');
print(description); // 立春，二十四节气之首，春季开始

// Get solar term season
final season = SolarTerms.getSolarTermSeason('立春');
print(season); // 春

// Get full details
final details = SolarTerms.getSolarTermDetails('立春');
print('${details.name}: ${details.description}');
```

### Season Service

```dart
// Check season for a date
final date = DateTime(2024, 3, 15);
final season = SeasonService.getSeasonForDate(date);
print(season); // 春

// Check specific season
final isSpring = SeasonService.isSpring(date);
print(isSpring); // true

// Get season color
final color = SeasonService.getSeasonColor('春');
print(color); // Color(0xFF81C784)

// Get season description
final desc = SeasonService.getSeasonDescription('春');
print(desc); // 春回大地，万物复苏
```

### Calculate Solar Term Time

```dart
// Calculate solar term time for a specific year
final springEquinoxTime = SolarTerms.getSolarTermTime(2024, 3);
print(springEquinoxTime); // 2024-03-20 11:06:00.000
```

### Get All Solar Terms

```dart
final allTerms = SolarTerms.getAllSolarTerms();
print(allTerms);
// [立春, 雨水, 惊蛰, 春分, 清明, 谷雨, 立夏, 小满, 芒种, 夏至, 小暑, 大暑, 立秋, 处暑, 白露, 秋分, 寒露, 霜降, 立冬, 小雪, 大雪, 冬至, 小寒, 大寒]
```

## 24 Solar Terms

### Spring (春)
- 立春 (Start of Spring)
- 雨水 (Rain Water)
- 惊蛰 (Awakening of Insects)
- 春分 (Spring Equinox)
- 清明 (Pure Brightness)
- 谷雨 (Grain Rain)

### Summer (夏)
- 立夏 (Start of Summer)
- 小满 (Grain Buds)
- 芒种 (Grain in Ear)
- 夏至 (Summer Solstice)
- 小暑 (Minor Heat)
- 大暑 (Major Heat)

### Autumn (秋)
- 立秋 (Start of Autumn)
- 处暑 (Limit of Heat)
- 白露 (White Dew)
- 秋分 (Autumn Equinox)
- 寒露 (Cold Dew)
- 霜降 (Frost's Descent)

### Winter (冬)
- 立冬 (Start of Winter)
- 小雪 (Minor Snow)
- 大雪 (Major Snow)
- 冬至 (Winter Solstice)
- 小寒 (Minor Cold)
- 大寒 (Major Cold)

## Algorithm Improvement

### Fixed: Astronomical Algorithm

**Before**: Used fixed date ranges
```dart
if (month == 2 && day >= 3 && day <= 5) return '立春';
if (month == 2 && day >= 18 && day <= 20) return '雨水';
```

**Problem**: Solar terms vary by 1-2 days each year due to Earth's elliptical orbit.

**After**: Uses astronomical calculation
```dart
static DateTime getSolarTermTime(int year, int solarTermIndex) {
  final baseDates = [
    [2, 4.79],   // 立春
    [2, 19.43],  // 雨水
    // ...
  ];

  final yearOffset = (year - 2000) * 0.2422;
  final leapYearOffset = _isLeapYear(year) ? -1 : 0;
  // Calculate exact solar term time
}
```

**Result**: Accurate calculation of solar terms for any year.

### Year Offset Calculation

Solar terms occur approximately 0.2422 days later each year:

- Base year: 2000
- 2024: +5.8488 days
- Adjusted for leap years

## Example Output

```dart
final solarTerm = SolarTerms.getCurrentSolarTerm();
final season = SolarTerms.getCurrentSeason();
final description = SolarTerms.getSolarTermDescription(solarTerm);
final color = SeasonService.getSeasonColorCode(season);

print('节气: $solarTerm');          // 立春
print('季节: $season');              // 春
print('描述: $description');         // 立春，二十四节气之首，春季开始
print('颜色: 0x${color.toRadixString(16)}'); // 0xFF81C784
```

## Season Colors

| Season | Color | Hex |
|--------|-------|-----|
| 春 | Green 300 | 0xFF81C784 |
| 夏 | Red 300 | 0xFFE57373 |
| 秋 | Orange 300 | 0xFFFFB74D |
| 冬 | Blue 300 | 0xFF64B5F6 |

## License

MIT License

## Contributing

Contributions are welcome! Please feel free to:
- Improve the algorithm
- Add more features
- Fix bugs
- Improve documentation
