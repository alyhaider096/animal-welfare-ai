import 'package:flutter/material.dart';
import '../service/firestore_service.dart';
import '../model/case_model.dart';
import 'case_detail_screen.dart';

class AnimalsScreen extends StatelessWidget {
  const AnimalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text("Animals Near You 🐾")),
      body: FutureBuilder<List<CaseModel>>(
        future: service.getCases(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final cases = snap.data ?? [];
          if (cases.isEmpty) {
            return const Center(child: Text("No cases reported yet"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cases.length,
            itemBuilder: (_, i) {
              final c = cases[i];

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CaseDetailScreen(caseModel: c),
                  ),
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 400 + i * 120),
                  builder: (_, v, child) => Transform.translate(
                    offset: Offset(0, 30 * (1 - v)),
                    child: Opacity(opacity: v, child: child),
                  ),
                  child: _CaseCard(caseModel: c),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CaseCard extends StatelessWidget {
  final CaseModel caseModel;
  const _CaseCard({required this.caseModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 14)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            child: Image.network(
              caseModel.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(
              caseModel.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
