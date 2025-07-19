import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_routes.dart';

class RegisterTeacherController extends ChangeNotifier {
  final BuildContext context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isDisposed = false;

  // Getters pour éviter les accès directs
  bool get isLoading => _isLoading;

  // Champs de base
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController communicationPreferencesController =
      TextEditingController(text: "email");

  // Informations professionnelles
  final TextEditingController institutionNameController =
      TextEditingController();
  final TextEditingController highestDegreeController = TextEditingController();
  final TextEditingController yearsOfExperienceController =
      TextEditingController();
  final TextEditingController qualificationsController =
      TextEditingController();

  // Listes de sélection
  List<String> selectedSubjects = [];
  List<String> selectedTeachingTypes = [];

  // Pièces jointes
  String? identityDocumentPath;
  String? degreeDocumentPath;
  String? cvPath;

  RegisterTeacherController(this.context);

  // Optimisation du setState
  void setLoading(bool value) {
    if (_isDisposed) return;
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  // Fonctions de validation optimisées
  bool validateFirstName() {
    return firstNameController.text.trim().isNotEmpty;
  }

  bool validateLastName() {
    return lastNameController.text.trim().isNotEmpty;
  }

  bool validateDate() {
    return dateOfBirthController.text.trim().isNotEmpty;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est requis';
    }
    // Regex optimisée pour l'email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(value.trim()) ? null : 'Email invalide';
  }

  bool validatePhone() {
    final phone = phoneNumberController.text.trim();
    return phone.isNotEmpty && phone.length >= 8;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est requis';
    }
    return value.length >= 6
        ? null
        : 'Le mot de passe doit contenir au moins 6 caractères';
  }

  bool validateInstitution() {
    return institutionNameController.text.trim().isNotEmpty;
  }

  bool validateDegree() {
    return highestDegreeController.text.trim().isNotEmpty;
  }

  bool validateExperience() {
    final experience = yearsOfExperienceController.text.trim();
    return experience.isNotEmpty && int.tryParse(experience) != null;
  }

  bool validateQualifications() {
    return qualificationsController.text.trim().isNotEmpty;
  }

  bool validateDocuments() {
    return identityDocumentPath != null &&
        degreeDocumentPath != null &&
        cvPath != null;
  }

  // Validations générales pour les champs de texte
  String? validateField(String? value) => Validators.validateField(value);

  bool isEmailValid() => validateEmail(emailController.text) == null;

  bool isPasswordValid() => validatePassword(passwordController.text) == null;

  // Cache pour éviter les recalculs
  bool? _allFieldsValid;

  bool _validateAllFields() {
    // Utiliser le cache si disponible
    if (_allFieldsValid != null) return _allFieldsValid!;

    _allFieldsValid =
        validateFirstName() &&
        validateLastName() &&
        isEmailValid() &&
        isPasswordValid() &&
        validatePhone() &&
        validateDate() &&
        validateInstitution() &&
        validateDegree() &&
        validateExperience() &&
        validateQualifications() &&
        selectedSubjects.isNotEmpty &&
        selectedTeachingTypes.isNotEmpty &&
        validateDocuments();

    return _allFieldsValid!;
  }

  // Invalider le cache quand les données changent
  void invalidateValidationCache() {
    _allFieldsValid = null;
  }

  // Fonction d'inscription optimisée
  Future<void> registerTeacher() async {
    if (_isLoading) return;
    setLoading(true);

    try {
      if (!_validateAllFields()) {
        _showSnackBar("Please fill all required fields");
        return;
      }

      final response = await AuthService.registerTeacher(
        userData: _buildUserData(),
        teacherData: _buildTeacherData(),
        files: _buildFilesData(),
      );

      if (response['success'] == true) {
        await _handleSuccessfulRegistration(response);
      } else {
        _showSnackBar(response['message'] ?? "Unknown error occurred");
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      _showSnackBar("Error: ${e.toString()}");
    } finally {
      setLoading(false);
    }
  }


  

  Map<String, dynamic> _buildUserData() {
  return {
    "email": emailController.text.trim(),
    "password": passwordController.text.trim(),
    "password_confirm": passwordController.text.trim(),
    "first_name": firstNameController.text.trim(),
    "last_name": lastNameController.text.trim(),
    "phone_number": phoneNumberController.text.trim(),
    "date_of_birth": _formatDate(dateOfBirthController.text.trim()),
    "communication_preferences": [
      communicationPreferencesController.text.trim(),
    ],
    "type": "teacher",
  };
}



  Map<String, dynamic> _buildTeacherData() {
    return {
      "institution_name": institutionNameController.text.trim(),
      "subjects": selectedSubjects,
      "highest_degree": highestDegreeController.text.trim(),
      "years_of_experience": yearsOfExperienceController.text.trim(),
      "teaching_type": selectedTeachingTypes,
      "qualifications": qualificationsController.text.trim(),
      "availability": {}, // Add actual availability data if needed
    };
  }

  Map<String, String> _buildFilesData() {
    return {
      "identity_document": identityDocumentPath ?? '',
      "degree_document": degreeDocumentPath ?? '',
      "cv": cvPath ?? '',
    };
  }


  

  String _formatDate(String inputDate) {
  try {
    // Si la date est déjà au format YYYY-MM-DD
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(inputDate)) {
      return inputDate;
    }
    
    // Si la date est au format DD/MM/YYYY (commun dans les date pickers)
    if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(inputDate)) {
      final parts = inputDate.split('/');
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    }
    
    // Si c'est un DateTime (depuis un date picker)
    final parsedDate = DateTime.tryParse(inputDate);
    if (parsedDate != null) {
      return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
    }
    
    // Fallback - retourne la date originale mais cela échouera probablement côté serveur
    return inputDate;
  } catch (e) {
    debugPrint('Date formatting error: $e');
    return inputDate;
  }
}



  

  Future<void> _handleSuccessfulRegistration(
    Map<String, dynamic> response,
  ) async {
    try {
      // Sauvegarde des tokens (ne bloque pas si échec)
      try {
        final tokens = response['tokens'] as Map<String, dynamic>? ?? {};
        await AuthService.saveTokens(
          tokens['access']?.toString() ?? '',
          tokens['refresh']?.toString() ?? '',
        );
      } catch (e) {
        debugPrint('Erreur sauvegarde tokens: $e');
      }

      // Création de l'utilisateur
      final userData = response['user'] as Map<String, dynamic>? ?? {};
      final user = UserModel(
        id: userData['id'] as int? ?? 0,
        email: userData['email'] as String? ?? '',
        firstName: userData['first_name'] as String? ?? '',
        lastName: userData['last_name'] as String? ?? '',
        type: userData['type'] as String? ?? 'teacher',
        verificationStatus:
            userData['verification_status'] as String? ?? 'pending',
        dateJoined: DateTime.now(),
        isActive: true,
        isStaff: false,
      );

      // Navigation
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.successRegistration,
          (route) => false,
          arguments: user,
        );
      }
    } catch (e) {
      debugPrint('Erreur navigation: $e');
      if (context.mounted) {
        _showSnackBar("Inscription réussie mais erreur de redirection");
      }
    }
  }

  void _showSnackBar(String message) {
    if (context.mounted && !_isDisposed) {
      print(message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
      );
    }
  }

  // Méthodes pour mettre à jour les listes
  void updateSubjects(List<String> subjects) {
    selectedSubjects = subjects;
    invalidateValidationCache();
    notifyListeners();
  }

  void updateTeachingTypes(List<String> types) {
    selectedTeachingTypes = types;
    invalidateValidationCache();
    notifyListeners();
  }

  void updateDocumentPath(String documentType, String? path) {
    switch (documentType) {
      case 'identity':
        identityDocumentPath = path;
        break;
      case 'degree':
        degreeDocumentPath = path;
        break;
      case 'cv':
        cvPath = path;
        break;
    }
    invalidateValidationCache();
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;

    // Dispose des contrôleurs
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    dateOfBirthController.dispose();
    communicationPreferencesController.dispose();
    institutionNameController.dispose();
    highestDegreeController.dispose();
    yearsOfExperienceController.dispose();
    qualificationsController.dispose();

    super.dispose();
  }
}
