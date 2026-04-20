import 'package:flutter/material.dart';

/// Solar term model
class SolarTerm {
  /// Solar term name (e.g., "立春", "雨水")
  final String name;

  /// Description of the solar term
  final String description;

  /// Date and time of the solar term
  final DateTime? date;

  /// Associated season (春, 夏, 秋, 冬)
  final String? season;

  /// Material color for the solar term
  final Color? color;

  SolarTerm({
    required this.name,
    required this.description,
    this.date,
    this.season,
    this.color,
  });

  @override
  String toString() {
    return 'SolarTerm(name: $name, season: $season)';
  }
}
