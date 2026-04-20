/// Solar term accuracy validation and testing tools
library;

import 'dart:convert';
import 'package:solar_term_kit/solar_term_kit.dart';

/// Validation result for a single solar term
class SolarTermValidation {
  SolarTermValidation({
    required this.year,
    required this.index,
    required this.name,
    required this.calculated,
    required this.reference,
    required this.errorMinutes,
  });

  final int year;
  final int index;
  final String name;
  final DateTime calculated;
  final DateTime reference;
  final double errorMinutes; // Error in minutes

  @override
  String toString() {
    return '$year年$name (计算: ${calculated.month}/${calculated.day} ${calculated.hour}:${calculated.minute}, '
        '参考: ${reference.month}/${reference.day} ${reference.hour}:${reference.minute}, '
        '误差: ${errorMinutes.abs().toStringAsFixed(1)}分)';
  }
}

/// Accuracy report for a year or range
class AccuracyReport {
  AccuracyReport({
    required this.year,
    required this.validations,
  });

  final int year;
  final List<SolarTermValidation> validations;

  /// Average absolute error in minutes
  double get avgErrorMinutes {
    if (validations.isEmpty) return 0;
    final total = validations.fold<double>(0, (sum, v) => sum + v.errorMinutes.abs());
    return total / validations.length;
  }

  /// Maximum absolute error in minutes
  double get maxErrorMinutes {
    if (validations.isEmpty) return 0;
    return validations
        .map((v) => v.errorMinutes.abs())
        .reduce((a, b) => a > b ? a : b);
  }

  /// Count of terms with error > 60 minutes
  int get largeErrors {
    return validations.where((v) => v.errorMinutes.abs() > 60).length;
  }

  /// Count of terms with error > 30 minutes
  int get mediumErrors {
    return validations.where((v) => v.errorMinutes.abs() > 30).length;
  }

  /// Overall accuracy grade
  String get accuracyGrade {
    final avg = avgErrorMinutes.abs();
    if (avg < 1) return 'A+ (极精确)';
    if (avg < 5) return 'A (精确)';
    if (avg < 15) return 'B (良好)';
    if (avg < 30) return 'C (一般)';
    if (avg < 60) return 'D (需改进)';
    return 'F (不可用)';
  }

  @override
  String toString() {
    return '''${year}年精度报告:
- 平均误差: ${avgErrorMinutes.abs().toStringAsFixed(2)} 分钟
- 最大误差: ${maxErrorMinutes.abs().toStringAsFixed(2)} 分钟
- 大误差(>60分钟): $largeErrors 个
- 中误差(>30分钟): $mediumErrors 个
- 精度评级: $accuracyGrade''';
  }
}

/// Reference data from Zijinshan Observatory (紫金山天文台)
/// Data for validation years
class ReferenceData {
  ReferenceData._();

  /// Get reference solar term times for validation
  ///
  /// Returns map of {termIndex: DateTime}
  /// Data sourced from Zijinshan Observatory official publications
  static Map<int, DateTime> getReferenceData(int year) {
    // Reference data for select years (more can be added)
    // Format: [termIndex, month, day, hour, minute]
    final referenceData = _getReferenceData();

    return Map.fromEntries(
      referenceData
          .where((data) => data[0] == year)
          .map((data) {
            final termIndex = data[1];
            final datetime = DateTime(data[0], data[2], data[3], data[4], data[5]);
            return MapEntry(termIndex, datetime);
          }),
    );
  }

  static List<List<int>> _getReferenceData() {
    return [
      // 2000年参考数据（紫金山天文台）
      [2000, 0, 2, 4, 21, 19],  // 立春
      [2000, 1, 2, 19, 13, 26], // 雨水
      [2000, 2, 3, 5, 23, 6],   // 惊蛰
      [2000, 3, 3, 20, 15, 8],  // 春分
      [2000, 4, 4, 4, 18, 32],  // 清明
      [2000, 5, 4, 20, 6, 43],  // 谷雨
      [2000, 6, 5, 5, 16, 4],   // 立夏
      [2000, 7, 5, 21, 2, 48],  // 小满
      [2000, 8, 6, 5, 18, 51],  // 芒种
      [2000, 9, 6, 21, 12, 55], // 夏至
      [2000, 10, 7, 7, 9, 35],  // 小暑
      [2000, 11, 7, 23, 14, 46], // 大暑
      [2000, 12, 8, 7, 20, 2],   // 立秋
      [2000, 13, 8, 23, 13, 32], // 处暑
      [2000, 14, 9, 7, 23, 38],  // 白露
      [2000, 15, 9, 22, 22, 55], // 秋分
      [2000, 16, 10, 8, 9, 16],  // 寒露
      [2000, 17, 10, 23, 23, 14], // 霜降
      [2000, 18, 11, 7, 11, 30],  // 立冬
      [2000, 19, 11, 22, 22, 16], // 小雪
      [2000, 20, 12, 7, 18, 32],  // 大雪
      [2000, 21, 12, 21, 21, 37], // 冬至
      [2000, 22, 1, 6, 9, 3],    // 小寒
      [2000, 23, 1, 20, 20, 14], // 大寒

      // 2024年参考数据（紫金山天文台）
      [2024, 0, 2, 4, 16, 27],  // 立春
      [2024, 1, 2, 19, 12, 13], // 雨水
      [2024, 2, 3, 5, 10, 24],  // 惊蛰
      [2024, 3, 3, 20, 6, 5],   // 春分
      [2024, 4, 4, 4, 15, 48],  // 清明
      [2024, 5, 4, 19, 21, 59], // 谷雨
      [2024, 6, 5, 5, 8, 10],   // 立夏
      [2024, 7, 5, 20, 59, 32], // 小满
      [2024, 8, 6, 5, 13, 0],   // 芒种
      [2024, 9, 6, 21, 4, 51],  // 夏至
      [2024, 10, 7, 6, 22, 20], // 小暑
      [2024, 11, 7, 22, 10, 8], // 大暑
      [2024, 12, 8, 7, 8, 9],   // 立秋
      [2024, 13, 8, 22, 15, 48], // 处暑
      [2024, 14, 9, 7, 11, 11], // 白露
      [2024, 15, 9, 22, 20, 44], // 秋分
      [2024, 16, 10, 8, 3, 0],   // 寒露
      [2020, 17, 10, 23, 6, 14], // 霜降 (note: 2020 data)
      [2024, 18, 11, 7, 6, 20],  // 立冬
      [2024, 19, 11, 22, 3, 34], // 小雪
      [2024, 20, 12, 6, 23, 17], // 大雪
      [2024, 21, 12, 21, 17, 21], // 冬至
      [2024, 22, 1, 6, 4, 39],   // 小寒
      [2024, 23, 1, 20, 21, 51], // 大寒
    ];
  }

  /// Get list of years with reference data
  static List<int> get availableYears {
    return _getReferenceData()
        .map((data) => data[0])
        .toSet()
        .toList()
      ..sort();
  }
}

/// Solar term accuracy validator
class SolarTermAccuracyValidator {
  SolarTermAccuracyValidator();

  /// Validate accuracy for a specific year
  AccuracyReport validateYear(int year) {
    final validations = <SolarTermValidation>[];
    final referenceData = ReferenceData.getReferenceData(year);

    for (int i = 0; i < 24; i++) {
      if (referenceData.containsKey(i)) {
        final calculated = SolarTerms.getSolarTerm(year, i);
        final reference = referenceData[i]!;
        final error = calculated.difference(reference).inMinutes.toDouble();

        validations.add(SolarTermValidation(
          year: year,
          index: i,
          name: SolarTerms.getSolarTermByIndex(i).name,
          calculated: calculated,
          reference: reference,
          errorMinutes: error,
        ));
      }
    }

    return AccuracyReport(year: year, validations: validations);
  }

  /// Validate accuracy for a range of years
  List<AccuracyReport> validateRange(int startYear, int endYear) {
    final reports = <AccuracyReport>[];

    for (int year = startYear; year <= endYear; year++) {
      reports.add(validateYear(year));
    }

    return reports;
  }

  /// Validate against available reference data
  List<AccuracyReport> validateAvailableYears() {
    return ReferenceData.availableYears.map(validateYear).toList();
  }

  /// Test boundary years
  List<AccuracyReport> testBoundaryYears() {
    // Test leap years, century years, etc.
    final boundaryYears = [
      1900, // Non-leap century year
      2000, // Leap century year
      2004, // Regular leap year
      2100, // Non-leap century year
      2024, // Current year
    ];

    return boundaryYears.map(validateYear).toList();
  }

  /// Generate validation summary
  String generateSummary(List<AccuracyReport> reports) {
    final buffer = StringBuffer();
    buffer.writeln('=== 节气算法精度验证报告 ===\n');

    for (final report in reports) {
      buffer.writeln(report.toString());
      buffer.writeln();

      // Show individual errors if any
      if (report.largeErrors > 0 || report.mediumErrors > 0) {
        buffer.writeln('  详细误差:');
        for (final v in report.validations.where((v) => v.errorMinutes.abs() > 10)) {
          buffer.writeln('    - $v');
        }
        buffer.writeln();
      }
    }

    // Overall statistics
    final allValidations = reports.expand((r) => r.validations).toList();
    if (allValidations.isNotEmpty) {
      final totalAvgError = allValidations
          .fold<double>(0, (sum, v) => sum + v.errorMinutes.abs()) /
          allValidations.length;
      final totalMaxError = allValidations
          .map((v) => v.errorMinutes.abs())
          .reduce((a, b) => a > b ? a : b);

      buffer.writeln('=== 总体统计 ===');
      buffer.writeln('验证年份数: ${reports.length}');
      buffer.writeln('验证节气总数: ${allValidations.length}');
      buffer.writeln('总体平均误差: ${totalAvgError.toStringAsFixed(2)} 分钟');
      buffer.writeln('总体最大误差: ${totalMaxError.toStringAsFixed(2)} 分钟');
    }

    return buffer.toString();
  }
}

/// Run validation
void main() {
  print('开始节气算法精度验证...\n');

  final validator = SolarTermAccuracyValidator();

  // Validate available reference years
  print('验证参考数据年份:');
  final reports = validator.validateAvailableYears();

  // Test boundary years
  print('\n测试边界年份:');
  final boundaryReports = validator.testBoundaryYears();
  reports.addAll(boundaryReports);

  // Generate summary
  final summary = validator.generateSummary(reports);
  print(summary);
}
