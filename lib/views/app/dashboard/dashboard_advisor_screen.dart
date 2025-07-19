import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class DashboardAdvisorScreen extends StatelessWidget {
  const DashboardAdvisorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Tableau de bord - Conseiller d'orientation",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),

          // 🔢 Résumé des évaluations
          _buildSectionTitle("Évaluations d'orientation"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard("En attente", 5, Colors.orange),
              _buildStatCard("En cours", 3, Colors.blue),
              _buildStatCard("Terminées", 12, Colors.green),
            ],
          ),

          const SizedBox(height: 30),

          // 👨‍🎓 Derniers étudiants suivis
          _buildSectionTitle("Étudiants suivis récemment"),
          _buildStudentTile("Kouadio Serge", "Bac +1 | En attente de parcours"),
          _buildStudentTile("Tra Bi Inès", "Bac | Parcours validé"),
          _buildStudentTile("Mohamed Diabaté", "Terminale | Évaluation lancée"),

          const SizedBox(height: 30),

          // 📅 Prochains rendez-vous
          _buildSectionTitle("Prochains rendez-vous"),
          _buildAppointmentTile(
            context,
            date: "23 Mai 2025",
            heure: "10h30",
            nom: "Fatou Koné",
            motif: "Retour sur test d'orientation",
          ),
          _buildAppointmentTile(
            context,
            date: "24 Mai 2025",
            heure: "14h00",
            nom: "Jean Kouakou",
            motif: "Révision du parcours proposé",
          ),

          const SizedBox(height: 30),

          // 🔍 Liens rapides
          _buildSectionTitle("Actions rapides"),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildQuickAction(Icons.search, "Explorer les évaluations", () {
                // TODO : Naviguer vers la page d'évaluations
              }),
              _buildQuickAction(Icons.school, "Parcours étudiants", () {
                // TODO : Naviguer vers les parcours
              }),
              _buildQuickAction(Icons.event, "Tous mes rendez-vous", () {
                // TODO : Naviguer vers le planning
              }),
              _buildQuickAction(Icons.checklist, "Suggestions IA", () {
                // TODO : Vers les suggestions automatiques
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

  Widget _buildStatCard(String label, int value, Color color) {
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
            "$value",
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

  Widget _buildStudentTile(String name, String subtitle) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: AppColors.primary,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(name),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // TODO: Naviguer vers la fiche étudiant
      },
    );
  }

  Widget _buildAppointmentTile(
    BuildContext context, {
    required String date,
    required String heure,
    required String nom,
    required String motif,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: AppColors.primary),
        title: Text("$nom - $date à $heure"),
        subtitle: Text(motif),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Naviguer vers le détail du rendez-vous
        },
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
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
