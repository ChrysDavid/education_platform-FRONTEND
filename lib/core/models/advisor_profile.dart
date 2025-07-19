class AdvisorProfile {
  final int id;
  final int userId;
  final String organization;
  final String specialization;
  final int yearsOfExperience;
  final List<dynamic> expertiseAreas;
  final String? professionalLicense;
  final List<dynamic> certifications;
  final List<dynamic> certificationDocuments;
  final List<dynamic> geographicalAreas;
  final Map<String, dynamic> rates;
  final String? portfolio;
  final String? portfolioLink;
  final List<dynamic> publications;
  final Map<String, dynamic> availability;

  AdvisorProfile({
    required this.id,
    required this.userId,
    required this.organization,
    required this.specialization,
    this.yearsOfExperience = 0,
    this.expertiseAreas = const [],
    this.professionalLicense,
    this.certifications = const [],
    this.certificationDocuments = const [],
    this.geographicalAreas = const [],
    this.rates = const {},
    this.portfolio,
    this.portfolioLink,
    this.publications = const [],
    this.availability = const {},
  });

  factory AdvisorProfile.fromJson(Map<String, dynamic> json) {
    return AdvisorProfile(
      id: (json['id'] ?? 0) as int,
      userId: (json['user'] ?? 0) as int,
      organization: json['organization'] as String? ?? '',
      specialization: json['specialization'] as String? ?? '',
      yearsOfExperience: json['years_of_experience'] as int? ?? 0,
      expertiseAreas: json['expertise_areas'] ?? [],
      professionalLicense: json['professional_license'],
      certifications: json['certifications'] ?? [],
      certificationDocuments: json['certification_documents'] ?? [],
      geographicalAreas: json['geographical_areas'] ?? [],
      rates: Map<String, dynamic>.from(json['rates'] ?? {}),
      portfolio: json['portfolio'],
      portfolioLink: json['portfolio_link'],
      publications: json['publications'] ?? [],
      availability: Map<String, dynamic>.from(json['availability'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'organization': organization,
      'specialization': specialization,
      'years_of_experience': yearsOfExperience,
      'expertise_areas': expertiseAreas,
      'professional_license': professionalLicense,
      'certifications': certifications,
      'certification_documents': certificationDocuments,
      'geographical_areas': geographicalAreas,
      'rates': rates,
      'portfolio': portfolio,
      'portfolio_link': portfolioLink,
      'publications': publications,
      'availability': availability,
    };
  }
}
