import 'package:flutter/material.dart';

class GroomingScreen extends StatelessWidget {
  const GroomingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grooming"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Why Grooming Matters",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Regular grooming helps prevent infections, parasites, "
                  "and improves animal comfort and health.",
            ),
            SizedBox(height: 20),

            Text(
              "Basic Grooming Tips",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text("• Brush fur regularly"),
            Text("• Check ears and paws"),
            Text("• Trim nails carefully"),
            Text("• Bathe only when needed"),
            Text("• Use pet-safe products"),
          ],
        ),
      ),
    );
  }
}
