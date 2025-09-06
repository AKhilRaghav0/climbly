import 'package:flutter/material.dart';

class AdvisorChatView extends StatelessWidget {
  const AdvisorChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('advisor chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                _ChatBubble(text: 'Welcome! Tell me your goals.'),
                _ChatBubble(text: 'We can draft a learning plan.'),
              ],
            ),
          ),
          const _ChatComposer(),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  const _ChatBubble({required this.text});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text),
      ),
    );
  }
}

class _ChatComposer extends StatelessWidget {
  const _ChatComposer();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            const Expanded(child: TextField(decoration: InputDecoration(hintText: 'Type a message'))),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () {}, child: const Text('Send')),
          ],
        ),
      ),
    );
  }
}



