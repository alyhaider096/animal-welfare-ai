import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/case_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ADD CASE
  Future<void> addCase(CaseModel caseData) async {
    await _db.collection('cases').doc(caseData.caseId).set(caseData.toMap());
  }

  // GET CASES
  Future<List<CaseModel>> getCases() async {
    final snapshot = await _db
        .collection('cases')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => CaseModel.fromMap(doc.id, doc.data()))
        .toList();
  }
}
