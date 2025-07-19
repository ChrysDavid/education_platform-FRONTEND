import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';

class ChooseRoleController {
  final BuildContext context;

  ChooseRoleController(this.context);

  // Navigation methods
  void goToRegisterStudent() => Navigator.pushNamed(context, AppRoutes.registerStudent);
  void goToRegisterPupil() => Navigator.pushNamed(context, AppRoutes.registerPupil);
  void goToRegisterTeacher() => Navigator.pushNamed(context, AppRoutes.registerTeacher);
  void goToRegisterAdvisor() => Navigator.pushNamed(context, AppRoutes.registerAdvisor);
  // void goToRegisterParent() => Navigator.pushNamed(context, AppRoutes.registerParent);
  // void goToRegisterCompany() => Navigator.pushNamed(context, AppRoutes.registerCompany);
  void goToLogin() => Navigator.pushNamed(context, AppRoutes.login);

  // Liste des rôles disponibles
  static List<Map<String, dynamic>> get roles => [
    {
      "title": "Élève",
      "description": "Collégiens et lycéens (4ème à Terminale)",
      "icon": Icons.school_outlined,
      "color": AppColors.primary,
      "iconBackgroundColor": AppColors.primary.withOpacity(0.1),
      "action": "goToRegisterPupil",
      "features": [
        {"icon": Icons.book, "text": "Accès à des ressources éducatives"},
        {"icon": Icons.explore, "text": "Exploration des filières"},
      ],
    },
    {
      "title": "Étudiant",
      "description": "Universités et grandes écoles",
      "icon": Icons.account_balance_outlined,
      "color": AppColors.secondary,
      "iconBackgroundColor": AppColors.secondary.withOpacity(0.1),
      "action": "goToRegisterStudent",
      "features": [
        {"icon": Icons.school, "text": "Conseils d'orientation supérieure"},
        {"icon": Icons.work, "text": "Opportunités de stages"},
      ],
    },
    {
      "title": "Professeur",
      "description": "Partagez vos cours et suivez vos élèves",
      "icon": Icons.person_outline,
      "color": const Color(0xFF3B82F6),
      "iconBackgroundColor": const Color(0xFF3B82F6).withOpacity(0.1),
      "action": "goToRegisterTeacher",
      "features": [
        {"icon": Icons.people, "text": "Gestion de vos classes"},
        {"icon": Icons.upload_file, "text": "Partage de ressources"},
      ],
    },
    {
      "title": "Conseiller",
      "description": "Aidez les élèves dans leur orientation",
      "icon": Icons.support_agent_outlined,
      "color": const Color(0xFF8B5CF6),
      "iconBackgroundColor": const Color(0xFF8B5CF6).withOpacity(0.1),
      "action": "goToRegisterAdvisor",
      "features": [
        {"icon": Icons.psychology, "text": "Aide personnalisée aux élèves"},
        {"icon": Icons.analytics, "text": "Suivi des progressions"},
      ],
    },
    {
      "title": "Parent",
      "description": "Suivez la progression scolaire de vos enfants",
      "icon": Icons.family_restroom,
      "color": const Color(0xFF10B981),
      "iconBackgroundColor": const Color(0xFF10B981).withOpacity(0.1),
      "action": "goToRegisterParent",
      "features": [
        {"icon": Icons.visibility, "text": "Consultez les résultats et progrès"},
        {"icon": Icons.message, "text": "Communiquez avec les enseignants"},
      ],
    },
    {
      "title": "Entreprise",
      "description": "Partenaire pour stages et formations",
      "icon": Icons.business_center_outlined,
      "color": const Color(0xFFEF4444),
      "iconBackgroundColor": const Color(0xFFEF4444).withOpacity(0.1),
      "action": "goToRegisterCompany",
      "features": [
        {"icon": Icons.people_alt, "text": "Proposez des offres de stage"},
        {"icon": Icons.group_add, "text": "Collaborez avec les écoles"},
      ],
    },
  ];

  // Exécution des actions en fonction du rôle
  void performAction(String action) {
    switch (action) {
      case "goToRegisterStudent":
        goToRegisterStudent();
        break;
      case "goToRegisterPupil":
        goToRegisterPupil();
        break;
      case "goToRegisterTeacher":
        goToRegisterTeacher();
        break;
      case "goToRegisterAdvisor":
        goToRegisterAdvisor();
        break;
      // case "goToRegisterParent":
      //   goToRegisterParent();
      //   break;
      // case "goToRegisterCompany":
      //   goToRegisterCompany();
      //   break;
    }
  }
}
