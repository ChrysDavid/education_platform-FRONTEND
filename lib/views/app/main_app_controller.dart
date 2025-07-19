// ignore: unused_import
import 'package:education_platform_frontend_flutter/core/models/user_model.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'chat/chat_list_screen.dart';
import 'dashboard/dashboard_advisor_screen.dart';
// ignore: unused_import
import 'dashboard/dashboard_student_screen.dart';
import 'dashboard/dashboard_teacher_screen.dart';
import 'forum/forum_list_screen.dart';
import 'notifications/notifications_screen.dart';
import 'network/network_screen.dart';
import 'quiz_challenge/quiz_challenge_screen.dart';
import 'quiz_challenge/search_challenge_quiz.dart';
import 'forum/search_forum_screen.dart';

class MainAppController {
  int pageIndex = 0;
  final UserModel user;

  MainAppController({required this.user,});

  void setPageIndex(int index) {
    pageIndex = index;
  }

  Widget getPage() {
    final pages = <Widget>[
      const ForumListScreen(),
    ];

    // Ajout dynamique des pages selon rôle
    if (user.isVerified) {
      if (user.type == 'student') {
        pages.add(const NetworkScreen());
        pages.add(const DashboardAdvisorScreen());
        pages.add(const ChatListScreen());
      } else if (user.type == 'pupil') {
        pages.add(const NetworkScreen());
        pages.add(const QuizChallengeListScreen(isTeacher: false));
        pages.add(const ChatListScreen());
      } else if (user.type == 'teacher') {
        pages.add(const DashboardTeacherScreen());
        pages.add(const QuizChallengeListScreen(isTeacher: true));
        pages.add(const ChatListScreen());
      } else if (user.type == 'advisor') {
        pages.add(const DashboardAdvisorScreen());
        pages.add(const QuizChallengeListScreen(isTeacher: true));
        pages.add(const ChatListScreen());
      }
      // else if (type == 'parent') {
      //   pages.add(const DashboardParentScreen());
      // } else if (type == 'entreprise') {
      //   pages.add(const DashboardCompanyScreen());
      // }
    }

    // Profil toujours à la fin
    // pages.add(const ProfileScreen());

    if (pageIndex >= pages.length) {
      return const ForumListScreen();
    }

    return pages[pageIndex];
  }

  String getTitle() {
    final titles = <String>[
      'Accueil',
    ];

    if (user.isVerified) {
      switch (user.type) {
        case 'student':
          titles.addAll(['Réseaux', 'Quiz et Challenge', 'Messagerie']);
          break;
        case 'pupil':
          titles.addAll(['Réseaux', 'Quiz', 'Messagerie']);
          break;
        case 'teacher':
          titles.addAll(['Tableau de bord', 'Quiz et Challenge', 'Messagerie']);
          break;
        case 'advisor':
          titles.addAll(['Orientation', 'Questionnaire', 'Messagerie']);
          break;
        // case 'parent':
        //   titles.add('Suivi des enfants');
        //   break;
        // case 'entreprise':
        //   titles.add('Mon espace entreprise');
        //   break;
      }
    }

    // titles.add('Mon profil');

    return pageIndex < titles.length ? titles[pageIndex] : 'Accueil';
  }

  List<Widget> getNavigationIcons() {
    final icons = <Widget>[
      const Icon(Icons.home, size: 30, color: Colors.white),
    ];

    if (user.isVerified) {
      switch (user.type) {
        case 'student':
          icons.addAll([
            const Icon(Icons.people, size: 30, color: Colors.white),
            const Icon(Icons.quiz, size: 30, color: Colors.white),
            const Icon(Icons.chat, size: 30, color: Colors.white),
          ]);
          break;
        case 'pupil':
          icons.addAll([
            const Icon(Icons.people, size: 30, color: Colors.white),
            const Icon(Icons.quiz, size: 30, color: Colors.white),
            const Icon(Icons.chat, size: 30, color: Colors.white),
          ]);
          break;
        case 'teacher':
          icons.addAll([
            const Icon(Icons.dashboard, size: 30, color: Colors.white),
            const Icon(Icons.quiz, size: 30, color: Colors.white),
            const Icon(Icons.chat, size: 30, color: Colors.white),
          ]);
          break;
        case 'advisor':
          icons.addAll([
            const Icon(Icons.school, size: 30, color: Colors.white),
            const Icon(Icons.quiz, size: 30, color: Colors.white),
            const Icon(Icons.chat, size: 30, color: Colors.white),
          ]);
          break;
        // case 'parent':
        //   icons.add(
        //       const Icon(Icons.family_restroom, size: 30, color: Colors.white));
        //   break;
        // case 'entreprise':
        //   icons.add(
        //       const Icon(Icons.business_center, size: 30, color: Colors.white));
        //   break;
      }
    }

    // icons.add(const Icon(Icons.person, size: 30, color: Colors.white));
    return icons;
  }

  List<Widget> getAppBarActions(
      BuildContext context, VoidCallback onPageChange) {
    final visiblePages = _getVisiblePageIndexes();

    switch (visiblePages[pageIndex]) {
      case 0:
        return [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchForumScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.white),
            onPressed: () {
              setPageIndex(visiblePages.indexOf(4));
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
        ];

      case 1: // Réseaux
        return [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.white),
            onPressed: () {
              // Action de filtrage
            },
          ),
        ];

      case 2: // Quiz
        return [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QuizChallengeSearchScreen()),
              );
            },
          ),
        ];

      case 3: // Chat
        return [
          IconButton(
            icon: const Icon(Icons.mark_chat_read, color: AppColors.white),
            onPressed: () {
              // Marquer toutes comme lues
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: AppColors.white),
            onPressed: () {
              // Effacer toutes les notifications
            },
          ),
        ];

      // case 4: // Profil
      //   return [
      //     IconButton(
      //       icon: const Icon(Icons.edit, color: AppColors.white),
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (_) => EditProfilePage()),
      //         );
      //       },
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.settings, color: AppColors.white),
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (_) => SettingsPage()),
      //         );
      //       },
      //     ),
      //   ];

      default:
        return [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.white),
            onPressed: () {
              setPageIndex(visiblePages.indexOf(4));
              onPageChange();
            },
          ),
        ];
    }
  }

  // Liste complète des index visibles, utile pour l’appBar
  List<int> _getVisiblePageIndexes() {
    final visible = <int>[0];

    if (user.isVerified) {
      visible.addAll([1, 2, 3]);
    }

    // visible.add(4); // Profil
    return visible;
  }
}
