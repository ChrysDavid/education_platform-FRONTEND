import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class QuizCreateScreen extends StatefulWidget {
  const QuizCreateScreen({super.key});

  @override
  State<QuizCreateScreen> createState() => _QuizCreateScreenState();
}

class _QuizCreateScreenState extends State<QuizCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeLimitController = TextEditingController();
  
  bool _isPublic = true;
  bool _hasEndDate = false;
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Créer un Quiz',
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
            onPressed: _saveQuiz,
            child: const Text(
              'Créer',
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
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomSheet: _buildBottomButton(),
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
                hintText: 'Ex: Mathématiques - Équations du second degré',
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
                hintText: 'Décrivez le contenu et les objectifs de ce quiz',
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
                hintText: 'Ex: 30',
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
              'Assigner à une classe (optionnel)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Si aucune classe n\'est sélectionnée, le quiz sera disponible selon sa visibilité.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
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

  Widget _buildBottomButton() {
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
        child: ElevatedButton.icon(
          onPressed: () {
            // Naviguer vers l'écran d'ajout de questions
            Navigator.pushNamed(context, '/quiz/create/questions');
          },
          icon: const Icon(Icons.add),
          label: const Text('Ajouter des questions'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
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

  void _saveQuiz() {
    if (_formKey.currentState!.validate()) {
      // Logique de sauvegarde de base du quiz
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quiz créé avec succès! Ajoutez maintenant des questions.'),
          backgroundColor: AppColors.success,
        ),
      );
      
      // Naviguer vers l'écran d'ajout de questions
      Navigator.pushReplacementNamed(context, '/quiz/create/questions');
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
