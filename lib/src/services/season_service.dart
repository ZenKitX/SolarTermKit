import 'package:flutter/material.dart';
import '../models/solar_term_model.dart';

/// Season service
class SeasonService {
  SeasonService();

  /// Get current season
  static Season getCurrentSeason() {
    final now = DateTime.now();
    return _getSeasonForMonth(now.month);
  }

  /// Get season for a specific date
  static Season getSeasonForDate(DateTime date) {
    return _getSeasonForMonth(date.month);
  }

  /// Get season for month
  static Season _getSeasonForMonth(int month) {
    if (month >= 3 && month <= 5) {
      return Season.spring;
    } else if (month >= 6 && month <= 8) {
      return Season.summer;
    } else if (month >= 9 && month <= 11) {
      return Season.autumn;
    } else {
      return Season.winter;
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
  static Color getSeasonColor(Season season) {
    switch (season) {
      case Season.spring:
        return Colors.green.shade300;
      case Season.summer:
        return Colors.red.shade300;
      case Season.autumn:
        return Colors.orange.shade300;
      case Season.winter:
        return Colors.blue.shade300;
    }
  }

  /// Get season color code (int)
  static int getSeasonColorCode(Season season) {
    switch (season) {
      case Season.spring:
        return 0xFF81C784; // Green 300
      case Season.summer:
        return 0xFFE57373; // Red 300
      case Season.autumn:
        return 0xFFFFB74D; // Orange 300
      case Season.winter:
        return 0xFF64B5F6; // Blue 300
    }
  }

  /// Get season description
  static String getSeasonDescription(Season season) {
    switch (season) {
      case Season.spring:
        return '春回大地，万物复苏';
      case Season.summer:
        return '夏日炎炎，绿树成荫';
      case Season.autumn:
        return '秋高气爽，硕果累累';
      case Season.winter:
        return '冬雪皑皑，银装素裹';
    }
  }

  /// Get season color scheme
  static ColorScheme getSeasonColorScheme(Season season) {
    switch (season) {
      case Season.spring:
        return ColorScheme.light(
          primary: Colors.green.shade700,
          secondary: Colors.lightGreen.shade700,
        );
      case Season.summer:
        return ColorScheme.light(
          primary: Colors.red.shade700,
          secondary: Colors.orange.shade700,
        );
      case Season.autumn:
        return ColorScheme.light(
          primary: Colors.orange.shade700,
          secondary: Colors.brown.shade700,
        );
      case Season.winter:
        return ColorScheme.light(
          primary: Colors.blue.shade700,
          secondary: Colors.cyan.shade700,
        );
    }
  }
}
