import 'package:flutter/material.dart';
import 'package:solar_term_kit/solar_term_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SolarTermKit Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const SolarTermExamplePage(),
    );
  }
}

class SolarTermExamplePage extends StatefulWidget {
  const SolarTermExamplePage({super.key});

  @override
  State<SolarTermExamplePage> createState() => _SolarTermExamplePageState();
}

class _SolarTermExamplePageState extends State<SolarTermExamplePage> {
  DateTime _selectedDate = DateTime.now();
  SolarTerm? _currentSolarTerm;
  Season? _currentSeason;

  @override
  void initState() {
    super.initState();
    _updateSolarTermAndSeason();
  }

  void _updateSolarTermAndSeason() {
    setState(() {
      _currentSolarTerm = SolarTerms.getCurrentSolarTerm(_selectedDate);
      _currentSeason = SolarTerms.getCurrentSeason(_selectedDate);
    });
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _updateSolarTermAndSeason();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = _currentSeason != null
        ? SeasonService.getSeasonColorScheme(_currentSeason!)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SolarTermKit Example'),
        backgroundColor: colorScheme != null
            ? Color(colorScheme.primaryColor)
            : Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        color: colorScheme != null
            ? Color(colorScheme.backgroundColor)
            : null,
        child: Column(
          children: [
            _buildDateSelector(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_currentSolarTerm != null) _buildSolarTermCard(),
                    const SizedBox(height: 24),
                    if (_currentSeason != null) _buildSeasonCard(),
                    const SizedBox(height: 24),
                    _buildAllSolarTermsList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Selected Date'),
          subtitle: Text(
            '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 18),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: _selectDate,
        ),
      ),
    );
  }

  Widget _buildSolarTermCard() {
    final solarTerm = _currentSolarTerm!;
    final colorScheme = SeasonService.getSeasonColorScheme(_currentSeason!);

    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(colorScheme.primaryColor).withOpacity(0.1),
              Color(colorScheme.secondaryColor).withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.ac_unit,
                    color: Color(colorScheme.primaryColor),
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Current Solar Term',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                solarTerm.name,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Color(colorScheme.primaryColor),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                solarTerm.description,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(colorScheme.primaryColor),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Index: ${solarTerm.index}',
                  style: TextStyle(
                    color: Color(colorScheme.textColor),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeasonCard() {
    final season = _currentSeason!;
    final colorScheme = SeasonService.getSeasonColorScheme(season);

    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          color: Color(colorScheme.primaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Season',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Color(colorScheme.textColor),
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                season.name,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Color(colorScheme.textColor),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildColorSwatch('Primary', colorScheme.primaryColor),
                  const SizedBox(width: 16),
                  _buildColorSwatch('Secondary', colorScheme.secondaryColor),
                  const SizedBox(width: 16),
                  _buildColorSwatch('Background', colorScheme.backgroundColor),
                  const SizedBox(width: 16),
                  _buildColorSwatch('Text', colorScheme.textColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorSwatch(String label, int colorValue) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Color(colorValue),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildAllSolarTermsList() {
    final allSolarTerms = SolarTerms.all;
    final currentSeason = _currentSeason;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All 24 Solar Terms',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: allSolarTerms.length,
              itemBuilder: (context, index) {
                final solarTerm = allSolarTerms[index];
                final season = SolarTerms.getCurrentSeason(
                  SolarTerms.getSolarTermTime(_selectedDate.year, index),
                );
                final colorScheme = SeasonService.getSeasonColorScheme(season);
                final isCurrent = solarTerm.index == _currentSolarTerm?.index;

                return Container(
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? Color(colorScheme.primaryColor).withOpacity(0.2)
                        : Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: isCurrent
                        ? Border.all(color: Color(colorScheme.primaryColor), width: 2)
                        : null,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${index + 1}.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            solarTerm.name,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isCurrent
                                      ? Color(colorScheme.primaryColor)
                                      : null,
                                ),
                          ),
                        ],
                      ),
                      Text(
                        solarTerm.description,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
