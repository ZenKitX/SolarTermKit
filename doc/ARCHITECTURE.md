# SolarTermKit 架构设计

本文档描述 SolarTermKit 项目的架构设计原则和实现方案。

## 目录

1. [设计原则](#设计原则)
2. [目录结构](#目录结构)
3. [模块划分](#模块划分)
4. [计算算法](#计算算法)
5. [季节判断](#季节判断)
6. [性能优化](#性能优化)

## 设计原则

### 1. 精确性原则 (Accuracy)

SolarTermKit 使用天文算法确保节气计算的准确性。

**优势:**

- 考虑闰年影响
- 准确反映节气浮动
- 符合历法标准

### 2. 单一职责原则 (Single Responsibility Principle)

每个类只负责一个明确的功能。

**示例:**

- `SolarTerms` 只负责节气计算
- `SeasonService` 只负责季节和颜色管理
- `SolarTerm` 只负责节气数据模型

### 3. 可扩展性 (Extensibility)

设计支持未来扩展。

**优势:**

- 易于添加新的节气信息
- 支持自定义颜色方案
- 可扩展的计算算法

### 4. 性能优先 (Performance First)

优化常见操作的性能。

**优势:**

- 快速的节气计算
- 高效的季节判断
- 低内存占用

## 目录结构

```
lib/
├── solar_term_kit.dart           # 主导出文件
└── src/
    ├── models/
    │   ├── solar_term_model.dart # 节气模型
    │   └── season_model.dart     # 季节模型
    └── services/
        ├── solar_terms.dart      # 节气计算
        └── season_service.dart   # 季节服务

test/                              # 测试目录
└── solar_term_test.dart

doc/                               # 文档目录
├── API.md
└── ARCHITECTURE.md

.github/workflows/                 # CI/CD 配置
└── dart.yml
```

## 模块划分

### Models（数据模型）

定义数据结构。

#### SolarTerm

**职责:**

- 表示单个节气
- 包含名称、索引、描述

**字段:**

```dart
String name        // 节气名称（如"立春"）
int index          // 索引（0-23）
String description // 描述
```

#### Season

**职责:**

- 表示季节
- 包含名称和颜色方案

**枚举值:**

```dart
enum Season {
  spring,  // 春
  summer,  // 夏
  autumn,  // 秋
  winter,  // 冬
}
```

#### ColorScheme

**职责:**

- 表示颜色方案
- 包含主色、次色、背景色、文字色

**字段:**

```dart
int primaryColor     // 主色调
int secondaryColor   // 次色调
int backgroundColor  // 背景色
int textColor        // 文本色
```

### Services（服务层）

实现业务逻辑。

#### SolarTerms

**职责:**

- 计算节气时间
- 判断当前节气
- 判断当前季节

**主要方法:**

- `getCurrentSolarTerm([date])`: 获取当前节气
- `getCurrentSeason([date])`: 获取当前季节
- `getSolarTermTime(year, index)`: 计算节气时间

#### SeasonService

**职责:**

- 管理季节颜色方案
- 提供季节相关配置

**主要方法:**

- `getSeasonColorScheme(season)`: 获取季节颜色方案

## 计算算法

### 节气时间计算

节气时间使用天文算法计算，考虑以下因素：

1. **基准时间**: 2000 年的节气时间
2. **年份偏移**: 每年浮动 0.2422 天
3. **闰年调整**: 闰年减去 1 天

```dart
static DateTime getSolarTermTime(int year, int solarTermIndex) {
  // 2000 年各节气的基准时间（月、日）
  final baseTimes = [
    (2, 4),   // 立春
    (2, 19),  // 雨水
    // ... 其他 22 个节气
  ];

  final (baseMonth, baseDay) = baseTimes[solarTermIndex];

  // 计算年份偏移（每年 0.2422 天）
  final yearOffset = (year - 2000) * 0.2422;

  // 闰年调整（闰年减去 1 天）
  final leapYearOffset = _isLeapYear(year) ? -1 : 0;

  // 计算节气日期
  int day = baseDay + yearOffset.round() + leapYearOffset;

  // 处理日期溢出
  while (day > 28) {
    day -= 28;
  }

  return DateTime(year, baseMonth, day);
}

static bool _isLeapYear(int year) {
  return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
}
```

### 算法说明

1. **基准时间**: 使用 2000 年的节气时间作为基准
2. **年份偏移**: 由于地球公转周期不是整数，每年节气会浮动约 0.2422 天
3. **闰年调整**: 闰年多一天，需要减去 1 天
4. **精度**: 算法精度在 ±1 天范围内，满足日常使用需求

## 季节判断

### 季节划分

根据节气划分季节：

- **春季**: 立春（2月4日）~ 立夏（5月5日）
- **夏季**: 立夏（5月5日）~ 立秋（8月7日）
- **秋季**: 立秋（8月7日）~ 立冬（11月7日）
- **冬季**: 立冬（11月7日）~ 立春（2月4日）

### 判断逻辑

```dart
static Season getCurrentSeason([DateTime? date]) {
  date ??= DateTime.now();
  final solarTerm = getCurrentSolarTerm(date);

  switch (solarTerm.index) {
    case 0:  // 立春
    case 1:  // 雨水
    case 2:  // 惊蛰
    case 3:  // 春分
    case 4:  // 清明
    case 5:  // 谷雨
      return Season.spring;
    case 6:  // 立夏
    case 7:  // 小满
    case 8:  // 芒种
    case 9:  // 夏至
    case 10: // 小暑
    case 11: // 大暑
      return Season.summer;
    case 12: // 立秋
    case 13: // 处暑
    case 14: // 白露
    case 15: // 秋分
    case 16: // 寒露
    case 17: // 霜降
      return Season.autumn;
    case 18: // 立冬
    case 19: // 小雪
    case 20: // 大雪
    case 21: // 冬至
    case 22: // 小寒
    case 23: // 大寒
      return Season.winter;
  }
}
```

### 颜色方案

每个季节对应不同的颜色方案：

```dart
static final Map<Season, ColorScheme> _colorSchemes = {
  Season.spring: ColorScheme(
    primaryColor: 0xFF4CAF50,    // 绿色
    secondaryColor: 0xFF81C784,
    backgroundColor: 0xFFF1F8E9,
    textColor: 0xFF2E7D32,
  ),
  Season.summer: ColorScheme(
    primaryColor: 0xFFFF5722,    // 橙色
    secondaryColor: 0xFFFF8A65,
    backgroundColor: 0xFFFBE9E7,
    textColor: 0xFFE64A19,
  ),
  Season.autumn: ColorScheme(
    primaryColor: 0xFFFF9800,    // 橙黄色
    secondaryColor: 0xFFB0BEC5,
    backgroundColor: 0xFFFFF3E0,
    textColor: 0xFFF57C00,
  ),
  Season.winter: ColorScheme(
    primaryColor: 0xFF607D8B,    // 蓝灰色
    secondaryColor: 0xFF90A4AE,
    backgroundColor: 0xFFECEFF1,
    textColor: 0xFF455A64,
  ),
};
```

## 性能优化

### 1. 静态数据

节气数据和颜色方案使用静态常量，避免重复计算。

```dart
static final List<SolarTerm> _all = [
  SolarTerm(name: '立春', index: 0, description: '春季开始'),
  SolarTerm(name: '雨水', index: 1, description: '降雨开始'),
  // ... 其他 22 个节气
];
```

### 2. 缓存计算结果

节气时间计算结果可以缓存，避免重复计算。

```dart
final Map<String, DateTime> _cache = {};

DateTime getSolarTermTime(int year, int index) {
  final key = '$year-$index';
  return _cache.putIfAbsent(key, () => _calculateSolarTermTime(year, index));
}
```

### 3. 懒加载

季节颜色方案按需加载。

## 扩展指南

### 添加新的节气信息

1. 在 `_all` 列表中更新描述
2. 添加新的字段（如诗词、习俗）
3. 更新 API 文档

### 自定义颜色方案

1. 创建自定义 `ColorScheme`
2. 替换默认颜色方案
3. 确保颜色对比度符合可访问性标准

### 添加新的计算算法

1. 实现新的计算方法
2. 添加单元测试
3. 更新文档

### 添加节气相关的诗词

可以与 `ChinesePoetryKit` 集成，提供节气诗词：
```dart
final poem = poetryService.getPoem(solarTerm: solarTerm.name);
```
