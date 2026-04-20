import 'package:flutter/material.dart';

/// Season enum
enum Season {
  spring,
  summer,
  autumn,
  winter,
}

/// Solar term model
class SolarTerm {
  SolarTerm({
    required this.name,
    required this.description,
    this.date,
    this.season,
    this.color,
  });

  /// Solar term name (e.g., "立春", "雨水")
  final String name;

  /// Description of the solar term
  final String description;

  /// Date and time of the solar term
  final DateTime? date;

  /// Associated season (春, 夏, 秋, 冬)
  final Season? season;

  /// Material color for the solar term
  final Color? color;

  /// Index of the solar term (0-23)
  int get index => _names.indexOf(name);

  @override
  String toString() {
    return 'SolarTerm(name: $name, season: $season)';
  }

  /// Solar term names
  static const List<String> _names = [
    '立春', '雨水', '惊蛰', '春分', '清明', '谷雨',
    '立夏', '小满', '芒种', '夏至', '小暑', '大暑',
    '立秋', '处暑', '白露', '秋分', '寒露', '霜降',
    '立冬', '小雪', '大雪', '冬至', '小寒', '大寒',
  ];

  /// Solar term descriptions
  static const List<String> _descriptions = [
    '立春，二十四节气之首，春季开始',
    '雨水，降雨开始，雨量渐增',
    '惊蛰，春雷乍动，惊醒蛰伏昆虫',
    '春分，昼夜平分，春色正中分',
    '清明，气清景明，万物皆显',
    '谷雨，雨生百谷，作物新种',
    '立夏，夏季开始，万物繁茂',
    '小满，麦粒渐满，丰收在望',
    '芒种，芒种忙种，及时播种',
    '夏至，夏季最热，白昼最长',
    '小暑，小热未至，暑气渐长',
    '大暑，大暑炎热，三伏天至',
    '立秋，秋季开始，凉风至',
    '处暑，暑气结束，秋高气爽',
    '白露，露凝而白，天气转凉',
    '秋分，昼夜平分，秋色正中分',
    '寒露，露气寒冷，凝结成霜',
    '霜降，霜降大地，草木凋零',
    '立冬，冬季开始，万物收藏',
    '小雪，小雪纷飞，天气寒冷',
    '大雪，大雪纷飞，严寒降临',
    '冬至，冬季最冷，白昼最短',
    '小寒，小寒未至，寒气渐长',
    '大寒，大寒冷，全年最冷',
  ];
}
