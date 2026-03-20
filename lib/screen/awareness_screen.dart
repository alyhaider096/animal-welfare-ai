import 'package:flutter/material.dart';
import 'ai_chat_screen.dart';

class AwarenessScreen extends StatelessWidget {
  const AwarenessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Awareness & Welfare"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Animal Welfare Basics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _bullet("Do not abuse or neglect animals"),
            _bullet("Support TNVR programs"),
            _bullet("Help injured street animals"),
            _bullet("Spread awareness in community"),

            const Spacer(),

            // 🤖 AI WELFARE ASSISTANT
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.smart_toy),
              label: const Text("Ask AI about Animal Welfare"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AIChatScreen(
                      initialPrompt:
                      "Explain animal welfare, common mistakes people make, "
                          "and how to care for street animals responsibly.",
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

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
