import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../quiz_challenge_screen.dart';
import '../quiz_assign_screen.dart';
import '../quiz_edit_screen.dart';
import '../quiz_question_edit_screen.dart';
import '../quiz_results_screen.dart';
import '../quiz_take_screen.dart';


class QuizDetailScreen extends StatefulWidget {
  final Quiz quiz;
  final bool isTeacher;
  
  const QuizDetailScreen({
    super.key,
    required this.quiz,
    required this.isTeacher,
  });

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  late List<QuizAttempt> _attempts;
  bool _isAssigning = false;
  bool _showAllQuestions = false;

  @override
  void initState() {
    super.initState();
    // Mock data for quiz attempts
    _attempts = [
      QuizAttempt(
        id: 'a1',
        quizId: widget.quiz.id,
        student: User(
          id: '201',
          name: 'Kouadio M.',
          profileImage: 'https://randomuser.me/api/portraits/men/33.jpg',
          isTeacher: false,
          className: 'L2 Info',
        ),
        startedAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        completedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2, minutes: 40)),
        score: 85,
        answers: List.generate(widget.quiz.questions.length, (index) => UserAnswer(
          questionId: widget.quiz.questions[index].id,
          selectedOptionIndex: (index % 4),
          isCorrect: index % 3 == 0,
        )),
      ),
      QuizAttempt(
        id: 'a2',
        quizId: widget.quiz.id,
        student: User(
          id: '202',
          name: 'Assemian K.',
          profileImage: 'https://randomuser.me/api/portraits/women/28.jpg',
          isTeacher: false,
          className: 'L2 Info',
        ),
        startedAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
        completedAt: DateTime.now().subtract(const Duration(days: 2, hours: 4, minutes: 45)),
        score: 92,
        answers: List.generate(widget.quiz.questions.length, (index) => UserAnswer(
          questionId: widget.quiz.questions[index].id,
          selectedOptionIndex: (index % 4),
          isCorrect: true,
        )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Détails du Quiz',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: widget.isTeacher
            ? [
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.white),
                  onPressed: () => _navigateToEditScreen(),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AppColors.white),
                  onPressed: _showDeleteConfirmationDialog,
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuizHeader(),
            _buildQuizDetails(),
            _buildQuizQuestions(),
            if (widget.isTeacher) _buildAttemptsSection(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomSheet: _buildBottomButtons(),
    );
  }

  Widget _buildQuizHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.quiz,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.quiz.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.timelapse,
                          color: AppColors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.quiz.timeLimit} minutes',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.help_outline,
                          color: AppColors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.quiz.questions.length} questions',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: widget.quiz.isPublic
                  ? AppColors.white.withOpacity(0.2)
                  : AppColors.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.quiz.isPublic ? Icons.public : Icons.lock,
                  color: AppColors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.quiz.isPublic ? 'Quiz public' : 'Quiz privé',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (widget.quiz.assignedToClassId != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.group,
                      color: AppColors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Assigné à: ${widget.quiz.assignedToClassId}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuizDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.quiz.description,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildDetailItem(
                icon: Icons.star,
                label: 'Points',
                value: '${widget.quiz.totalPoints}',
                color: AppColors.secondary,
              ),
              _buildDetailItem(
                icon: Icons.calendar_today,
                label: 'Créé le',
                value: '${widget.quiz.createdAt.day}/${widget.quiz.createdAt.month}/${widget.quiz.createdAt.year}',
                color: AppColors.primary,
              ),
              if (widget.quiz.endDate != null)
                _buildDetailItem(
                  icon: Icons.event,
                  label: 'Date limite',
                  value: '${widget.quiz.endDate!.day}/${widget.quiz.endDate!.month}/${widget.quiz.endDate!.year}',
                  color: AppColors.error,
                ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(widget.quiz.creator.profileImage),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Créé par ${widget.quiz.creator.name}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (widget.quiz.creator.subject != null)
                        Text(
                          widget.quiz.creator.subject!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizQuestions() {
    final displayedQuestions = _showAllQuestions 
        ? widget.quiz.questions 
        : widget.quiz.questions.take(3);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Aperçu des questions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (widget.isTeacher)
                TextButton.icon(
                  onPressed: _navigateToEditQuestions,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Modifier'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ...displayedQuestions.map((question) => _buildQuestionItem(question)),
          if (widget.quiz.questions.length > 3 && !_showAllQuestions)
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _showAllQuestions = true;
                  });
                },
                child: Text(
                  'Voir les ${widget.quiz.questions.length - 3} autres questions',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          if (_showAllQuestions)
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _showAllQuestions = false;
                  });
                },
                child: const Text(
                  'Voir moins',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionItem(QuizQuestion question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${widget.quiz.questions.indexOf(question) + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${question.points} pts',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          if (widget.isTeacher && !_isAssigning)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: question.options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final isCorrect = index == question.correctOptionIndex;
                  return Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isCorrect ? AppColors.success.withOpacity(0.1) : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCorrect ? AppColors.success : Colors.transparent,
                        width: isCorrect ? 1 : 0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          String.fromCharCode(65 + index),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isCorrect ? AppColors.success : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              color: isCorrect ? AppColors.success : AppColors.textSecondary,
                            ),
                          ),
                        ),
                        if (isCorrect)
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 16,
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAttemptsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tentatives des étudiants',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (_attempts.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Aucune tentative pour ce quiz pour le moment.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _attempts.length,
              itemBuilder: (context, index) {
                final attempt = _attempts[index];
                return _buildAttemptItem(attempt);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAttemptItem(QuizAttempt attempt) {
    final correctAnswers = attempt.answers.where((answer) => answer.isCorrect).length;
    final percentage = (attempt.score / widget.quiz.totalPoints) * 100;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => QuizResultsScreen(
                quiz: widget.quiz,
                attempt: attempt,
              ),
            ),
          );
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(attempt.student.profileImage),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attempt.student.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    attempt.student.className ?? 'Étudiant',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: AppColors.success,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$correctAnswers/${attempt.answers.length} réponses correctes',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.timer_outlined,
                        color: AppColors.textSecondary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDuration(attempt.startedAt, attempt.completedAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getScoreColor(percentage).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${percentage.toInt()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getScoreColor(percentage),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: widget.isTeacher
            ? Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isAssigning = !_isAssigning;
                        });
                      },
                      icon: Icon(_isAssigning ? Icons.close : Icons.group_add),
                      label: Text(_isAssigning ? 'Annuler' : 'Assigner'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isAssigning ? AppColors.error : AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  if (_isAssigning) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _navigateToAssignScreen,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Confirmer'),
                      ),
                    ),
                  ],
                ],
              )
            : ElevatedButton.icon(
                onPressed: () {
                  _showStartQuizDialog();
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Commencer le quiz'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
      ),
    );
  }

  String _formatDuration(DateTime start, DateTime? end) {
    if (end == null) return 'En cours';
    final duration = end.difference(start);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes min $seconds sec';
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return AppColors.success;
    if (percentage >= 60) return AppColors.secondary;
    return AppColors.error;
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ce quiz?'),
        content: const Text(
          'Cette action est irréversible. Toutes les données associées à ce quiz seront supprimées.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quiz supprimé avec succès!'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showStartQuizDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Commencer le quiz'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vous êtes sur le point de commencer ce quiz:',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.quiz,
              text: widget.quiz.title,
              color: AppColors.primary,
            ),
            _buildInfoRow(
              icon: Icons.help_outline,
              text: '${widget.quiz.questions.length} questions',
              color: AppColors.textSecondary,
            ),
            _buildInfoRow(
              icon: Icons.timer,
              text: 'Durée: ${widget.quiz.timeLimit} minutes',
              color: AppColors.secondary,
            ),
            _buildInfoRow(
              icon: Icons.star,
              text: 'Total: ${widget.quiz.totalPoints} points',
              color: AppColors.secondary,
            ),
            const SizedBox(height: 12),
            const Text(
              'Une fois commencé, vous ne pourrez pas mettre en pause. Êtes-vous prêt?',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Pas maintenant'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizTakeScreen(quiz: widget.quiz),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: const Text('Commencer'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: icon == Icons.quiz ? FontWeight.bold : FontWeight.normal,
                color: icon == Icons.quiz ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditScreen() async {
    final updatedQuiz = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizEditScreen(quiz: widget.quiz),
      ),
    );

    if (updatedQuiz != null && updatedQuiz is Quiz) {
      // Mettre à jour le quiz dans le parent
      Navigator.pop(context, updatedQuiz);
    }
  }

  void _navigateToAssignScreen() async {
    final updatedQuiz = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizAssignScreen(quiz: widget.quiz),
      ),
    );

    if (updatedQuiz != null && updatedQuiz is Quiz) {
      // Mettre à jour le quiz dans le parent
      Navigator.pop(context, updatedQuiz);
    }
  }

  void _navigateToEditQuestions() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text('Gestion des questions'),
          ),
          body: ListView.builder(
            itemCount: widget.quiz.questions.length,
            itemBuilder: (context, index) {
              final question = widget.quiz.questions[index];
              return ListTile(
                title: Text('Question ${index + 1}'),
                subtitle: Text(question.question),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    // ignore: unused_local_variable
                    final updatedQuestion = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizQuestionEditScreen(
                          question: question,
                          isEditing: true,
                        ),
                      ),
                    );
                    // Gérer la mise à jour de la question
                  },
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // ignore: unused_local_variable
              final newQuestion = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const QuizQuestionEditScreen(
                    isEditing: false,
                  ),
                ),
              );
              // Ajouter la nouvelle question
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}