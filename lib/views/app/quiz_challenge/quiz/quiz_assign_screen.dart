import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../quiz_challenge_screen.dart';

class QuizAssignScreen extends StatefulWidget {
  final Quiz quiz;
  
  const QuizAssignScreen({
    super.key,
    required this.quiz,
  });

  @override
  State<QuizAssignScreen> createState() => _QuizAssignScreenState();
}

class _QuizAssignScreenState extends State<QuizAssignScreen> {
  late bool _isPublic;
  String? _selectedClass;
  final List<String> _selectedStudents = [];
  
  final List<String> _classes = [
    'L1 Info',
    'L2 Info',
    'L3 Info',
    'L1 Lettres',
    'L2 Lettres',
    'L3 Lettres',
  ];
  
  final List<User> _students = [
    User(
      id: '201',
      name: 'Kouadio M.',
      profileImage: 'https://randomuser.me/api/portraits/men/33.jpg',
      isTeacher: false,
      className: 'L2 Info',
    ),
    User(
      id: '202',
      name: 'Assemian K.',
      profileImage: 'https://randomuser.me/api/portraits/women/28.jpg',
      isTeacher: false,
      className: 'L2 Info',
    ),
    User(
      id: '203',
      name: 'Bamba S.',
      profileImage: 'https://randomuser.me/api/portraits/men/45.jpg',
      isTeacher: false,
      className: 'L3 Info',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _isPublic = widget.quiz.isPublic;
    _selectedClass = widget.quiz.assignedToClassId;
    _selectedStudents.addAll(widget.quiz.assignedToStudentIds ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Assigner le Quiz',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveAssignment,
            child: const Text(
              'Enregistrer',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVisibilitySection(),
            const SizedBox(height: 24),
            _buildClassAssignmentSection(),
            const SizedBox(height: 24),
            _buildStudentAssignmentSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildVisibilitySection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Visibilité du Quiz',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Rendre ce quiz public'),
              subtitle: const Text(
                'Les quiz publics sont visibles par tous les étudiants',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              value: _isPublic,
              onChanged: (value) {
                setState(() {
                  _isPublic = value;
                  if (value) {
                    _selectedClass = null;
                    _selectedStudents.clear();
                  }
                });
              },
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassAssignmentSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assigner à une classe',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Si vous assignez à une classe, le quiz sera visible par tous les étudiants de cette classe',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedClass,
              decoration: const InputDecoration(
                labelText: 'Sélectionner une classe',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.group),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Aucune classe sélectionnée'),
                ),
                ..._classes.map((className) => DropdownMenuItem(
                  value: className,
                  child: Text(className),
                )),
              ],
              onChanged: _isPublic ? null : (value) {
                setState(() {
                  _selectedClass = value;
                  if (value != null) {
                    _selectedStudents.clear();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentAssignmentSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assigner à des étudiants spécifiques',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sélectionnez des étudiants individuels pour ce quiz',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            if (!_isPublic && _selectedClass == null)
              ..._students.map((student) => CheckboxListTile(
                title: Text(student.name),
                subtitle: Text(student.className ?? 'Étudiant'),
                secondary: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(student.profileImage),
                ),
                value: _selectedStudents.contains(student.id),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedStudents.add(student.id);
                    } else {
                      _selectedStudents.remove(student.id);
                    }
                  });
                },
                activeColor: AppColors.primary,
              )),
            if (_isPublic || _selectedClass != null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Désactivé car le quiz est public ou assigné à une classe',
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

  void _saveAssignment() {
    final updatedQuiz = Quiz(
      id: widget.quiz.id,
      title: widget.quiz.title,
      description: widget.quiz.description,
      creator: widget.quiz.creator,
      createdAt: widget.quiz.createdAt,
      endDate: widget.quiz.endDate,
      isPublic: _isPublic,
      assignedToStudentIds: _selectedStudents.isEmpty ? null : _selectedStudents,
      assignedToClassId: _selectedClass,
      questions: widget.quiz.questions,
      totalPoints: widget.quiz.totalPoints,
      subject: widget.quiz.subject,
      timeLimit: widget.quiz.timeLimit,
    );

    Navigator.pop(context, updatedQuiz);
  }
}