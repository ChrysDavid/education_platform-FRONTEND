import 'package:flutter/material.dart';
import '../../../widgets/components_register/checkbox_list_widget.dart';
import '../../../widgets/components_register/dropdown_widget.dart';
import '../../../widgets/components_register/file_picker_widget.dart';
import '../../../widgets/components_register/step_indicator_widget.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import 'register_student_controller.dart';

class RegisterStudentScreen extends StatefulWidget {
  const RegisterStudentScreen({super.key});

  @override
  State<RegisterStudentScreen> createState() => _RegisterStudentScreenState();
}

class _RegisterStudentScreenState extends State<RegisterStudentScreen> {
  late RegisterStudentController _controller;
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Titres des étapes
  final List<String> _stepTitles = [
    "Informations personnelles",
    "Informations académiques",
    "Préférences & Compétences",
    "Documents & Finalisation",
  ];

  // Icônes des étapes
  final List<IconData> _stepIcons = [
    Icons.person,
    Icons.school,
    Icons.settings,
    Icons.description,
  ];

  @override
  void initState() {
    super.initState();
    _controller = RegisterStudentController(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToNextStep() {
    bool isValid = _validateCurrentStep();

    if (isValid) {
      setState(() {
        if (_currentStep < _totalSteps - 1) {
          _currentStep++;
        } else {
          _controller.registerStudent();
          
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez remplir tous les champs obligatoires"),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _controller.validateField(_controller.firstNameController.text) == null &&
            _controller.validateField(_controller.lastNameController.text) == null &&
            _controller.validateEmail(_controller.emailController.text) == null &&
            _controller.validatePassword(_controller.passwordController.text) == null &&
            _controller.validateField(_controller.phoneController.text) == null &&
            _controller.dateOfBirth != null;
      case 1:
        return _controller.validateField(_controller.institutionController.text) == null &&
            _controller.currentLevelController.text.isNotEmpty &&
            _controller.majorController.text.isNotEmpty &&
            _controller.academicYearController.text.isNotEmpty;
      case 2:
        return true; // Cette étape est optionnelle
      case 3:
        return _controller.identityDocument != null &&
            _controller.selectedCommunicationPrefs.isNotEmpty;
      default:
        return false;
    }
  }

  void _goToPreviousStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  Widget _buildFormStep() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildAcademicInfoStep();
      case 2:
        return _buildPreferencesStep();
      case 3:
        return _buildDocumentsStep();
      default:
        return Container();
    }
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _controller.firstNameController,
          hintText: "Prénom",
          labelText: "Prénom",
          validator: _controller.validateField,
          prefixIcon: Icons.person,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _controller.lastNameController,
          hintText: "Nom",
          labelText: "Nom",
          validator: _controller.validateField,
          prefixIcon: Icons.person_outline,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _controller.selectDateOfBirth,
          child: AbsorbPointer(
            child: CustomTextField(
              controller: _controller.dateOfBirthController,
              hintText: "Date de naissance",
              labelText: "Date de naissance",
              validator: _controller.validateField,
              prefixIcon: Icons.calendar_today,
              borderColor: AppColors.secondary,
              focusedBorderColor: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _controller.emailController,
          hintText: "Email",
          labelText: "Adresse email",
          validator: _controller.validateEmail,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _controller.passwordController,
          hintText: "Mot de passe",
          labelText: "Mot de passe",
          validator: _controller.validatePassword,
          obscureText: true,
          prefixIcon: Icons.lock,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _controller.phoneController,
          hintText: "Numéro de téléphone",
          labelText: "Téléphone",
          validator: _controller.validateField,
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildAcademicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _controller.institutionController,
          hintText: "Nom de l'établissement",
          labelText: "Institution",
          validator: _controller.validateField,
          prefixIcon: Icons.school,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        DropdownWidget(
          label: "Niveau actuel",
          value: _controller.currentLevelController.text,
          items: _controller.levelOptions,
          onChanged: (value) {
            setState(() {
              _controller.currentLevelController.text = value ?? '';
            });
          },
          icon: Icons.grade,
        ),
        DropdownWidget(
          label: "Filière/Spécialité",
          value: _controller.majorController.text,
          items: _controller.majorOptions,
          onChanged: (value) {
            setState(() {
              _controller.majorController.text = value ?? '';
            });
          },
          icon: Icons.book,
        ),
        DropdownWidget(
          label: "Année académique",
          value: _controller.academicYearController.text,
          items: _controller.academicYearOptions,
          onChanged: (value) {
            setState(() {
              _controller.academicYearController.text = value ?? '';
            });
          },
          icon: Icons.date_range,
        ),
        CustomTextField(
          controller: _controller.studentIdController,
          hintText: "Numéro étudiant (optionnel)",
          labelText: "Numéro étudiant",
          prefixIcon: Icons.badge,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text("Bénéficiaire d'une bourse"),
          value: _controller.isScholarship,
          onChanged: (value) {
            setState(() {
              _controller.toggleScholarship(value);
            });
          },
          activeColor: AppColors.primary,
        ),
        if (_controller.isScholarship) ...[
          const SizedBox(height: 8),
          CustomTextField(
            controller: _controller.scholarshipTypeController,
            hintText: "Type de bourse",
            labelText: "Type de bourse",
            prefixIcon: Icons.monetization_on,
            borderColor: AppColors.secondary,
            focusedBorderColor: AppColors.primary,
          ),
        ],
        const SizedBox(height: 16),
        CustomTextField(
          controller: _controller.averageGradeController,
          hintText: "Moyenne générale (optionnel)",
          labelText: "Moyenne",
          keyboardType: TextInputType.number,
          prefixIcon: Icons.star,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildPreferencesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListWidget(
          options: _controller.housingOptions,
          selected: _controller.housingNeeds,
          onChanged: (value, option) {
            setState(() {
              _controller.toggleHousingNeed(option);
            });
          },
          label: "Besoins de logement",
        ),
        const SizedBox(height: 20),
        CheckboxListWidget(
          options: _controller.computerSkillOptions,
          selected: _controller.computerSkills,
          onChanged: (value, option) {
            setState(() {
              _controller.toggleComputerSkill(option);
            });
          },
          label: "Compétences informatiques",
        ),
        const SizedBox(height: 20),
        CheckboxListWidget(
          options: _controller.interestOptions,
          selected: _controller.interests,
          onChanged: (value, option) {
            setState(() {
              _controller.toggleInterest(option);
            });
          },
          label: "Centres d'intérêt",
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _controller.internshipSearchController,
          hintText: "Recherche de stage (optionnel)",
          labelText: "Recherche de stage",
          prefixIcon: Icons.work,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _controller.extracurricularActivitiesController,
          hintText: "Activités extrascolaires (optionnel)",
          labelText: "Activités extrascolaires",
          prefixIcon: Icons.sports,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildDocumentsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilePickerWidget(
          label: "Document d'identité",
          file: _controller.identityDocument,
          onPressed: _controller.pickIdentityDocument,
          icon: Icons.credit_card,
        ),
        const SizedBox(height: 20),
        CheckboxListWidget(
          options: _controller.communicationPrefs,
          selected: _controller.selectedCommunicationPrefs,
          onChanged: (value, option) {
            setState(() {
              _controller.toggleCommunicationPref(option);
            });
          },
          label: "Préférences de communication",
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    "Consentements",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "En vous inscrivant, vous acceptez automatiquement :",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "• Le traitement de vos données personnelles",
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                "• L'utilisation de votre image à des fins éducatives",
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Inscription Étudiant",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.1),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: StepIndicatorWidget(
                currentStep: _currentStep,
                totalSteps: _totalSteps,
                stepTitles: _stepTitles,
                stepIcons: _stepIcons,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _stepTitles[_currentStep],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Étape ${_currentStep + 1} sur $_totalSteps",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildFormStep(),
                      const SizedBox(height: 100), // Espace pour les boutons
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -3),
                    blurRadius: 6,
                    color: Colors.black.withOpacity(0.1),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    CustomButton(
                      label: "Précédent",
                      onPressed: _goToPreviousStep,
                      backgroundColor: Colors.white,
                      textColor: AppColors.primary,
                      width: 120,
                      borderColor: AppColors.primary,
                      icon: const Icon(Icons.arrow_back,
                          size: 16, color: AppColors.primary),
                    )
                  else
                    const SizedBox(width: 120),
                  Text(
                    "${((_currentStep + 1) / _totalSteps * 100).toInt()}%",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 18,
                    ),
                  ),
                  CustomButton(
                    label: _currentStep == _totalSteps - 1
                        ? "Terminer"
                        : "Suivant",
                    onPressed: _goToNextStep,
                    isLoading: _controller.isLoading &&
                        _currentStep == _totalSteps - 1,
                    backgroundColor: _currentStep == _totalSteps - 1
                        ? AppColors.secondary
                        : AppColors.primary,
                    width: 120,
                    icon: _currentStep == _totalSteps - 1
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : const Icon(Icons.arrow_forward,
                            size: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}