import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_routes.dart';

class RegisterAdvisorController {
  final BuildContext context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Personal Information
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  // Professional Information
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();
  final TextEditingController yearsOfExperienceController = TextEditingController();
  final TextEditingController professionalLicenseController = TextEditingController();
  final TextEditingController certificationsController = TextEditingController();
  final TextEditingController geographicalAreasController = TextEditingController();
  final TextEditingController ratesController = TextEditingController();
  final TextEditingController portfolioLinkController = TextEditingController();

  // Files
  PlatformFile? identityDocument;
  PlatformFile? portfolioFile;
  List<PlatformFile> certificationDocuments = [];

  // Preferences
  List<String> communicationPreferences = [];

  // State
  bool isLoading = false;

  RegisterAdvisorController(this.context);

  // Validators
  String? validateEmail(String? value) => Validators.validateEmail(value);
  String? validatePassword(String? value) => Validators.validatePassword(value);
  String? validateField(String? value) => Validators.validateField(value);

  // File Picker Methods
  Future<void> pickSingleFile(Function(PlatformFile) onSelected) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null && result.files.isNotEmpty) {
        onSelected(result.files.first);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection du fichier: $e')),
      );
    }
  }

  Future<void> pickMultipleFiles(Function(List<PlatformFile>) onSelected) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null && result.files.isNotEmpty) {
        onSelected(result.files);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection des fichiers: $e')),
      );
    }
  }

  // Communication Preferences
  void toggleCommunication(String type) {
    if (communicationPreferences.contains(type)) {
      communicationPreferences.remove(type);
    } else {
      communicationPreferences.add(type);
    }
    _refresh();
  }














  // Registration Method
  Future<void> registerAdvisor() async {
  if (!formKey.currentState!.validate()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Veuillez corriger les erreurs dans le formulaire')),
    );
    return;
  }

  if (identityDocument == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('La pièce d\'identité est obligatoire')),
    );
    return;
  }

  isLoading = true;
  _refresh();

  try {
    // Données utilisateur
    final userData = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "password_confirm": passwordController.text.trim(),
      "first_name": firstNameController.text.trim(),
      "last_name": lastNameController.text.trim(),
      "type": "advisor",
      "phone_number": phoneController.text.trim(),
      "date_of_birth": dobController.text.trim(),
      "communication_preferences": communicationPreferences,
    };

    // Données conseiller
    final advisorData = {
      "organization": organizationController.text.trim(),
      "specialization": specializationController.text.trim(),
      "years_of_experience": yearsOfExperienceController.text.trim(),
      "expertise_areas": [], // Ajoutez votre logique pour ce champ
      "professional_license": professionalLicenseController.text.trim(),
      "certifications": certificationsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      "geographical_areas": geographicalAreasController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      "rates": {}, // Ajoutez votre logique pour ce champ
      "portfolio_link": portfolioLinkController.text.trim(),
    };

    final response = await AuthService.registerAdvisor(
      userData: userData,
      advisorData: advisorData,
      identityDocument: identityDocument,
      portfolioFile: portfolioFile,
      certificationDocuments: certificationDocuments,
    );

    if (response['success'] == true) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.successRegistration,
        (route) => false,
        arguments: response['user'],
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Erreur lors de l\'inscription')),
      );
    }
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur: ${e.toString()}')),
    );
  } finally {
    isLoading = false;
    _refresh();
  }
}












  void _refresh() {
    if (context.mounted) {
      (context as Element).markNeedsBuild();
    }
  }
}