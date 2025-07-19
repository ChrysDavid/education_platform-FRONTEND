import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import 'register_teacher_controller.dart';

class RegisterTeacherScreen extends StatefulWidget {
  const RegisterTeacherScreen({super.key});

  @override
  State<RegisterTeacherScreen> createState() => _RegisterTeacherScreenState();
}

class _RegisterTeacherScreenState extends State<RegisterTeacherScreen> {
  late RegisterTeacherController _controller;
  int _currentStep = 0;
  final int _totalSteps = 4;

  final List<String> subjectOptions = [
    "Mathématiques",
    "Physique",
    "Français",
    "Anglais",
    "SVT",
    "Histoire",
    "Géographie"
  ];

  final List<String> teachingTypes = ["En présentiel", "En ligne", "Hybride"];

  final Map<String, String> teachingTypesValues = {
    "En présentiel": "in_person",
    "En ligne": "online",
    "Hybride": "hybrid"
  };

  final List<String> communicationPrefs = [
    "Email",
    "SMS",
    "Téléphone",
  ];

  final Map<String, String> communicationPrefsValues = {
    "Email": "email",
    "SMS": "sms",
    "Téléphone": "phone"
  };

  final List<String> degreeOptions = [
    "Licence",
    "Master",
    "Doctorat",
    "Agrégation",
    "Autre"
  ];

  final List<String> qualificationOptions = [
    "CAPES",
    "CAFOP",
    "Certificat en pédagogie numérique",
    "BTS enseignement",
    "Autre"
  ];

  // Titres des étapes
  final List<String> _stepTitles = [
    "Informations personnelles",
    "Informations de contact",
    "Informations professionnelles",
    "Documents"
  ];

  // Icônes des étapes
  final List<IconData> _stepIcons = [
    Icons.person,
    Icons.contact_mail,
    Icons.work,
    Icons.file_copy
  ];

  @override
  void initState() {
    super.initState();
    _controller = RegisterTeacherController(context);
    _controller.communicationPreferencesController.text = "email";
  }

  Future<void> _pickFile(Function(String) onPicked) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        onPicked(result.files.single.path!);
        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Erreur lors de la sélection du fichier: ${e.toString()}")),
      );
    }
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
        _controller.dateOfBirthController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Widget _buildCheckboxList({
    required List<String> options,
    required List<String> selected,
    required Map<String, String>? valueMap,
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
                      value: selected.contains(
                          valueMap != null ? valueMap[option] : option),
                      activeColor: AppColors.primary,
                      checkColor: Colors.white,
                      onChanged: (value) => onChanged(
                          value, valueMap != null ? valueMap[option]! : option),
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

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
    Map<String, String>? valueMap,
  }) {
    // Trouver le libellé correspondant à la valeur stockée
    String? displayValue;
    if (valueMap != null) {
      // Si on a un mapping de valeurs, trouver le libellé correspondant
      displayValue = valueMap.entries
          .firstWhere(
            (entry) => entry.value == value,
            orElse: () => MapEntry('', items.first),
          )
          .key;
    } else {
      // Sinon utiliser directement la valeur
      displayValue = value.isNotEmpty ? value : null;
    }

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
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primary),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            value: displayValue, // Utiliser le libellé comme valeur affichée
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item, // Stocker le libellé comme valeur
                child: Text(item),
              );
            }).toList(),
            validator: (value) => value == null ? 'Ce champ est requis' : null,
            onChanged: (selectedLabel) {
              if (selectedLabel != null) {
                // Convertir le libellé sélectionné en valeur interne si nécessaire
                final selectedValue = valueMap != null
                    ? valueMap[selectedLabel] ?? selectedLabel
                    : selectedLabel;
                onChanged(selectedValue);
              }
            },
            isExpanded: true,
            hint: Text('Sélectionner $label'),
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
            dropdownColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _goToNextStep() {
    // Validation de l'étape actuelle
    bool isValid = false;

    switch (_currentStep) {
      case 0:
        isValid = _controller.validateFirstName() &&
            _controller.validateLastName() &&
            _controller.validateDate();
        break;
      case 1:
        isValid = _controller.validateEmail(_controller.emailController.text) ==
                null &&
            _controller.validatePhone() &&
            _controller.validatePassword(_controller.passwordController.text) ==
                null;
        break;
      case 2:
        isValid = _controller.validateInstitution() &&
            _controller.validateDegree() &&
            _controller.validateExperience() &&
            _controller.validateQualifications() &&
            _controller.selectedSubjects.isNotEmpty;
        break;
      case 3:
        isValid = _controller.validateDocuments();
        break;
      default:
        isValid = true;
    }

    if (isValid) {
      setState(() {
        if (_currentStep < _totalSteps - 1) {
          _currentStep++;
        } else {
          // Soumettre le formulaire
          _controller.registerTeacher();

        }
      });
    } else {
      // Afficher un message d'erreur
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
        return _buildContactInfoStep();
      case 2:
        return _buildProfessionalInfoStep();
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
              controller: _controller.dateOfBirthController,
              hintText: "JJ/MM/AAAA",
              labelText: "Date de naissance",
              validator: _controller.validateField,
              prefixIcon: Icons.calendar_today,
              borderColor: AppColors.secondary,
              focusedBorderColor: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildContactInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          controller: _controller.phoneNumberController,
          hintText: "Numéro de téléphone",
          labelText: "Téléphone",
          validator: _controller.validateField,
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone,
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
        _buildDropdown(
          label: "Préférence de communication",
          value: _controller.communicationPreferencesController.text,
          items: communicationPrefs,
          valueMap: communicationPrefsValues,
          onChanged: (value) {
            setState(() {
              _controller.communicationPreferencesController.text = value ?? '';
            });
          },
          icon: Icons.message,
        ),
      ],
    );
  }

  Widget _buildProfessionalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _controller.institutionNameController,
          hintText: "Établissement actuel",
          labelText: "Établissement",
          validator: _controller.validateField,
          prefixIcon: Icons.school,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: "Diplôme le plus élevé",
          value: _controller.highestDegreeController.text,
          items: degreeOptions,
          onChanged: (value) {
            setState(() {
              _controller.highestDegreeController.text = value ?? '';
            });
          },
          icon: Icons.grade,
        ),
        _buildDropdown(
          label: "Qualification",
          value: _controller.qualificationsController.text,
          items: qualificationOptions,
          onChanged: (value) {
            setState(() {
              _controller.qualificationsController.text = value ?? '';
            });
          },
          icon: Icons.workspace_premium,
        ),
        CustomTextField(
          controller: _controller.yearsOfExperienceController,
          hintText: "Années d'expérience",
          labelText: "Expérience (années)",
          validator: _controller.validateField,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.timelapse,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        _buildCheckboxList(
          options: subjectOptions,
          selected: _controller.selectedSubjects,
          valueMap: null,
          onChanged: (value, subject) {
            setState(() {
              value!
                  ? _controller.selectedSubjects.add(subject)
                  : _controller.selectedSubjects.remove(subject);
            });
          },
          label: "Matières enseignées",
        ),
        const SizedBox(height: 16),
        _buildCheckboxList(
          options: teachingTypes,
          selected: _controller.selectedTeachingTypes,
          valueMap: teachingTypesValues,
          onChanged: (value, type) {
            setState(() {
              value!
                  ? _controller.selectedTeachingTypes.add(type)
                  : _controller.selectedTeachingTypes.remove(type);
            });
          },
          label: "Type d'enseignement",
        ),
      ],
    );
  }

  Widget _buildDocumentsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilePicker(
          label: "Pièce d'identité",
          path: _controller.identityDocumentPath,
          onPressed: () =>
              _pickFile((path) => _controller.identityDocumentPath = path),
          icon: Icons.badge,
        ),
        _buildFilePicker(
          label: "Diplôme",
          path: _controller.degreeDocumentPath,
          onPressed: () =>
              _pickFile((path) => _controller.degreeDocumentPath = path),
          icon: Icons.school,
        ),
        _buildFilePicker(
          label: "CV",
          path: _controller.cvPath,
          onPressed: () => _pickFile((path) => _controller.cvPath = path),
          icon: Icons.description,
        ),
        const SizedBox(height: 20),
        const Text(
          "En soumettant ces documents, vous confirmez que toutes les informations fournies sont exactes et vous acceptez nos conditions d'utilisation.",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildFilePicker({
    required String label,
    required String? path,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    bool isFileSelected = path != null && path.isNotEmpty;

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
                            path.split('/').last,
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
          "Inscription Enseignant",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: RepaintBoundary(
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
