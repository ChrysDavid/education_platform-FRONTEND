class PupilProfile {
  final int id;
  final int userId;
  final String schoolName;
  final String currentLevel;
  final String? specialization;
  final String? legalGuardianName;
  final String? legalGuardianPhone;
  final String? secondGuardianName;
  final String? secondGuardianPhone;
  final bool cafeteria;
  final String? dietaryRestrictions;
  final bool schoolTransport;
  final String? transportDetails;
  final String? medicalInformation;
  final String? schoolInsurance;
  final List<dynamic> exitPermissions;
  final String? siblingsAtSchool;
  final List<dynamic> desiredActivities;

  PupilProfile({
    required this.id,
    required this.userId,
    required this.schoolName,
    required this.currentLevel,
    this.specialization,
    this.legalGuardianName,
    this.legalGuardianPhone,
    this.secondGuardianName,
    this.secondGuardianPhone,
    this.cafeteria = false,
    this.dietaryRestrictions,
    this.schoolTransport = false,
    this.transportDetails,
    this.medicalInformation,
    this.schoolInsurance,
    this.exitPermissions = const [],
    this.siblingsAtSchool,
    this.desiredActivities = const [],
  });

  factory PupilProfile.fromJson(Map<String, dynamic> json) {
    return PupilProfile(
      id: json['id'] as int,
      userId: json['user'] as int,
      schoolName: json['school_name'] as String? ?? '',
      currentLevel: json['current_level'] as String? ?? '',
      specialization: json['specialization'],
      legalGuardianName: json['legal_guardian_name'],
      legalGuardianPhone: json['legal_guardian_phone'],
      secondGuardianName: json['second_guardian_name'],
      secondGuardianPhone: json['second_guardian_phone'],
      cafeteria: json['cafeteria'] ?? false,
      dietaryRestrictions: json['dietary_restrictions'],
      schoolTransport: json['school_transport'] ?? false,
      transportDetails: json['transport_details'],
      medicalInformation: json['medical_information'],
      schoolInsurance: json['school_insurance'],
      exitPermissions: json['exit_permissions'] ?? [],
      siblingsAtSchool: json['siblings_at_school'],
      desiredActivities: json['desired_activities'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'school_name': schoolName,
      'current_level': currentLevel,
      'specialization': specialization,
      'legal_guardian_name': legalGuardianName,
      'legal_guardian_phone': legalGuardianPhone,
      'second_guardian_name': secondGuardianName,
      'second_guardian_phone': secondGuardianPhone,
      'cafeteria': cafeteria,
      'dietary_restrictions': dietaryRestrictions,
      'school_transport': schoolTransport,
      'transport_details': transportDetails,
      'medical_information': medicalInformation,
      'school_insurance': schoolInsurance,
      'exit_permissions': exitPermissions,
      'siblings_at_school': siblingsAtSchool,
      'desired_activities': desiredActivities,
    };
  }
}