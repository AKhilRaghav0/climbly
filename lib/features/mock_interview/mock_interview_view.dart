import 'package:flutter/material.dart';

class MockInterviewView extends StatelessWidget {
  const MockInterviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('mock interview')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: const [
                  _QaItem(q: 'Explain overfitting.', a: 'High variance; use regularization, more data.'),
                  _QaItem(q: 'What is gradient descent?', a: 'Optimization method minimizing loss.'),
                ],
              ),
            ),
            ElevatedButton(onPressed: () {}, child: const Text('Start session')),
          ],
        ),
      ),
    );
  }
}

class _QaItem extends StatelessWidget {
  final String q;
  final String a;
  const _QaItem({required this.q, required this.a});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Q: $q'),
            const SizedBox(height: 8),
            Text('A: $a'),
          ],
        ),
      ),
    );
  }
}



