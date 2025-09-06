import 'package:flutter/material.dart';

class SkillMapperView extends StatelessWidget {
  const SkillMapperView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('skill mapper')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(8, (i) => const _WireTag(label: 'Skill')),
            ),
            const SizedBox(height: 16),
            Row(children: const [
              Expanded(child: _WireTextField(label: 'Add skill')),
              SizedBox(width: 8),
            ]),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gaps & Recommendations', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      const _WireListItem(text: 'Learn X to reach Y role'),
                      const _WireListItem(text: 'Practice Z with projects'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WireTag extends StatelessWidget {
  final String label;
  const _WireTag({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}

class _WireTextField extends StatelessWidget {
  final String label;
  const _WireTextField({required this.label});
  @override
  Widget build(BuildContext context) {
    return TextField(decoration: InputDecoration(labelText: label));
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



