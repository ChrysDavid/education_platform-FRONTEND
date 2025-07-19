import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class DashboardPupilScreen extends StatelessWidget {
  const DashboardPupilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dahboard Eleve"),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        centerTitle: true,
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Mon tableau de bord - Élève",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),

          // 🔍 Suivi d’orientation
          _buildSectionTitle("Mon parcours d’orientation"),
          _buildOrientationCard("Parcours proposé", 40, "En cours"),
          _buildOrientationCard("Plan d’objectifs", 75, "Objectif : Terminale"),

          const SizedBox(height: 30),

          // 📊 Évaluations et quiz
          _buildSectionTitle("Mes évaluations"),
          _buildEvaluationProgressTile("Test d’intérêts", "Terminé", 100),
          _buildEvaluationProgressTile("Quiz sur les métiers", "En cours", 60),

          const SizedBox(height: 30),

          // 📅 Activités à venir
          _buildSectionTitle("À venir"),
          _buildActivityTile("Rendez-vous d’orientation", "24 Mai 2025 à 10h", Icons.event_note),
          _buildActivityTile("Quiz de personnalité", "25 Mai 2025 à 14h", Icons.quiz),

          const SizedBox(height: 30),

          // 📚 Accès rapide
          _buildSectionTitle("Accès rapide"),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildQuickAction(Icons.book, "Voir mes cours", () {
                // TODO: Naviguer vers les ressources
              }),
              _buildQuickAction(Icons.school, "Mon établissement", () {
                // TODO: Afficher les infos de l’école
              }),
              _buildQuickAction(Icons.assessment, "Tests disponibles", () {
                // TODO: Naviguer vers la liste des évaluations
              }),
              _buildQuickAction(Icons.person_search, "Contacter un conseiller", () {
                // TODO: Ouvrir chat ou liste de conseillers
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

  Widget _buildOrientationCard(String title, int progress, String status) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey.shade300,
              color: AppColors.primary,
            ),
            const SizedBox(height: 4),
            Text("Progression : $progress% • Statut : $status"),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Détail du parcours
        },
      ),
    );
  }

  Widget _buildEvaluationProgressTile(String name, String status, int progress) {
    return ListTile(
      leading: const Icon(Icons.task_alt, color: AppColors.primary),
      title: Text(name),
      subtitle: Text("Statut : $status - Progression : $progress%"),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // TODO: Détail de l'évaluation
      },
    );
  }

  Widget _buildActivityTile(String title, String dateTime, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.secondary),
        title: Text(title),
        subtitle: Text(dateTime),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Détail ou lancement activité
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
