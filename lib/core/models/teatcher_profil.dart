class TeacherProfile {
  final int id;
  final int userId;
  final int? schoolId;
  final String institutionName;
  final List<dynamic> subjects;
  final String highestDegree;
  final String? degreeDocument;
  final int yearsOfExperience;
  final List<dynamic> teachingType;
  final String? cv;
  final Map<String, dynamic> availability;
  final String? professionalReferences;
  final List<dynamic> continuousEducation;
  final String qualifications;
  final String? professionalLicense;
  final List<dynamic> expertiseAreas;
  final String? teachingPhilosophy;
  final double? hourlyRate;
  final bool isApproved;
  final DateTime? approvalDate;

  TeacherProfile({
    required this.id,
    required this.userId,
    this.schoolId,
    required this.institutionName,
    required this.subjects,
    required this.highestDegree,
    this.degreeDocument,
    required this.yearsOfExperience,
    required this.teachingType,
    this.cv,
    this.availability = const {},
    this.professionalReferences,
    this.continuousEducation = const [],
    required this.qualifications,
    this.professionalLicense,
    this.expertiseAreas = const [],
    this.teachingPhilosophy,
    this.hourlyRate,
    this.isApproved = false,
    this.approvalDate,
  });

  factory TeacherProfile.fromJson(Map<String, dynamic> json) {
    return TeacherProfile(
      id: json['id'] ?? 0,
      userId: json['user'] ?? 0,
      schoolId: json['school'],
      institutionName: json['institution_name'] ?? '',
      subjects: json['subjects'] ?? [],
      highestDegree: json['highest_degree'] ?? '',
      degreeDocument: json['degree_document'],
      yearsOfExperience: json['years_of_experience'] ?? 0,
      teachingType: json['teaching_type'] ?? [],
      cv: json['cv'],
      availability: Map<String, dynamic>.from(json['availability'] ?? {}),
      professionalReferences: json['professional_references'],
      continuousEducation: json['continuous_education'] ?? [],
      qualifications: json['qualifications'] ?? '',
      professionalLicense: json['professional_license'],
      expertiseAreas: json['expertise_areas'] ?? [],
      teachingPhilosophy: json['teaching_philosophy'],
      hourlyRate: json['hourly_rate']?.toDouble(),
      isApproved: json['is_approved'] ?? false,
      approvalDate: json['approval_date'] != null 
          ? DateTime.parse(json['approval_date']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'school_id': schoolId,
      'institution_name': institutionName,
      'subjects': subjects,
      'highest_degree': highestDegree,
      'degree_document': degreeDocument,
      'years_of_experience': yearsOfExperience,
      'teaching_type': teachingType,
      'cv': cv,
      'availability': availability,
      'professional_references': professionalReferences,
      'continuous_education': continuousEducation,
      'qualifications': qualifications,
      'professional_license': professionalLicense,
      'expertise_areas': expertiseAreas,
      'teaching_philosophy': teachingPhilosophy,
      'hourly_rate': hourlyRate,
      'is_approved': isApproved,
      'approval_date': approvalDate?.toIso8601String(),
    };
  }
}