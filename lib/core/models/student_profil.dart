class StudentProfile {
  final int id;
  final int userId;
  final int? schoolId;
  final String? institutionName;
  final String currentLevel;
  final String? major;
  final String? academicYear;
  final String? studentId;
  final bool scholarship;
  final String? scholarshipType;
  final List<dynamic> housingNeeds;
  final String? internshipSearch;
  final List<dynamic> computerSkills;
  final String? extracurricularActivities;
  final List<dynamic> interests;
  final double? averageGrade;

  StudentProfile({
    required this.id,
    required this.userId,
    this.schoolId,
    this.institutionName,
    required this.currentLevel,
    this.major,
    this.academicYear,
    this.studentId,
    this.scholarship = false,
    this.scholarshipType,
    this.housingNeeds = const [],
    this.internshipSearch,
    this.computerSkills = const [],
    this.extracurricularActivities,
    this.interests = const [],
    this.averageGrade,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'] as int,
      userId: json['user'] as int,
      schoolId: json['school_id'],
      institutionName: json['institution_name'],
      currentLevel: json['current_level'] as String? ?? '',
      major: json['major'],
      academicYear: json['academic_year'],
      studentId: json['student_id'],
      scholarship: json['scholarship'] ?? false,
      scholarshipType: json['scholarship_type'],
      housingNeeds: json['housing_needs'] ?? [],
      internshipSearch: json['internship_search'],
      computerSkills: json['computer_skills'] ?? [],
      extracurricularActivities: json['extracurricular_activities'],
      interests: json['interests'] ?? [],
      averageGrade: json['average_grade']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'school_id': schoolId,
      'institution_name': institutionName,
      'current_level': currentLevel,
      'major': major,
      'academic_year': academicYear,
      'student_id': studentId,
      'scholarship': scholarship,
      'scholarship_type': scholarshipType,
      'housing_needs': housingNeeds,
      'internship_search': internshipSearch,
      'computer_skills': computerSkills,
      'extracurricular_activities': extracurricularActivities,
      'interests': interests,
      'average_grade': averageGrade,
    };
  }
}