import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'challenge/challenge_create_screen.dart';
// ignore: unused_import
import 'challenge/challenge_detail_screen.dart';
import 'quiz/create/quiz_create_screen.dart';
import 'quiz/detail/quiz_detail_screen.dart';


class QuizChallengeListScreen extends StatefulWidget {
  final bool isTeacher;
  
  const QuizChallengeListScreen({
    super.key,
    required this.isTeacher,
  });

  @override
  State<QuizChallengeListScreen> createState() => _QuizChallengeListScreenState();
}

class _QuizChallengeListScreenState extends State<QuizChallengeListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // ignore: unused_field
  int _currentIndex = 0;
  bool _showOnlyMyContent = false;
  String _filterOption = 'Tous';
  
  final List<String> _filterOptions = [
    'Tous', 
    'Public', 
    'Privé', 
    'Pour moi',
    'Ma classe'
  ];
  
  // Mock data
  final List<Quiz> _quizzes = [
    Quiz(
      id: '1',
      title: 'Mathématiques: Équations du second degré',
      description: 'Quiz sur la résolution des équations du second degré.',
      creator: User(
        id: '101',
        name: 'Prof. Konan',
        profileImage: 'https://randomuser.me/api/portraits/men/32.jpg',
        isTeacher: true,
        subject: 'Mathématiques'
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isPublic: true,
      questions: List.generate(10, (index) => QuizQuestion(
        id: 'q$index',
        question: 'Question ${index + 1}',
        options: ['Option A', 'Option B', 'Option C', 'Option D'],
        correctOptionIndex: 1,
        points: 10,
      )),
      totalPoints: 100,
      timeLimit: 30,
    ),
    Quiz(
      id: '2',
      title: 'Histoire: La Côte d\'Ivoire coloniale',
      description: 'Test sur l\'histoire de la Côte d\'Ivoire pendant la période coloniale.',
      creator: User(
        id: '102',
        name: 'Prof. Kouassi',
        profileImage: 'https://randomuser.me/api/portraits/women/22.jpg',
        isTeacher: true,
        subject: 'Histoire'
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      isPublic: true,
      questions: List.generate(15, (index) => QuizQuestion(
        id: 'q$index',
        question: 'Question ${index + 1}',
        options: ['Option A', 'Option B', 'Option C', 'Option D'],
        correctOptionIndex: 2,
        points: 10,
      )),
      totalPoints: 150,
      timeLimit: 45,
      assignedToClassId: 'C1',
    ),
  ];
  
  final List<Challenge> _challenges = [
    Challenge(
      id: '1',
      title: 'Challenge Programmation: Création d\'une application',
      description: 'Développez une application simple qui permet de calculer le niveau de stress des étudiants.',
      creator: User(
        id: '101',
        name: 'Prof. Bakayoko',
        profileImage: 'https://randomuser.me/api/portraits/men/45.jpg',
        isTeacher: true,
        subject: 'Informatique'
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 20)),
      isPublic: true,
      tasks: ['Tâche 1', 'Tâche 2', 'Tâche 3'],
      totalPoints: 300,
      leaderboard: [
        UserScore(
          user: User(
            id: '201',
            name: 'Aya K.',
            profileImage: 'https://randomuser.me/api/portraits/women/65.jpg',
            isTeacher: false,
            className: 'L3 Info'
          ),
          score: 250,
          position: 1,
          lastUpdated: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        UserScore(
          user: User(
            id: '202',
            name: 'Mamadou S.',
            profileImage: 'https://randomuser.me/api/portraits/men/22.jpg',
            isTeacher: false,
            className: 'L3 Info'
          ),
          score: 220,
          position: 2,
          lastUpdated: DateTime.now().subtract(const Duration(hours: 10)),
        ),
      ],
    ),
    Challenge(
      id: '2',
      title: 'Challenge Littérature: Rédaction d\'une nouvelle',
      description: 'Rédigez une nouvelle sur le thème de la jeunesse africaine contemporaine.',
      creator: User(
        id: '103',
        name: 'Prof. Coulibaly',
        profileImage: 'https://randomuser.me/api/portraits/women/28.jpg',
        isTeacher: true,
        subject: 'Littérature'
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 14)),
      isPublic: false,
      assignedToClassId: 'L2 Lettres',
      tasks: ['Rédaction', 'Édition', 'Soumission'],
      totalPoints: 200,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterOptions(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildQuizList(),
                _buildChallengeList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: widget.isTeacher
    ? FloatingActionButton(
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.add, color: AppColors.white),
        onPressed: () => _showCreateOptions(context),
      )
    : null,
    );
  }

  void _showCreateOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Que souhaitez-vous créer ?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.quiz, color: AppColors.primary),
              title: const Text("Créer un Quiz"),
              onTap: () {
                Navigator.pop(context); // Ferme le modal
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizCreateScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag, color: AppColors.secondary),
              title: const Text("Créer un Challenge"),
              onTap: () {
                Navigator.pop(context); // Ferme le modal
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChallengeCreateScreen()),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}


  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.isTeacher ? 'Gestion des activités' : 'Activités pédagogiques',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.secondary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: const [
              Tab(text: 'Quiz'),
              Tab(text: 'Challenges'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.surfaceVariant,
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _filterOption,
                icon: const Icon(Icons.filter_list, color: AppColors.primary),
                style: const TextStyle(color: AppColors.textPrimary),
                onChanged: (String? newValue) {
                  setState(() {
                    _filterOption = newValue!;
                  });
                },
                items: _filterOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          if (widget.isTeacher)
            Row(
              children: [
                const Text(
                  'Mes créations uniquement',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                Switch(
                  value: _showOnlyMyContent,
                  onChanged: (value) {
                    setState(() {
                      _showOnlyMyContent = value;
                    });
                  },
                  activeColor: AppColors.primary,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildQuizList() {
    return _quizzes.isEmpty
        ? _buildEmptyState('quiz')
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _quizzes.length,
            itemBuilder: (context, index) {
              final quiz = _quizzes[index];
              return _buildQuizCard(quiz);
            },
          );
  }

  Widget _buildChallengeList() {
    return _challenges.isEmpty
        ? _buildEmptyState('challenge')
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _challenges.length,
            itemBuilder: (context, index) {
              final challenge = _challenges[index];
              return _buildChallengeCard(challenge);
            },
          );
  }

  Widget _buildEmptyState(String type) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            type == 'quiz' ? Icons.quiz : Icons.emoji_events,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            widget.isTeacher
                ? 'Vous n\'avez pas encore créé de ${type == 'quiz' ? 'quiz' : 'challenge'}'
                : 'Aucun ${type == 'quiz' ? 'quiz' : 'challenge'} disponible',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          if (widget.isTeacher)
            Text(
              'Appuyez sur + pour en créer un',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuizCard(Quiz quiz) {
    final bool isAssigned = quiz.assignedToClassId != null || quiz.assignedToStudentIds != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isAssigned ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
          width: isAssigned ? 1 : 0,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => QuizDetailScreen(quiz: quiz, isTeacher: widget.isTeacher),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(
              title: quiz.title,
              iconData: Icons.quiz,
              isPublic: quiz.isPublic,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quiz.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.help_outline, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${quiz.questions.length} questions',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.timer_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${quiz.timeLimit} min',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.star_outline, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${quiz.totalPoints} pts',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            _buildCardFooter(
              creator: quiz.creator,
              createdAt: quiz.createdAt,
              assignedType: quiz.assignedToClassId != null 
                ? 'Classe' 
                : quiz.assignedToStudentIds != null 
                  ? 'Étudiants' 
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard(Challenge challenge) {
    final bool isAssigned = challenge.assignedToClassId != null || challenge.assignedToStudentIds != null;
    final bool hasLeaderboard = challenge.leaderboard != null && challenge.leaderboard!.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isAssigned ? AppColors.secondary.withOpacity(0.3) : Colors.transparent,
          width: isAssigned ? 1 : 0,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => ChallengeDetailScreen(challenge: challenge, isTeacher: widget.isTeacher),
          //   ),
          // );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(
              title: challenge.title,
              iconData: Icons.emoji_events,
              isPublic: challenge.isPublic,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.task_alt, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${challenge.tasks.length} tâches',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.event, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        'Fin le ${challenge.endDate.day}/${challenge.endDate.month}/${challenge.endDate.year}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star_outline, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${challenge.totalPoints} pts',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (hasLeaderboard) _buildLeaderboard(challenge),
            const Divider(height: 1),
            _buildCardFooter(
              creator: challenge.creator,
              createdAt: challenge.createdAt,
              assignedType: challenge.assignedToClassId != null 
                ? 'Classe' 
                : challenge.assignedToStudentIds != null 
                  ? 'Étudiants' 
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboard(Challenge challenge) {
    if (challenge.leaderboard == null || challenge.leaderboard!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.leaderboard, size: 16, color: AppColors.primary),
              SizedBox(width: 6),
              Text(
                'Leaderboard',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...challenge.leaderboard!.take(3).map((score) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Text(
                  '#${score.position}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: score.position == 1 
                      ? AppColors.secondary 
                      : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(score.user.profileImage),
                ),
                const SizedBox(width: 8),
                Text(
                  score.user.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  '${score.score} pts',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: score.position == 1 
                      ? AppColors.secondary 
                      : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          )),
          if ((challenge.leaderboard?.length ?? 0) > 3)
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => ChallengeDetailScreen(challenge: challenge, isTeacher: widget.isTeacher),
                  //   ),
                  // );
                },
                child: const Text(
                  'Voir tout le classement',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCardHeader({
    required String title,
    required IconData iconData,
    required bool isPublic,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 20,
            color: iconData == Icons.quiz ? AppColors.primary : AppColors.secondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isPublic ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPublic ? Icons.public : Icons.lock_outline,
                  size: 14,
                  color: isPublic ? AppColors.success : AppColors.warning,
                ),
                const SizedBox(width: 4),
                Text(
                  isPublic ? 'Public' : 'Privé',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isPublic ? AppColors.success : AppColors.warning,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFooter({
    required User creator,
    required DateTime createdAt,
    String? assignedType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage(creator.profileImage),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  creator.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Créé ${timeago.format(createdAt, locale: 'fr')}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (assignedType != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                assignedType,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}


// Modèles de données pour les quiz et les challenges

class User {
  final String id;
  final String name;
  final String profileImage;
  final bool isTeacher;
  final String? className;
  final String? subject;

  User({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.isTeacher,
    this.className,
    this.subject,
  });
}

class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final int points;
  final String? explanation;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    required this.points,
    this.explanation,
  });
}

class Quiz {
  final String id;
  final String title;
  final String description;
  final User creator;
  final DateTime createdAt;
  final DateTime? endDate;
  final bool isPublic;
  final List<String>? assignedToStudentIds;
  final String? assignedToClassId;
  final List<QuizQuestion> questions;
  final int totalPoints;
  final String? subject;
  final int timeLimit; // en minutes

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.creator,
    required this.createdAt,
    this.endDate,
    required this.isPublic,
    this.assignedToStudentIds,
    this.assignedToClassId,
    required this.questions,
    required this.totalPoints,
    this.subject,
    required this.timeLimit,
  });
}

class Challenge {
  final String id;
  final String title;
  final String description;
  final User creator;
  final DateTime createdAt;
  final DateTime endDate;
  final bool isPublic;
  final List<String>? assignedToStudentIds;
  final String? assignedToClassId;
  final List<dynamic> tasks; // Peut contenir différents types de tâches
  final int totalPoints;
  final String? subject;
  final List<UserScore>? leaderboard;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.creator,
    required this.createdAt,
    required this.endDate,
    required this.isPublic,
    this.assignedToStudentIds,
    this.assignedToClassId,
    required this.tasks,
    required this.totalPoints,
    this.subject,
    this.leaderboard,
  });
}

class UserScore {
  final User user;
  final int score;
  final int position;
  final DateTime lastUpdated;

  UserScore({
    required this.user,
    required this.score,
    required this.position,
    required this.lastUpdated,
  });
}

class QuizAttempt {
  final String id;
  final String quizId;
  final User student;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int score;
  final List<UserAnswer> answers;

  QuizAttempt({
    required this.id,
    required this.quizId,
    required this.student,
    required this.startedAt,
    this.completedAt,
    required this.score,
    required this.answers,
  });
}

class UserAnswer {
  final String questionId;
  final int selectedOptionIndex;
  final bool isCorrect;

  UserAnswer({
    required this.questionId,
    required this.selectedOptionIndex,
    required this.isCorrect,
  });
}

// Classe pour représenter une classe d'étudiants
class ClassGroup {
  final String id;
  final String name;
  final String? academicYear;
  final String? department;
  final List<String> studentIds;

  ClassGroup({
    required this.id,
    required this.name,
    this.academicYear,
    this.department,
    required this.studentIds,
  });
}


