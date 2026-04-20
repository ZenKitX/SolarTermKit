# SolarTermKit API 参考文档

本文档提供 SolarTermKit 的完整 API 参考。

## 目录

- [SolarTerms](#solarterms)
- [SeasonService](#seasonservice)
- [SolarTerm](#solarterm)
- [Season](#season)
- [ColorScheme](#colorscheme)

---

## SolarTerms

节气计算工具类。

### 静态属性

```dart
static final List<SolarTerm> all
```

获取所有 24 个节气。

**返回:** `List<SolarTerm>`

### 静态方法

#### getCurrentSolarTerm

获取当前时间的节气。

```dart
static SolarTerm getCurrentSolarTerm([DateTime? date])
```

**参数:**
- `date`: 日期（可选，默认为当前时间）

**返回:** `SolarTerm`

#### getCurrentSeason

获取当前时间的季节。

```dart
static Season getCurrentSeason([DateTime? date])
```

**参数:**
- `date`: 日期（可选，默认为当前时间）

**返回:** `Season`

#### getSolarTermTime

计算指定年份和节气的时间。

```dart
static DateTime getSolarTermTime(int year, int solarTermIndex)
```

**参数:**
- `year`: 年份
- `solarTermIndex`: 节气索引（0-23）

**返回:** `DateTime`

#### getSolarTermByName

根据名称获取节气。

```dart
static SolarTerm? getSolarTermByName(String name)
```

**参数:**
- `name`: 节气名称

**返回:** `SolarTerm?`

---

## SeasonService

季节服务类。

### 静态方法

#### getSeasonColorScheme

获取季节颜色方案。

```dart
static ColorScheme getSeasonColorScheme(Season season)
```

**参数:**
- `season`: 季节

**返回:** `ColorScheme`

---

## SolarTerm

节气模型。

### 构造函数

```dart
SolarTerm({
  required String name,
  required int index,
  required String description,
})
```

**参数:**
- `name`: 节气名称（必需）
- `index`: 索引（0-23）（必需）
- `description`: 描述（必需）

### 属性

```dart
String name        // 节气名称
int index          // 索引（0-23，0=立春，23=大寒）
String description // 描述
```

---

## Season

季节枚举。

### 枚举值

```dart
enum Season {
  spring,  // 春
  summer,  // 夏
  autumn,  // 秋
  winter,  // 冬
}
```

### 属性

```dart
String name         // 季节名称
ColorScheme colorScheme // 季节颜色方案
```

---

## ColorScheme

颜色方案模型。

### 构造函数

```dart
ColorScheme({
  required int primaryColor,
  required int secondaryColor,
  required int backgroundColor,
  required int textColor,
})
```

**参数:**
- `primaryColor`: 主色调（必需，ARGB 格式）
- `secondaryColor`: 次色调（必需，ARGB 格式）
- `backgroundColor`: 背景色（必需，ARGB 格式）
- `textColor`: 文本色（必需，ARGB 格式）

### 属性

```dart
int primaryColor     // 主色调
int secondaryColor   // 次色调
int backgroundColor  // 背景色
int textColor        // 文本色
```
