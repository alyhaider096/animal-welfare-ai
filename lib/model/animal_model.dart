import 'case_model.dart';

class AnimalModel {
  final String id;
  final String imageUrl;
  final String description;
  final double latitude;
  final double longitude;

  final String reporterName;
  final String reporterPhone;
  final String status;
  final String urgentLevel;
  final DateTime createdAt;

  AnimalModel({
    required this.id,
    required this.imageUrl,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.reporterName,
    required this.reporterPhone,
    required this.status,
    required this.urgentLevel,
    required this.createdAt,
  });

  /// 🔥 THIS FIXES YOUR ERROR
  factory AnimalModel.fromCase(CaseModel c) {
    return AnimalModel(
      id: c.caseId,
      imageUrl: c.imageUrl,
      description: c.description,
      latitude: c.latitude,
      longitude: c.longitude,
      reporterName: c.reporterName,
      reporterPhone: c.reporterPhone,
      status: c.status,
      urgentLevel: c.urgentLevel,
      createdAt: c.createdAt,
    );
  }
}
