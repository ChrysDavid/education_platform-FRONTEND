// ignore: file_names
import 'package:education_platform_frontend_flutter/core/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_colors.dart';
import '../app/main_app_screen.dart';


class SuccessRegistrationScreen extends StatelessWidget {
  final UserModel user;

  const SuccessRegistrationScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ Animation de succès (nécessite un fichier Lottie)
                SizedBox(
                  height: 200,
                  child: Lottie.asset(
                    'assets/animations/success.json',
                    repeat: false,
                  ),
                ),
                const SizedBox(height: 30),

                const Text(
                  "Inscription réussie 🎉",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                const Text(
                  "Votre compte a bien été créé.\nBienvenue dans Orientation CI !",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // ✅ Bouton pour aller à la page principale
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MainAppScreen(
                          user: user,
                        ),
                      ),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Aller à l'application"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
