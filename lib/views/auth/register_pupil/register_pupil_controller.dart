import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_routes.dart';

class RegisterPupilController {
  final BuildContext context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  // Champs de base obligatoires
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  List<String> communicationPreferences = [];

  // Informations spécifiques à l'élève
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController currentLevelController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController legalGuardianNameController =
      TextEditingController();
  final TextEditingController legalGuardianPhoneController =
      TextEditingController();
  final TextEditingController secondGuardianNameController =
      TextEditingController();
  final TextEditingController secondGuardianPhoneController =
      TextEditingController();

  bool cafeteria = false;
  final TextEditingController dietaryRestrictionsController =
      TextEditingController();
  bool schoolTransport = false;
  final TextEditingController transportDetailsController =
      TextEditingController();

  final TextEditingController medicalInformationController =
      TextEditingController();
  final TextEditingController schoolInsuranceController =
      TextEditingController();

  final TextEditingController siblingsAtSchoolController =
      TextEditingController();

  List<String> exitPermissions = [];
  List<String> desiredActivities = [];

  // Options pour les dropdowns
  final List<String> communicationPrefs = ["email", "sms", "phone"];
  final List<String> levelOptions = [
    "6ème",
    "5ème",
    "4ème",
    "3ème",
    "Seconde",
    "Première",
    "Terminale",
  ];
  final List<String> specializationOptions = [
    "Scientifique",
    "Littéraire",
    "Économique",
    "Technologique",
    "Professionnelle",
  ];

  RegisterPupilController(this.context);

  String? validateEmail(String? value) => Validators.validateEmail(value);
  // String? validatePassword(String? value) => Validators.validatePassword(value);
  String? validateField(String? value) => Validators.validateField(value);

  bool validateCurrentStep(int currentStep) {
    switch (currentStep) {
      case 0:
        return validateField(firstNameController.text) == null &&
            validateField(lastNameController.text) == null &&
            dateOfBirthController.text.isNotEmpty &&
            validateEmail(emailController.text) == null &&
            validatePassword(passwordController.text) == null;
      case 1:
        return validateField(schoolNameController.text) == null &&
            validateField(currentLevelController.text) == null &&
            validateField(specializationController.text) == null;
      case 2:
        return validateField(legalGuardianNameController.text) == null &&
            validateField(legalGuardianPhoneController.text) == null;
      case 3:
        return communicationPreferences.isNotEmpty;
      default:
        return true;
    }
  }


  String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return "Ce champ est obligatoire";
  }
  if (value.length < 8) {
    return "Le mot de passe doit contenir au moins 8 caractères";
  }
  return null;
}

String? validatePasswordConfirm(String? value) {
  if (value != passwordController.text) {
    return "Les mots de passe ne correspondent pas";
  }
  return null;
}

  Future<void> registerPupil() async {
  if (!formKey.currentState!.validate()) return;

  isLoading = true;
  _refresh();

  try {
    final pupilData = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "password_confirm": passwordConfirmController.text.trim(),
      "first_name": firstNameController.text.trim(),
      "last_name": lastNameController.text.trim(),
      "phone_number": phoneController.text.trim(),
      "date_of_birth": dateOfBirthController.text.trim(),
      "type": "pupil",
      "communication_preferences": communicationPreferences,
      "address": "",
      "city": "",
      "postal_code": "",
      "country": "",
      
      // Structure modifiée pour correspondre au backend
      "school_name": schoolNameController.text.trim(),
      "current_level": currentLevelController.text.trim(),
      "specialization": specializationController.text.trim(),
      "legal_guardian_name": legalGuardianNameController.text.trim(),
      "legal_guardian_phone": legalGuardianPhoneController.text.trim(),
      "second_guardian_name": secondGuardianNameController.text.trim(),
      "second_guardian_phone": secondGuardianPhoneController.text.trim(),
      "cafeteria": cafeteria,
      "dietary_restrictions": dietaryRestrictionsController.text.trim(),
      "school_transport": schoolTransport,
      "transport_details": transportDetailsController.text.trim(),
      "medical_information": medicalInformationController.text.trim(),
      "school_insurance": schoolInsuranceController.text.trim(),
      "exit_permissions": exitPermissions,
      "siblings_at_school": siblingsAtSchoolController.text.trim(),
      "desired_activities": desiredActivities,
    };

    debugPrint("Données envoyées au backend:");
    debugPrint(jsonEncode(pupilData));

    final result = await AuthService.registerPupil(body: pupilData);

    if (result['success'] == true) {
      await AppRoutes.navigateToRegistrationSuccess(
        context, 
        result['user'],
      );
    } else {
      throw Exception(result['message'] ?? "Erreur inconnue");
    }
  } catch (e) {
    debugPrint("ERREUR D'INSCRIPTION:");
    debugPrint(e.toString());
    _showError("Échec de l'inscription: ${e.toString()}");
  } finally {
    isLoading = false;
    _refresh();
  }
}


void _showError(String message) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}


  void toggleCommunication(String value) {
    if (communicationPreferences.contains(value)) {
      communicationPreferences.remove(value);
    } else {
      communicationPreferences.add(value);
    }
    _refresh();
  }

  void toggleExitPermission(String value) {
    if (exitPermissions.contains(value)) {
      exitPermissions.remove(value);
    } else {
      exitPermissions.add(value);
    }
    _refresh();
  }

  void toggleDesiredActivity(String value) {
    if (desiredActivities.contains(value)) {
      desiredActivities.remove(value);
    } else {
      desiredActivities.add(value);
    }
    _refresh();
  }

  void _refresh() {
    if (context.mounted) {
      (context as Element).markNeedsBuild();
    }
  }

  @override
  // ignore: override_on_non_overriding_member
  void dispose() {
    // Dispose des controllers
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    dateOfBirthController.dispose();
    schoolNameController.dispose();
    currentLevelController.dispose();
    specializationController.dispose();
    phoneNumberController.dispose();
    legalGuardianNameController.dispose();
    legalGuardianPhoneController.dispose();
    secondGuardianNameController.dispose();
    secondGuardianPhoneController.dispose();
    dietaryRestrictionsController.dispose();
    transportDetailsController.dispose();
    medicalInformationController.dispose();
    schoolInsuranceController.dispose();
    siblingsAtSchoolController.dispose();
  }
}
