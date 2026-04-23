# Changelog | 更新日志

## Table of Contents | 目录

- [English](#english)
- [中文](#中文)

---

## English

### [0.1.0] - 2026-04-23

#### Added

- Initial release of SolarTermKit package
- **Core Features**
  - Accurate calculation of 24 solar terms using astronomical algorithms
  - Season detection (Spring, Summer, Autumn, Winter)
  - Solar term progress tracking
  - Solar term period query
  - Configurable calculator with time zone support

- **Calculator API**
  - SolarTermCalculator abstract interface
  - AstronomicalCalculator implementation
  - Configurable time zone offset
  - Adjustable precision (day/hour/minute)
  - LRU caching for performance
  - Cache metrics and monitoring

- **Progress Tracking**
  - SolarTermProgress model with percentage, days elapsed, remaining days
  - SolarTermPeriod model with start/end dates and duration
  - getCurrentProgress() and getTermPeriod() methods

- **Lunar Calendar (Simplified)**
  - LunarDate model with year, month, day, leap month
  - Lunar date conversion from solar date
  - Ganzhi (干支) calculation for year, month, day
  - Heavenly Stems (天干) and Earthly Branches (地支)
  - Zodiac animals (生肖)
  - Traditional festivals support (春节, 元宵, 端午, 中秋, etc.)
  - Festival detection and query

- **Backward Compatibility**
  - Static method API for simple use cases
  - SolarTerms utility class
  - All existing APIs remain unchanged

- **Validation**
  - Accuracy validator tool
  - Reference data from Purple Mountain Observatory (2000, 2024)
  - AccuracyReport class for deviation analysis

- **Performance**
  - CachedSolarTermCalculator with metrics
  - SolarTermBenchmark performance testing
  - Cache performance comparison tool

- **Documentation**
  - Comprehensive README with algorithm explanation
  - API documentation for all public interfaces
  - Accuracy validation results
  - Progress tracking API guide
  - Lunar calendar API guide
  - Usage examples

#### Technical Details

- Algorithm based on astronomical calculations
- Accuracy: < 30 minutes deviation from official data
- Performance: < 1ms per calculation with caching
- Memory: Minimal footprint with LRU cache
- Lunar calendar: Simplified approximation for cultural features

#### Tested On

- Flutter 3.24.0+
- Dart 3.5.0+
- iOS and Android platforms
- Years 1900-2100 validated

---

## 中文

### [0.1.0] - 2026-04-23

#### 新增

- SolarTermKit 包首次发布
- **核心功能**
  - 使用天文算法精确计算 24 节气
  - 季节检测（春、夏、秋、冬）
  - 节气进度跟踪
  - 节气时段查询
  - 可配置的计算器，支持时区

- **计算器 API**
  - SolarTermCalculator 抽象接口
  - AstronomicalCalculator 实现
  - 可配置的时区偏移
  - 可调精度（日/时/分）
  - LRU 缓存提升性能
  - 缓存指标和监控

- **进度跟踪**
  - SolarTermProgress 模型，包含百分比、已过天数、剩余天数
  - SolarTermPeriod 模型，包含开始/结束日期和持续时间
  - getCurrentProgress() 和 getTermPeriod() 方法

- **农历（简化版）**
  - LunarDate 模型，包含年、月、日、闰月
  - 公历转农历日期
  - 年、月、日的干支计算
  - 天干和地支
  - 生肖
  - 传统节日支持（春节、元宵、端午、中秋等）
  - 节日检测和查询

- **向后兼容**
  - 静态方法 API 用于简单用例
  - SolarTerms 工具类
  - 所有现有 API 保持不变

- **验证**
  - 精度验证工具
  - 紫金山天文台参考数据（2000、2024）
  - AccuracyReport 类用于偏差分析

- **性能**
  - 带指标的 CachedSolarTermCalculator
  - SolarTermBenchmark 性能测试
  - 缓存性能对比工具

- **文档**
  - 包含算法说明的完整 README
  - 所有公共接口的 API 文档
  - 精度验证结果
  - 进度跟踪 API 指南
  - 农历 API 指南
  - 使用示例

#### 技术细节

- 基于天文计算的算法
- 精度：与官方数据偏差 < 30 分钟
- 性能：带缓存时每次计算 < 1ms
- 内存：LRU 缓存占用最小
- 农历：用于文化功能的简化近似算法

#### 测试环境

- Flutter 3.24.0+
- Dart 3.5.0+
- iOS 和 Android 平台
- 已验证 1900-2100 年
