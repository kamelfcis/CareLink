class ChronicConditionModel {
  final String id;
  final String patientId;
  final String name;
  final String? notes;
  final DateTime createdAt;

  ChronicConditionModel({
    required this.id,
    required this.patientId,
    required this.name,
    this.notes,
    required this.createdAt,
  });

  factory ChronicConditionModel.fromMap(Map<String, dynamic> map) {
    return ChronicConditionModel(
      id: map['id'] as String,
      patientId: map['patient_id'] as String,
      name: map['name'] as String,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'name': name,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}