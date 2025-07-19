// ignore: unused_import
import 'package:education_platform_frontend_flutter/views/app/main_app_screen.dart';
// ignore: unused_import
import 'package:education_platform_frontend_flutter/views/common/success_registraction_Screen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
// ignore: unused_import
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/components_register/form_steps_widget.dart';
import '../../../widgets/components_register/step_indicator_widget.dart';
import 'register_pupil_controller.dart';


class RegisterPupilScreen extends StatefulWidget {
  const RegisterPupilScreen({super.key});

  @override
  State<RegisterPupilScreen> createState() => _RegisterPupilScreenState();
}

class _RegisterPupilScreenState extends State<RegisterPupilScreen> {
  late RegisterPupilController _controller;
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Titres des étapes
  final List<String> _stepTitles = [
    "Informations personnelles",
    "Informations scolaires", 
    "Informations du tuteur",
    "Documents & préférences"
  ];

  // Icônes des étapes
  final List<IconData> _stepIcons = [
    Icons.person,
    Icons.school,
    Icons.family_restroom,
    Icons.file_copy
  ];

  @override
  void initState() {
    super.initState();
    _controller = RegisterPupilController(context);
  }

  // ignore: unused_element
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
                "Erreur lors de la sélection du fichier: ${e.toString()}"),),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2010),
      firstDate: DateTime(1990),
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
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _goToNextStep() {
    bool isValid = _controller.validateCurrentStep(_currentStep);

    if (isValid) {
      setState(() {
        if (_currentStep < _totalSteps - 1) {
          _currentStep++;
        } else {
          _controller.registerPupil();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Inscription Élève",
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
                      FormStepsWidget(
                        currentStep: _currentStep,
                        controller: _controller,
                        onDateSelect: _selectDate,
                        onStateChange: () => setState(() {}),
                      ),
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