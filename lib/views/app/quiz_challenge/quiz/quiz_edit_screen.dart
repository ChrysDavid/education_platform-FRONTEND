import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../quiz_challenge_screen.dart';

class QuizEditScreen extends StatefulWidget {
  final Quiz quiz;
  
  const QuizEditScreen({
    super.key,
    required this.quiz,
  });

  @override
  State<QuizEditScreen> createState() => _QuizEditScreenState();
}

class _QuizEditScreenState extends State<QuizEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _timeLimitController;
  
  late bool _isPublic;
  late bool _hasEndDate;
  DateTime? _endDate;
  String? _selectedClass;
  String? _selectedSubject;
  
  final List<String> _subjects = [
    'Mathématiques',
    'Informatique',
    'Histoire',
    'Littérature',
    'Sciences',
    'Anglais',
    'Français',
  ];
  
  final List<String> _classes = [
    'L1 Info',
    'L2 Info',
    'L3 Info',
    'L1 Lettres',
    'L2 Lettres',
    'L3 Lettres',
  ];

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs avec les valeurs existantes
    _titleController = TextEditingController(text: widget.quiz.title);
    _descriptionController = TextEditingController(text: widget.quiz.description);
    _timeLimitController = TextEditingController(text: widget.quiz.timeLimit.toString());
    
    _isPublic = widget.quiz.isPublic;
    _hasEndDate = widget.quiz.endDate != null;
    _endDate = widget.quiz.endDate;
    _selectedClass = widget.quiz.assignedToClassId;
    _selectedSubject = widget.quiz.subject;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Modifier le Quiz',
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
            onPressed: _saveChanges,
            child: const Text(
              'Sauvegarder',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Informations générales'),
              _buildInfoCard(),
              const SizedBox(height: 24),
              _buildSectionTitle('Paramètres'),
              _buildSettingsCard(),
              const SizedBox(height: 24),
              _buildSectionTitle('Attribution'),
              _buildAssignmentCard(),
              const SizedBox(height: 24),
              _buildSectionTitle('Questions (${widget.quiz.questions.length})'),
              _buildQuestionsCard(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomSheet: _buildBottomButtons(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titre du quiz *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) => value?.isEmpty == true ? 'Le titre est requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              validator: (value) => value?.isEmpty == true ? 'La description est requise' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSubject,
              decoration: const InputDecoration(
                labelText: 'Matière',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book),
              ),
              items: _subjects.map((subject) => DropdownMenuItem(
                value: subject,
                child: Text(subject),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSubject = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _timeLimitController,
              decoration: const InputDecoration(
                labelText: 'Durée limite (minutes) *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timer),
                suffixText: 'min',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty == true) return 'La durée est requise';
                if (int.tryParse(value!) == null) return 'Entrez un nombre valide';
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Quiz public'),
              subtitle: Text(
                _isPublic 
                  ? 'Visible par tous les étudiants'
                  : 'Visible uniquement par les étudiants assignés',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              value: _isPublic,
              onChanged: (value) {
                setState(() {
                  _isPublic = value;
                });
              },
              activeColor: AppColors.primary,
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Date limite'),
              subtitle: Text(
                _hasEndDate 
                  ? _endDate != null
                    ? 'Le ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                    : 'Choisir une date'
                  : 'Pas de date limite',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              value: _hasEndDate,
              onChanged: (value) {
                setState(() {
                  _hasEndDate = value;
                  if (!value) _endDate = null;
                });
              },
              activeColor: AppColors.primary,
            ),
            if (_hasEndDate)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(_endDate != null 
                    ? 'Date limite: ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                    : 'Choisir la date limite'),
                  onTap: _selectEndDate,
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentCard() {
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
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedClass,
              decoration: const InputDecoration(
                labelText: 'Classe',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.group),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Aucune classe'),
                ),
                ..._classes.map((className) => DropdownMenuItem(
                  value: className,
                  child: Text(className),
                )),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedClass = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.quiz.questions.length} questions',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${widget.quiz.totalPoints} points au total',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.quiz.questions.length,
              itemBuilder: (context, index) {
                final question = widget.quiz.questions[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          question.question,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${question.points} pts',
                        style: const TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () {
                          // Modifier cette question
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                // Ajouter une nouvelle question
              },
              icon: const Icon(Icons.add),
              label: const Text('Ajouter une question'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
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
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.cancel),
                label: const Text('Annuler'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _saveChanges,
                icon: const Icon(Icons.save),
                label: const Text('Sauvegarder'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _endDate = date;
      });
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Logique de sauvegarde des modifications
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quiz modifié avec succès!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeLimitController.dispose();
    super.dispose();
  }
}