import 'package:flutter/material.dart';
import 'package:education_platform_frontend_flutter/core/models/user_model.dart';

// Écrans d'authentification
import '../views/auth/forgot_password/forgot_password.dart';
import '../views/auth/login/login_screen.dart';
import '../views/auth/choose_role/choose_role_screen.dart';
import '../views/auth/register_student/register_student_screen.dart';
import '../views/auth/register_teacher/register_teacher_screen.dart';
import '../views/auth/register_advisor/register_advisor_screen.dart';
import '../views/auth/register_pupil/register_pupil_screen.dart';

// Écrans communs
import '../views/common/splash_screen.dart';
import '../views/common/intro_screen.dart';
import '../views/common/error_screen.dart';
import '../views/common/success_registraction_Screen.dart';

// Page principale
import '../views/app/main_app_screen.dart';

class AppRoutes {
  // === Routes statiques ===
  static const String splash = '/';
  static const String intro = '/intro';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String chooseRole = '/choose-role';
  static const String registerStudent = '/register-student';
  static const String registerPupil = '/register-pupil';
  static const String registerTeacher = '/register-teacher';
  static const String registerAdvisor = '/register-advisor';
  static const String successRegistration = '/success-registration';
  static const String mainApp = '/main-app';

  // === Route Generator ===
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // === Écrans initiaux ===
      case splash:
        return _buildRoute(const SplashScreen());
      case intro:
        return _buildRoute(const IntroScreen());

      // === Authentification ===
      case login:
        return _buildRoute(const LoginScreen());
      case forgotPassword:
        return _buildRoute(const ForgotPasswordScreen());
      case chooseRole:
        return _buildRoute(const ChooseRoleScreen());

      // === Inscription ===
      case registerStudent:
        return _buildRoute(const RegisterStudentScreen());
      case registerPupil:
        return _buildRoute(const RegisterPupilScreen());
      case registerTeacher:
        return _buildRoute(const RegisterTeacherScreen());
      case registerAdvisor:
        return _buildRoute(const RegisterAdvisorScreen());

      // === Écrans de statut ===
      case successRegistration:
        if (args is UserModel) {
          return _buildRoute(
            SuccessRegistrationScreen(user: args),
          );
        }
        return _errorRoute("Données utilisateur manquantes");

      // === Application principale ===
      case mainApp:
        if (args is UserModel) {
          return _buildRoute(
            MainAppScreen(user: args),
          );
        }
        return _errorRoute("Utilisateur non authentifié");

      // === Route inconnue ===
      default:
        return _errorRoute("Route non trouvée");
    }
  }

  // === Méthodes helper ===
  static MaterialPageRoute _buildRoute(Widget widget) {
    return MaterialPageRoute(
      builder: (_) => widget,
      fullscreenDialog: false,
    );
  }

  static MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => ErrorScreen(errorMessage: message),
    );
  }

  // === Getters pour les noms de routes ===
  static String get initialRoute => splash;

  // === Méthodes de navigation ===
  static Future<void> navigateToMainApp(BuildContext context, UserModel user) {
    return Navigator.pushReplacementNamed(
      context,
      mainApp,
      arguments: user,
    );
  }

  static Future<void> navigateToLogin(BuildContext context) {
    return Navigator.pushReplacementNamed(
      context,
      login,
    );
  }

  static Future<void> navigateToRegistrationSuccess(
      BuildContext context, UserModel user) {
    return Navigator.pushReplacementNamed(
      context,
      successRegistration,
      arguments: user,
    );
  }

  // === Vérification des routes protégées ===
  static bool isProtectedRoute(String routeName) {
    return [
      mainApp,
      // Ajouter d'autres routes protégées ici
    ].contains(routeName);
  }

  // === Redirection basée sur l'authentification ===
  static String getRedirectRoute(bool isAuthenticated, String? currentRoute) {
    if (isAuthenticated) {
      if (currentRoute == login || currentRoute == splash) {
        return mainApp;
      }
      return currentRoute ?? mainApp;
    } else {
      if (isProtectedRoute(currentRoute ?? '')) {
        return login;
      }
      return currentRoute ?? login;
    }
  }
}