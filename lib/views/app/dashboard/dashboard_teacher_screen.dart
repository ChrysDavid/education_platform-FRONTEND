import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class DashboardTeacherScreen extends StatelessWidget {
  const DashboardTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Tableau de bord - Enseignant",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),

          // 🔢 Statistiques clés
          _buildSectionTitle("Résumé d’activité"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard("Ressources", 18, Colors.blue),
              _buildStatCard("Quiz créés", 7, Colors.orange),
              _buildStatCard("Étudiants", 36, Colors.green),
            ],
          ),

          const SizedBox(height: 30),

          // ⏰ Prochains cours ou RDV
          _buildSectionTitle("Prochains rendez-vous"),
          _buildAppointmentTile(
            date: "23 Mai 2025",
            heure: "09h00",
            sujet: "Cours en présentiel - Physique",
          ),
          _buildAppointmentTile(
            date: "24 Mai 2025",
            heure: "15h30",
            sujet: "Visio avec la classe Terminale B",
          ),

          const SizedBox(height: 30),

          // 📦 Liens rapides
          _buildSectionTitle("Actions rapides"),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildQuickAction(Icons.upload_file, "Publier une ressource", () {
                // TODO : Naviguer vers l'écran d'ajout
              }),
              _buildQuickAction(Icons.quiz, "Créer un quiz", () {
                // TODO : Naviguer vers l'écran de création
              }),
              _buildQuickAction(Icons.people_alt, "Suivi des élèves", () {
                // TODO : Naviguer vers la liste d'élèves
              }),
              _buildQuickAction(Icons.schedule, "Gérer mes RDV", () {
                // TODO : Naviguer vers l'agenda
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(
            "$count",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentTile({
    required String date,
    required String heure,
    required String sujet,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.event, color: AppColors.primary),
        title: Text("$date à $heure"),
        subtitle: Text(sujet),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Détail du rendez-vous ou du cours
        },
      ),
    );
  }

  Widget _buildQuickAction(
      IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
