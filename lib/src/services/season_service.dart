import 'package:flutter/material.dart';

/// Season service
class SeasonService {
  /// Get current season
  static String getCurrentSeason() {
    final now = DateTime.now();
    return _getSeasonForMonth(now.month);
  }

  /// Get season for a specific date
  static String getSeasonForDate(DateTime date) {
    return _getSeasonForMonth(date.month);
  }

  /// Get season for month
  static String _getSeasonForMonth(int month) {
    if (month >= 3 && month <= 5) {
      return '春';
    } else if (month >= 6 && month <= 8) {
      return '夏';
    } else if (month >= 9 && month <= 11) {
      return '秋';
    } else {
      return '冬';
    }
  }

  /// Check if date is in spring
  static bool isSpring(DateTime date) {
    return date.month >= 3 && date.month <= 5;
  }

  /// Check if date is in summer
  static bool isSummer(DateTime date) {
    return date.month >= 6 && date.month <= 8;
  }

  /// Check if date is in autumn
  static bool isAutumn(DateTime date) {
    return date.month >= 9 && date.month <= 11;
  }

  /// Check if date is in winter
  static bool isWinter(DateTime date) {
    return date.month == 12 || date.month == 1 || date.month == 2;
  }

  /// Get season color (Material Color)
  static Color getSeasonColor(String season) {
    switch (season) {
      case '春':
        return Colors.green.shade300;
      case '夏':
        return Colors.red.shade300;
      case '秋':
        return Colors.orange.shade300;
      case '冬':
        return Colors.blue.shade300;
      default:
        return Colors.grey;
    }
  }

  /// Get season color code (int)
  static int getSeasonColorCode(String season) {
    switch (season) {
      case '春':
        return 0xFF81C784; // Green 300
      case '夏':
        return 0xFFE57373; // Red 300
      case '秋':
        return 0xFFFFB74D; // Orange 300
      case '冬':
        return 0xFF64B5F6; // Blue 300
      default:
        return 0xFF9E9E9E; // Grey 500
    }
  }

  /// Get season description
  static String getSeasonDescription(String season) {
    switch (season) {
      case '春':
        return '春回大地，万物复苏';
      case '夏':
        return '夏日炎炎，绿树成荫';
      case '秋':
        return '秋高气爽，硕果累累';
      case '冬':
        return '冬雪皑皑，银装素裹';
      default:
        return '四季轮转，岁月如歌';
    }
  }
}
