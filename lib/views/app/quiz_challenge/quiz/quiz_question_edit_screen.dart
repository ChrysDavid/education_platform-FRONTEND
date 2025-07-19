import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../quiz_challenge_screen.dart';

class QuizQuestionEditScreen extends StatefulWidget {
  final QuizQuestion? question;
  final bool isEditing;
  
  const QuizQuestionEditScreen({
    super.key,
    this.question,
    required this.isEditing,
  });

  @override
  State<QuizQuestionEditScreen> createState() => _QuizQuestionEditScreenState();
}

class _QuizQuestionEditScreenState extends State<QuizQuestionEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionController;
  late List<TextEditingController> _optionControllers;
  late int _correctOptionIndex;
  late TextEditingController _pointsController;
  late TextEditingController _explanationController;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question?.question ?? '');
    _optionControllers = List.generate(
      4,
      (index) => TextEditingController(
        text: widget.question?.options[index] ?? '',
      ),
    );
    _correctOptionIndex = widget.question?.correctOptionIndex ?? 0;
    _pointsController = TextEditingController(
      text: widget.question?.points.toString() ?? '10',
    );
    _explanationController = TextEditingController(
      text: widget.question?.explanation ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          widget.isEditing ? 'Modifier la question' : 'Nouvelle question',
          style: const TextStyle(
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
            onPressed: _saveQuestion,
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuestionField(),
              const SizedBox(height: 24),
              _buildOptionsSection(),
              const SizedBox(height: 24),
              _buildPointsField(),
              const SizedBox(height: 24),
              _buildExplanationField(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionField() {
    return TextFormField(
      controller: _questionController,
      decoration: const InputDecoration(
        labelText: 'Question *',
        border: OutlineInputBorder(),
        hintText: 'Entrez la question ici',
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer une question';
        }
        return null;
      },
    );
  }

  Widget _buildOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Options de réponse *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Cochez la réponse correcte et remplissez toutes les options',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(4, (index) => _buildOptionField(index)),
      ],
    );
  }

  Widget _buildOptionField(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Radio<int>(
            value: index,
            groupValue: _correctOptionIndex,
            onChanged: (value) {
              setState(() {
                _correctOptionIndex = value!;
              });
            },
            activeColor: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: _optionControllers[index],
              decoration: InputDecoration(
                labelText: 'Option ${String.fromCharCode(65 + index)}',
                border: const OutlineInputBorder(),
                hintText: 'Entrez le texte de l\'option',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer cette option';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsField() {
    return TextFormField(
      controller: _pointsController,
      decoration: const InputDecoration(
        labelText: 'Points *',
        border: OutlineInputBorder(),
        suffixText: 'points',
        hintText: 'Points pour cette question',
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer le nombre de points';
        }
        if (int.tryParse(value) == null) {
          return 'Veuillez entrer un nombre valide';
        }
        return null;
      },
    );
  }

  Widget _buildExplanationField() {
    return TextFormField(
      controller: _explanationController,
      decoration: const InputDecoration(
        labelText: 'Explication (optionnelle)',
        border: OutlineInputBorder(),
        hintText: 'Explication de la réponse correcte',
      ),
      maxLines: 3,
    );
  }

  void _saveQuestion() {
    if (_formKey.currentState!.validate()) {
      final newQuestion = QuizQuestion(
        id: widget.question?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        question: _questionController.text,
        options: _optionControllers.map((c) => c.text).toList(),
        correctOptionIndex: _correctOptionIndex,
        points: int.parse(_pointsController.text),
        explanation: _explanationController.text.isEmpty ? null : _explanationController.text,
      );

      Navigator.pop(context, newQuestion);
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    _pointsController.dispose();
    _explanationController.dispose();
    super.dispose();
  }
}