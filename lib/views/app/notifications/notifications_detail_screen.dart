import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';


class NotificationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> notification;

  const NotificationDetailScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Détails de la notification'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: notification['color'].withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notification['icon'],
                  color: notification['color'],
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              notification['title'],
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              notification['time'],
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                notification['message'],
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (notification['type'] == 'quiz')
              _buildQuizDetails(),
            if (notification['type'] == 'challenge')
              _buildChallengeDetails(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Action selon le type de notification
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  notification['type'] == 'quiz' 
                    ? 'Commencer le quiz' 
                    : 'Voir le challenge',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Détails du quiz',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12),
        _buildDetailRow('Professeur', 'Dr. Koné'),
        _buildDetailRow('Matière', 'Mathématiques'),
        _buildDetailRow('Nombre de questions', '20'),
        _buildDetailRow('Durée', '30 minutes'),
        _buildDetailRow('Score maximum', '20 points'),
      ],
    );
  }

  Widget _buildChallengeDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Détails du challenge',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12),
        _buildDetailRow('Créé par', 'Prof. Diallo'),
        _buildDetailRow('Type', 'Public'),
        _buildDetailRow('Participants', '45 étudiants'),
        _buildDetailRow('Durée', '7 jours'),
        _buildDetailRow('Votre position', '3ème sur 45'),
        const SizedBox(height: 16),
        Text(
          'Classement actuel',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildLeaderboardItem('1. Fatou Diop', '92%', true),
        _buildLeaderboardItem('2. Amadou Keita', '88%', true),
        _buildLeaderboardItem('3. Vous', '85%', false),
        _buildLeaderboardItem('4. Aïcha Cissé', '82%', true),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(String name, String score, bool isOther) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: isOther ? AppColors.surfaceVariant : AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: !isOther
            ? Border.all(color: AppColors.primary.withOpacity(0.3))
            : null,
      ),
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: !isOther ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const Spacer(),
          Text(
            score,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}