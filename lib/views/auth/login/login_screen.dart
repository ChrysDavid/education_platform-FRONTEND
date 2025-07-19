import 'package:flutter/material.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/header_widget.dart';
import '../forgot_password/forgot_password.dart';
import 'login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late LoginController _controller;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _controller = LoginController(context);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // En-tête avec couleurs du drapeau et animations
          HeaderWidget(
            animationController: _animationController,
            title: "ORIENTATION CI",
          ),

          // Formulaire de connexion
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
                  child: Form(
                    key: _controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bienvenue 👋",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary, // Vert
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Connectez-vous pour continuer",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Champ email
                        CustomTextField(
                          controller: _controller.emailController,
                          hintText: "Email",
                          validator: _controller.validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email,
                          borderColor: AppColors.secondary, // Orange
                          focusedBorderColor: AppColors.primary, // Vert
                        ),
                        const SizedBox(height: 20),

                        // Champ mot de passe
                        CustomTextField(
                          controller: _controller.passwordController,
                          hintText: "Mot de passe",
                          validator: _controller.validatePassword,
                          obscureText: true,
                          prefixIcon: Icons.lock,
                          borderColor: AppColors.secondary, // Orange
                          focusedBorderColor: AppColors.primary, // Vert
                        ),

                        // Option "Se souvenir de moi" et "Mot de passe oublié"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                    activeColor: AppColors.primary, // Vert
                                  ),
                                  Flexible(
                                    child: Text(
                                      "Se souvenir de moi",
                                      style: TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Mot de passe oublié?",
                                style: TextStyle(
                                  color: AppColors.secondary, // Orange
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Bouton de connexion
                        CustomButton(
                          label: "Connexion",
                          isLoading: _controller.isLoading,
                          onPressed: _controller.login,
                          backgroundColor: AppColors.primary, // Vert
                          textColor: AppColors.white,
                          borderRadius: 30,
                          icon: const Icon(Icons.login, color: AppColors.white),
                        ),

                        const SizedBox(height: 20),

                        // Séparateur
                        Row(
                          children: const [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "OU",
                                style:
                                    TextStyle(color: AppColors.textSecondary),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Bouton de création de compte
                        CustomButton(
                          label: "Créer un compte",
                          onPressed: _controller.goToRegister,
                          backgroundColor: AppColors.white,
                          textColor: AppColors.secondary, // Orange
                          borderRadius: 30,
                          borderColor: AppColors.secondary, // Orange
                          icon: const Icon(Icons.person_add,
                              color: AppColors.secondary),
                        ),
                      ],
                    ),
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
