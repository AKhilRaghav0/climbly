import 'package:flutter/material.dart';

class LearningPlanView extends StatelessWidget {
  const LearningPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('learning plan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Weekly plan'),
                  SizedBox(height: 8),
                  _WireListItem(text: 'Watch 2 lectures'),
                  _WireListItem(text: 'Do 1 coding exercise'),
                  _WireListItem(text: 'Build a small demo'),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Resources'),
                  SizedBox(height: 8),
                  _WireListItem(text: 'Course links'),
                  _WireListItem(text: 'Docs & references'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WireListItem extends StatelessWidget {
  final String text;
  const _WireListItem({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}



