import 'package:cloud_firestore/cloud_firestore.dart';

class CaseModel {
  final String caseId;
  final String imageUrl;
  final String description;
  final double latitude;
  final double longitude;

  final String reporterName;
  final String reporterPhone;
  final String reporterType;

  final String status; // pending / rescued / closed
  final String urgentLevel; // low / normal / high
  final DateTime createdAt;

  CaseModel({
    required this.caseId,
    required this.imageUrl,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.reporterName,
    required this.reporterPhone,
    required this.reporterType,
    required this.status,
    required this.urgentLevel,
    required this.createdAt,
  });

  factory CaseModel.fromMap(String id, Map<String, dynamic> data) {
    return CaseModel(
      caseId: id,
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      reporterName: data['reporterName'] ?? 'Anonymous',
      reporterPhone: data['reporterPhone'] ?? 'N/A',
      reporterType: data['reporterType'] ?? 'user',
      status: data['status'] ?? 'pending',
      urgentLevel: data['urgentLevel'] ?? 'normal',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'reporterName': reporterName,
      'reporterPhone': reporterPhone,
      'reporterType': reporterType,
      'status': status,
      'urgentLevel': urgentLevel,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
