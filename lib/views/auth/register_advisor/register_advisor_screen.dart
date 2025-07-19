import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import 'register_advisor_controller.dart';

class RegisterAdvisorScreen extends StatefulWidget {
  const RegisterAdvisorScreen({super.key});

  @override
  State<RegisterAdvisorScreen> createState() => _RegisterAdvisorScreenState();
}

class _RegisterAdvisorScreenState extends State<RegisterAdvisorScreen> {
  late RegisterAdvisorController _controller;
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Titres des étapes
  final List<String> _stepTitles = [
    "Informations personnelles",
    "Informations professionnelles",
    "Spécialisations",
    "Documents"
  ];

  // Icônes des étapes
  final List<IconData> _stepIcons = [
    Icons.person,
    Icons.work,
    Icons.star,
    Icons.file_copy
  ];

  final List<String> communicationPrefs = ["email", "sms", "phone"];

  @override
  void initState() {
    super.initState();
    _controller = RegisterAdvisorController(context);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _controller.dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Widget _buildCheckboxList({
    required List<String> options,
    required List<String> selected,
    required Function(bool?, String) onChanged,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: options
                .map((option) => CheckboxListTile(
                      title: Text(option),
                      value: selected.contains(option),
                      activeColor: AppColors.primary,
                      checkColor: Colors.white,
                      onChanged: (value) => onChanged(value, option),
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFilePicker({
    required String label,
    required PlatformFile? file,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    bool isFileSelected = file != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFileSelected
              ? AppColors.primary
              : AppColors.textSecondary.withOpacity(0.3),
          width: isFileSelected ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isFileSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isFileSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (isFileSelected)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            file.name,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                CustomButton(
                  label: isFileSelected ? "Modifier" : "Choisir",
                  onPressed: onPressed,
                  backgroundColor:
                      isFileSelected ? Colors.white : AppColors.secondary,
                  textColor:
                      isFileSelected ? AppColors.secondary : Colors.white,
                  borderColor: isFileSelected ? AppColors.secondary : null,
                  height: 40,
                  width: 100,
                  borderRadius: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goToNextStep() {
    bool isValid = false;

    switch (_currentStep) {
      case 0:
        isValid = _controller.validateField(_controller.firstNameController.text) == null &&
            _controller.validateField(_controller.lastNameController.text) == null &&
            _controller.dobController.text.isNotEmpty &&
            _controller.validateEmail(_controller.emailController.text) == null &&
            _controller.validatePassword(_controller.passwordController.text) == null &&
            _controller.validateField(_controller.phoneController.text) == null;
        break;
      case 1:
        isValid = _controller.validateField(_controller.organizationController.text) == null &&
            _controller.validateField(_controller.yearsOfExperienceController.text) == null &&
            _controller.communicationPreferences.isNotEmpty;
        break;
      case 2:
        isValid = _controller.validateField(_controller.specializationController.text) == null &&
            _controller.validateField(_controller.geographicalAreasController.text) == null;
        break;
      case 3:
        isValid = _controller.identityDocument != null;
        break;
      default:
        isValid = false;
    }

    if (isValid) {
      setState(() {
        if (_currentStep < _totalSteps - 1) {
          _currentStep++;
        } else {
          _controller.registerAdvisor();
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Veuillez remplir tous les champs obligatoires correctement"),
          backgroundColor: AppColors.error,
        ),
      );
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
        return _buildProfessionalInfoStep();
      case 2:
        return _buildSpecializationStep();
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
          onTap: _selectDate,
          child: AbsorbPointer(
            child: CustomTextField(
              controller: _controller.dobController,
              hintText: "Date de naissance",
              labelText: "Date de naissance",
              validator: _controller.validateField,
              prefixIcon: Icons.calendar_month,
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
        const SizedBox(height: 16),
        _buildCheckboxList(
          options: communicationPrefs,
          selected: _controller.communicationPreferences,
          onChanged: (value, pref) {
            _controller.toggleCommunication(pref);
          },
          label: "Préférences de communication",
        ),
      ],
    );
  }

  Widget _buildProfessionalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _controller.organizationController,
          hintText: "Organisation",
          labelText: "Organisation",
          validator: _controller.validateField,
          prefixIcon: Icons.business,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _controller.yearsOfExperienceController,
          hintText: "Années d'expérience",
          labelText: "Expérience",
          validator: _controller.validateField,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.timelapse,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _controller.professionalLicenseController,
          hintText: "Licence professionnelle (optionnel)",
          labelText: "Licence pro",
          prefixIcon: Icons.badge,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _controller.ratesController,
          hintText: "Tarif standard (ex: 10000 FCFA)",
          labelText: "Tarifs",
          prefixIcon: Icons.money,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildSpecializationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _controller.specializationController,
          hintText: "Spécialisation principale",
          labelText: "Spécialisation",
          validator: _controller.validateField,
          prefixIcon: Icons.star,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _controller.certificationsController,
          hintText: "Certifications (séparées par virgule)",
          labelText: "Certifications",
          prefixIcon: Icons.school,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _controller.geographicalAreasController,
          hintText: "Zones géographiques (ex: Abidjan, Yamoussoukro)",
          labelText: "Zones d'intervention",
          validator: _controller.validateField,
          prefixIcon: Icons.map,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _controller.portfolioLinkController,
          hintText: "Lien vers un portfolio (optionnel)",
          labelText: "Portfolio en ligne",
          prefixIcon: Icons.link,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildDocumentsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilePicker(
          label: "Pièce d'identité (obligatoire)",
          file: _controller.identityDocument,
          onPressed: () => _controller.pickSingleFile((file) {
            setState(() {
              _controller.identityDocument = file;
            });
          }),
          icon: Icons.badge,
        ),
        _buildFilePicker(
          label: "Portfolio (fichier, optionnel)",
          file: _controller.portfolioFile,
          onPressed: () => _controller.pickSingleFile((file) {
            setState(() {
              _controller.portfolioFile = file;
            });
          }),
          icon: Icons.description,
        ),
        _buildFilePicker(
          label: "Documents de certification (optionnel)",
          file: _controller.certificationDocuments.isNotEmpty 
              ? PlatformFile(name: "${_controller.certificationDocuments.length} fichiers", size: 0)
              : null,
          onPressed: () => _controller.pickMultipleFiles((files) {
            setState(() {
              _controller.certificationDocuments = files;
            });
          }),
          icon: Icons.verified,
        ),
        const SizedBox(height: 20),
        const Text(
          "Seule la pièce d'identité est obligatoire. Les autres documents améliorent votre profil.",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_totalSteps, (index) {
          bool isActive = index <= _currentStep;
          bool isCurrent = index == _currentStep;

          return Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textSecondary.withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Icon(
                        _stepIcons[index],
                        color:
                            isActive ? Colors.white : AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 80,
                    child: Text(
                      _stepTitles[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (index < _totalSteps - 1)
                Container(
                  width: 20,
                  height: 2,
                  color: index < _currentStep
                      ? AppColors.primary
                      : AppColors.textSecondary.withOpacity(0.5),
                ),
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Inscription Conseiller",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
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
              child: _buildStepIndicator(),
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