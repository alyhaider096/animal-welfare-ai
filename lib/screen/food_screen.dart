import 'package:flutter/material.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Guide"),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Healthy food keeps animals active and strong.\n\n"
              "Allowed:\n"
              "• Cooked meat\n"
              "• Rice\n"
              "• Fresh water\n\n"
              "Avoid:\n"
              "• Chocolate\n"
              "• Spicy food\n"
              "• Bones\n",
        ),
      ),
    );
  }
}
