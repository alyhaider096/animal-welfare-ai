import 'package:flutter/material.dart';
import 'pet_action_screen.dart';

class PetHealthScreen extends StatelessWidget {
  const PetHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final issues = [
      "Injury / Bleeding",
      "Not eating",
      "Limping",
      "Skin infection",
      "Vomiting / Diarrhea",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Health Issues")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: issues.length,
        itemBuilder: (_, i) => Card(
          child: ListTile(
            title: Text(issues[i]),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    PetActionScreen(issue: issues[i]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
