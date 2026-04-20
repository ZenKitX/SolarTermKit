import 'package:flutter/material.dart';
import 'package:SolarTermKit/SolarTermKit.dart';

void main() {
  runApp(const SolarTermApp());
}

class SolarTermApp extends StatelessWidget {
  const SolarTermApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SolarTermKit Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SolarTermKit Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentSolarTerm(),
            const SizedBox(height: 24),
            _buildSeasonInfo(),
            const SizedBox(height: 24),
            _buildAllSolarTerms(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentSolarTerm() {
    final currentTerm = SolarTerms.getCurrentSolarTerm();
    final season = SolarTerms.getCurrentSeason();

    return Card(
      color: currentTerm.color?.withOpacity(0.1) ?? Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: currentTerm.color),
                const SizedBox(width: 8),
                Text(
                  'Current Solar Term',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              currentTerm.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: currentTerm.color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              currentTerm.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Season: ${season.toString().split('.').last}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (currentTerm.date != null)
              Text(
                'Date: ${currentTerm.date!.toLocal()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonInfo() {
    final season = SolarTerms.getCurrentSeason();
    final colorScheme = SeasonService.getSeasonColorScheme(season);

    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.palette, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Season Color Scheme',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Primary: ${colorScheme.primary}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Secondary: ${colorScheme.secondary}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllSolarTerms() {
    final allTerms = SolarTerms.all;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.list, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'All 24 Solar Terms',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...allTerms.map((term) {
              return ListTile(
                leading: Icon(
                  Icons.circle,
                  color: term.color ?? Colors.grey,
                  size: 12,
                ),
                title: Text(term.name),
                subtitle: Text(term.season.toString().split('.').last),
                trailing: Text(
                  term.date != null
                      ? '${term.date!.month}/${term.date!.day}'
                      : '-',
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
