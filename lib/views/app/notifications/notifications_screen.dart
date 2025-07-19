import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'notifications_detail_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Nouvelles notifications'),
          const SizedBox(height: 8),
          _buildNotificationItem(
            context,
            icon: Icons.quiz,
            title: 'Nouveau quiz disponible',
            message:
                'Le professeur Koné a publié un nouveau quiz sur les mathématiques',
            time: 'Il y a 2 heures',
            isRead: false,
            color: AppColors.primary,
            type: 'quiz',
          ),
          _buildNotificationItem(
            context,
            icon: Icons.emoji_events,
            title: 'Challenge terminé',
            message:
                'Vous avez terminé le challenge "Histoire-Géo" à la 3ème place',
            time: 'Hier',
            isRead: true,
            color: AppColors.secondary,
            type: 'challenge',
          ),
          _buildNotificationItem(
            context,
            icon: Icons.assignment_turned_in,
            title: 'Quiz noté',
            message: 'Votre quiz sur la biologie a été corrigé. Score: 18/20',
            time: 'Avant-hier',
            isRead: true,
            color: AppColors.success,
            type: 'quiz',
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Plus anciennes'),
          const SizedBox(height: 8),
          _buildNotificationItem(
            context,
            icon: Icons.group,
            title: 'Invitation à un challenge',
            message:
                'Le professeur Diallo vous invite à participer à un challenge privé',
            time: 'Il y a 1 semaine',
            isRead: true,
            color: AppColors.warning,
            type: 'challenge',
          ),
          _buildNotificationItem(
            context,
            icon: Icons.notification_important,
            title: 'Rappel',
            message:
                'Il vous reste 2 jours pour terminer le quiz "Physique-Chimie"',
            time: 'Il y a 2 semaines',
            isRead: true,
            color: AppColors.error,
            type: 'quiz',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
    required String time,
    required bool isRead,
    required Color color,
    required String type,
  }) {
    final Map<String, dynamic> notification = {
      'icon': icon,
      'title': title,
      'message': message,
      'time': time,
      'isRead': isRead,
      'color': color,
      'type': type,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  NotificationDetailScreen(notification: notification),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight:
                                  isRead ? FontWeight.normal : FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      time,
                      style: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
