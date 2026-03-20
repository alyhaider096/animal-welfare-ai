import 'package:flutter/material.dart';
import 'ai_chat_screen.dart';

class PetActionScreen extends StatelessWidget {
  final String issue;

  const PetActionScreen({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(issue),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Immediate Actions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _bullet("Keep the animal calm and in a safe place"),
            _bullet("Do not give any human medicine"),
            _bullet("Provide clean drinking water"),
            _bullet("Contact the nearest vet or NGO"),

            const Spacer(),

            // 🤖 AI ASSISTANT BUTTON
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.smart_toy),
              label: const Text("Ask AI Assistant"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AIChatScreen(
                      initialPrompt:
                      "An animal is facing this issue: $issue. "
                          "Give safe and immediate care advice.",
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 BULLET ITEM WIDGET
  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            size: 18,
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
