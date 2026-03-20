import 'package:flutter/material.dart';

class VaccinationScreen extends StatelessWidget {
  const VaccinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vaccination"),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Vaccination protects animals from serious diseases.\n\n"
              "• Puppies & kittens need early vaccines\n"
              "• Booster doses are important\n"
              "• Consult a certified veterinarian\n",
        ),
      ),
    );
  }
}
