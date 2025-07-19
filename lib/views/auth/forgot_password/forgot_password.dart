import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/header_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  void _resetPassword() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer votre email')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // Simuler une requête réseau
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Un lien de réinitialisation a été envoyé à ${_emailController.text}'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          HeaderWidget(
            animationController: _animationController,
            title: "MOT DE PASSE OUBLIÉ",
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 220),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Réinitialisation",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Entrez votre email pour recevoir un lien de réinitialisation",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Champ email
                      CustomTextField(
                        controller: _emailController,
                        hintText: "Email",
                        validator: _validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email,
                        borderColor: AppColors.secondary,
                        focusedBorderColor: AppColors.primary,
                      ),
                      const SizedBox(height: 30),

                      // Bouton de réinitialisation
                      CustomButton(
                        label: "Envoyer le lien",
                        isLoading: _isLoading,
                        onPressed: _resetPassword,
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.white,
                        borderRadius: 30,
                        icon: const Icon(Icons.send, color: AppColors.white),
                      ),

                      const SizedBox(height: 20),

                      // Bouton de retour
                      CustomButton(
                        label: "Retour à la connexion",
                        onPressed: () => Navigator.pop(context),
                        backgroundColor: AppColors.white,
                        textColor: AppColors.secondary,
                        borderRadius: 30,
                        borderColor: AppColors.secondary,
                        icon: const Icon(Icons.arrow_back, 
                            color: AppColors.secondary),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Message version
                Center(
                  child: Text(
                    "Orientation CI - Version 1.0",
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}