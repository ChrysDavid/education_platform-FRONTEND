import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../quiz_challenge_screen.dart';

class QuizResultsScreen extends StatelessWidget {
  final Quiz quiz;
  final QuizAttempt attempt;
  
  const QuizResultsScreen({
    super.key,
    required this.quiz,
    required this.attempt,
  });

  @override
  Widget build(BuildContext context) {
    final correctAnswers = attempt.answers.where((a) => a.isCorrect).length;
    final percentage = (attempt.score / quiz.totalPoints) * 100;
    final duration = attempt.completedAt?.difference(attempt.startedAt) ?? Duration.zero;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Résultats du Quiz',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildScoreSummary(correctAnswers, percentage, duration),
            const SizedBox(height: 24),
            _buildQuestionResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSummary(int correctAnswers, double percentage, Duration duration) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Votre score',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 12,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getScoreColor(percentage),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(percentage),
                      ),
                    ),
                    Text(
                      '${attempt.score}/${quiz.totalPoints} pts',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  icon: Icons.check_circle,
                  value: '$correctAnswers',
                  label: 'Correctes',
                  color: AppColors.success,
                ),
                _buildStatItem(
                  icon: Icons.cancel,
                  value: '${quiz.questions.length - correctAnswers}',
                  label: 'Incorrectes',
                  color: AppColors.error,
                ),
                _buildStatItem(
                  icon: Icons.timer,
                  value: '${duration.inMinutes}m ${duration.inSeconds % 60}s',
                  label: 'Durée',
                  color: AppColors.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Détail des réponses',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ...quiz.questions.map((question) {
          final userAnswer = attempt.answers.firstWhere(
            (a) => a.questionId == question.id,
            orElse: () => UserAnswer(
              questionId: question.id,
              selectedOptionIndex: -1,
              isCorrect: false,
            ),
          );
          
          return _buildQuestionItem(question, userAnswer);
        }),
      ],
    );
  }

  Widget _buildQuestionItem(QuizQuestion question, UserAnswer userAnswer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: userAnswer.isCorrect 
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    userAnswer.isCorrect ? Icons.check : Icons.close,
                    color: userAnswer.isCorrect ? AppColors.success : AppColors.error,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question.question,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '${question.points} pts',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isCorrect = index == question.correctOptionIndex;
              final isSelected = index == userAnswer.selectedOptionIndex;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isCorrect 
                      ? AppColors.success.withOpacity(0.1)
                      : isSelected
                          ? AppColors.error.withOpacity(0.1)
                          : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isCorrect 
                        ? AppColors.success
                        : isSelected
                            ? AppColors.error
                            : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '${String.fromCharCode(65 + index)}.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isCorrect 
                            ? AppColors.success
                            : isSelected
                                ? AppColors.error
                                : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isCorrect 
                              ? AppColors.success
                              : isSelected
                                  ? AppColors.error
                                  : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    if (isCorrect)
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 16,
                      ),
                    if (isSelected && !isCorrect)
                      const Icon(
                        Icons.cancel,
                        color: AppColors.error,
                        size: 16,
                      ),
                  ],
                ),
              );
            }),
            if (question.explanation != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Explication: ${question.explanation}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return AppColors.success;
    if (percentage >= 60) return AppColors.secondary;
    return AppColors.error;
  }
}