import 'package:flutter/material.dart';

class CareerPathsView extends StatelessWidget {
  const CareerPathsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('career paths')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _WirePathCard(title: 'Data Scientist', items: ['Core skills', 'Projects', 'Salary bands']),
          _WirePathCard(title: 'ML Engineer', items: ['Core skills', 'Projects', 'Salary bands']),
          _WirePathCard(title: 'AI Product Manager', items: ['Core skills', 'Projects', 'Salary bands']),
        ],
      ),
    );
  }
}

class _WirePathCard extends StatelessWidget {
  final String title;
  final List<String> items;
  const _WirePathCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            for (final item in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(children: [
                  const Icon(Icons.circle, size: 10),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item)),
                ]),
              )
          ],
        ),
      ),
    );
  }
}



