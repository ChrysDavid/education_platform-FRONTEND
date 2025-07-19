// Modèle des pages intro
import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class IntroPage {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  IntroPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

// Widget des pages intro
class IntroPageWidget extends StatelessWidget {
  final IntroPage page;

  const IntroPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            duration: Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: page.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: page.color.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    page.icon,
                    size: 60,
                    color: page.color,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 40),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          SizedBox(height: 20),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          if (page.title.contains('Acteurs')) _buildActorsSection(),
        ],
      ),
    );
  }

  Widget _buildActorsSection() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Wrap(
        spacing: 15,
        runSpacing: 15,
        alignment: WrapAlignment.center,
        children: [
          _buildActorChip('Élèves', Icons.school, AppColors.primary),
          _buildActorChip('Étudiants', Icons.menu_book, AppColors.secondary),
          _buildActorChip(
              'Professeurs', Icons.person_outline, AppColors.success),
          _buildActorChip('Conseillers', Icons.psychology, AppColors.warning),
          _buildActorChip(
              'Entreprises', Icons.business, AppColors.textSecondary),
          _buildActorChip('Parents', Icons.family_restroom, AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildActorChip(String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
