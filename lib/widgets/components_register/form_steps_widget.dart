import 'package:flutter/material.dart';
import '../custom_text_field.dart';
import '../../core/constants/app_colors.dart';
import '../../views/auth/register_pupil/register_pupil_controller.dart';
import 'checkbox_list_widget.dart';
import 'dropdown_widget.dart';

class FormStepsWidget extends StatelessWidget {
  final int currentStep;
  final RegisterPupilController controller;
  final VoidCallback onDateSelect;
  final VoidCallback onStateChange;

  const FormStepsWidget({
    super.key,
    required this.currentStep,
    required this.controller,
    required this.onDateSelect,
    required this.onStateChange,
  });

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildSchoolInfoStep();
      case 2:
        return _buildGuardianInfoStep();
      case 3:
        return _buildDocumentsAndPrefsStep();
      default:
        return Container();
    }
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: controller.firstNameController,
          hintText: "Prénom",
          labelText: "Prénom",
          validator: controller.validateField,
          prefixIcon: Icons.person,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controller.lastNameController,
          hintText: "Nom",
          labelText: "Nom",
          validator: controller.validateField,
          prefixIcon: Icons.person_outline,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: onDateSelect,
          child: AbsorbPointer(
            child: CustomTextField(
              controller: controller.dateOfBirthController,
              hintText: "Date de naissance",
              labelText: "Date de naissance",
              validator: controller.validateField,
              prefixIcon: Icons.calendar_today,
              borderColor: AppColors.secondary,
              focusedBorderColor: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controller.phoneController,
          hintText: "Numéro de téléphone",
          labelText: "Téléphone",
          validator: controller.validateField,
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controller.emailController,
          hintText: "Email",
          labelText: "Adresse email",
          validator: controller.validateEmail,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controller.passwordController,
          hintText: "Mot de passe",
          labelText: "Mot de passe",
          validator: controller.validatePassword,
          obscureText: true,
          prefixIcon: Icons.lock,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controller.passwordConfirmController,
          labelText: "Confirmez le mot de passe",
          obscureText: true,
          validator: (value) {
            if (value != controller.passwordController.text) {
              return "Les mots de passe ne correspondent pas";
            }
            return null;
          },
          hintText: "Confirme Mot de passe",
        ),
      ],
    );
  }

  Widget _buildSchoolInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: controller.schoolNameController,
          hintText: "Établissement scolaire",
          labelText: "École/lycée/collège",
          validator: controller.validateField,
          prefixIcon: Icons.school,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        DropdownWidget(
          label: "Niveau scolaire",
          value: controller.currentLevelController.text,
          items: controller.levelOptions,
          onChanged: (value) {
            controller.currentLevelController.text = value ?? '';
            onStateChange();
          },
          icon: Icons.grade,
        ),
        DropdownWidget(
          label: "Spécialité",
          value: controller.specializationController.text,
          items: controller.specializationOptions,
          onChanged: (value) {
            controller.specializationController.text = value ?? '';
            onStateChange();
          },
          icon: Icons.book,
        ),
      ],
    );
  }

  Widget _buildGuardianInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: controller.legalGuardianNameController,
          hintText: "Nom du tuteur légal",
          labelText: "Tuteur légal",
          validator: controller.validateField,
          prefixIcon: Icons.person_pin,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controller.legalGuardianPhoneController,
          hintText: "Téléphone du tuteur",
          labelText: "Téléphone tuteur",
          validator: controller.validateField,
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_android,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controller.secondGuardianNameController,
          hintText: "Nom du second tuteur (optionnel)",
          labelText: "Second tuteur",
          prefixIcon: Icons.person_add,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controller.secondGuardianPhoneController,
          hintText: "Téléphone du second tuteur (optionnel)",
          labelText: "Téléphone second tuteur",
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_iphone,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildDocumentsAndPrefsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListWidget(
          options: controller.communicationPrefs,
          selected: controller.communicationPreferences,
          onChanged: (value, pref) {
            controller.toggleCommunication(pref);
          },
          label: "Préférences de communication",
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text("Utilise la cantine scolaire"),
          value: controller.cafeteria,
          onChanged: (value) {
            controller.cafeteria = value;
            onStateChange();
          },
          activeColor: AppColors.primary,
        ),
        if (controller.cafeteria) ...[
          const SizedBox(height: 8),
          CustomTextField(
            controller: controller.dietaryRestrictionsController,
            hintText: "Régimes alimentaires spécifiques",
            labelText: "Restrictions alimentaires",
            prefixIcon: Icons.fastfood,
            borderColor: AppColors.secondary,
            focusedBorderColor: AppColors.primary,
          ),
        ],
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text("Utilise le transport scolaire"),
          value: controller.schoolTransport,
          onChanged: (value) {
            controller.schoolTransport = value;
            onStateChange();
          },
          activeColor: AppColors.primary,
        ),
        if (controller.schoolTransport) ...[
          const SizedBox(height: 8),
          CustomTextField(
            controller: controller.transportDetailsController,
            hintText: "Détails du transport",
            labelText: "Informations transport",
            prefixIcon: Icons.directions_bus,
            borderColor: AppColors.secondary,
            focusedBorderColor: AppColors.primary,
          ),
        ],
        const SizedBox(height: 16),
        CustomTextField(
          controller: controller.medicalInformationController,
          hintText: "Informations médicales importantes",
          labelText: "Informations médicales",
          prefixIcon: Icons.medical_services,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controller.schoolInsuranceController,
          hintText: "Assurance scolaire",
          labelText: "Assurance",
          validator: controller.validateField,
          prefixIcon: Icons.verified_user,
          borderColor: AppColors.secondary,
          focusedBorderColor: AppColors.primary,
        ),
      ],
    );
  }
}
