import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class QuizChallengeSearchScreen extends StatefulWidget {
  const QuizChallengeSearchScreen({super.key});

  @override
  State<QuizChallengeSearchScreen> createState() => _QuizChallengeSearchScreenState();
}

class _QuizChallengeSearchScreenState extends State<QuizChallengeSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _isSearching = false;
  String _sortOrder = 'récent'; // 'récent', 'populaire', 'difficile'

  // Catégories de quiz et challenges
  final List<String> _categories = [
    'Tous', 'Éducation', 'Culture', 'Sport', 'Sciences', 'Histoire', 'Géographie', 'Technologie'
  ];
  String _selectedCategory = 'Tous';

  final List<Map<String, dynamic>> quizzes = [
    {
      "title": "Histoire de la Côte d'Ivoire",
      "category": "Histoire",
      "difficulty": "Moyen",
      "duration": "10 min",
      "participants": "2.5K",
      "created": "Il y a 2 jours",
      "author": "Prof. Aya Diabaté",
      "verified": true,
      "featured": true,
    },
    {
      "title": "Technologie Mobile",
      "category": "Technologie",
      "difficulty": "Facile",
      "duration": "5 min",
      "participants": "843",
      "created": "Il y a 5 heures",
      "author": "Konan Kouamé",
      "verified": false,
      "featured": false,
    },
    {
      "title": "Anatomie Médicale",
      "category": "Sciences",
      "difficulty": "Difficile",
      "duration": "15 min",
      "participants": "1.2K",
      "created": "Il y a 1 semaine",
      "author": "Dr. Sarah Kouassi",
      "verified": true,
      "featured": true,
    },
    {
      "title": "Géographie Africaine",
      "category": "Géographie",
      "difficulty": "Moyen",
      "duration": "12 min",
      "participants": "672",
      "created": "Il y a 3 jours",
      "author": "Mohamed Traoré",
      "verified": false,
      "featured": false,
    },
    {
      "title": "Football Africain",
      "category": "Sport",
      "difficulty": "Facile",
      "duration": "8 min",
      "participants": "3.1K",
      "created": "Il y a 2 semaines",
      "author": "Didier Drogba",
      "verified": true,
      "featured": true,
    },
    {
      "title": "Culture Ivoirienne",
      "category": "Culture",
      "difficulty": "Moyen",
      "duration": "15 min",
      "participants": "1.8K",
      "created": "Aujourd'hui",
      "author": "Dr. Aminata Bamba",
      "verified": true,
      "featured": false,
    },
  ];

  List<Map<String, dynamic>> get filteredQuizzes {
    List<Map<String, dynamic>> result = List.from(quizzes);
    
    // Filtrer par catégorie
    if (_selectedCategory != 'Tous') {
      result = result.where((q) => q['category'] == _selectedCategory).toList();
    }
    
    // Filtrer par recherche
    if (_query.isNotEmpty) {
      result = result.where((q) =>
          q['title']!.toLowerCase().contains(_query.toLowerCase()) ||
          q['category']!.toLowerCase().contains(_query.toLowerCase()) ||
          q['author']!.toLowerCase().contains(_query.toLowerCase())
      ).toList();
    }
    
    // Tri selon l'ordre sélectionné
    switch (_sortOrder) {
      case 'récent':
        // Tri déjà en ordre chronologique inverse dans cet exemple
        break;
      case 'populaire':
        result.sort((a, b) {
          int aParticipants = int.parse(a['participants'].replaceAll('K', '000').replaceAll('.', ''));
          int bParticipants = int.parse(b['participants'].replaceAll('K', '000').replaceAll('.', ''));
          return bParticipants.compareTo(aParticipants);
        });
        break;
      case 'difficile':
        final difficultyMap = {
          'Facile': 1,
          'Moyen': 2,
          'Difficile': 3,
        };
        result.sort((a, b) {
          int aDiff = difficultyMap[a['difficulty']] ?? 0;
          int bDiff = difficultyMap[b['difficulty']] ?? 0;
          return bDiff.compareTo(aDiff);
        });
        break;
    }
    
    return result;
  }

  void _showSortMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  "Trier par",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.schedule,
                  color: _sortOrder == 'récent' ? AppColors.primary : null,
                ),
                title: Text("Plus récent"),
                trailing: _sortOrder == 'récent' ? Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  setState(() {
                    _sortOrder = 'récent';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.trending_up,
                  color: _sortOrder == 'populaire' ? AppColors.primary : null,
                ),
                title: Text("Plus populaire"),
                trailing: _sortOrder == 'populaire' ? Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  setState(() {
                    _sortOrder = 'populaire';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.fitness_center,
                  color: _sortOrder == 'difficile' ? AppColors.primary : null,
                ),
                title: Text("Plus difficile"),
                trailing: _sortOrder == 'difficile' ? Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  setState(() {
                    _sortOrder = 'difficile';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        centerTitle: false,
        title: !_isSearching
            ? Text(
                "Quiz & Challenges",
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
        actions: [
          // Icône de tri par temps
          IconButton(
            icon: Icon(
              Icons.sort,
              color: AppColors.white,
            ),
            onPressed: _showSortMenu,
            tooltip: "Trier par",
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche style Instagram
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _isSearching = true;
                });
              },
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _isSearching
                    ? TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          hintText: "Rechercher des quiz & challenges",
                          hintStyle: TextStyle(color: AppColors.textSecondary),
                          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.close, color: AppColors.textSecondary, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _query = '';
                                _isSearching = false;
                              });
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 8),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _query = value;
                          });
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "Rechercher des quiz & challenges",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),

          // Catégories horizontales style Instagram
          if (!_isSearching)
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final bool isSelected = category == _selectedCategory;
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      backgroundColor: AppColors.surfaceVariant,
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          width: 1,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Liste des résultats
          Expanded(
            child: filteredQuizzes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.quiz_outlined,
                          size: 64,
                          color: AppColors.textSecondary.withOpacity(0.5),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Aucun quiz ou challenge trouvé.",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredQuizzes.length,
                    itemBuilder: (context, index) {
                      final quiz = filteredQuizzes[index];
                      return InstagramStyleQuizTile(quiz: quiz);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class InstagramStyleQuizTile extends StatelessWidget {
  final Map<String, dynamic> quiz;

  const InstagramStyleQuizTile({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    Color difficultyColor;
    switch (quiz['difficulty']) {
      case 'Facile':
        difficultyColor = AppColors.success;
        break;
      case 'Moyen':
        difficultyColor = AppColors.warning;
        break;
      case 'Difficile':
        difficultyColor = AppColors.error;
        break;
      default:
        difficultyColor = AppColors.textSecondary;
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.surfaceVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec l'auteur
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Avatar de l'auteur
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        AppColors.primary,
                        AppColors.secondary,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        backgroundColor: AppColors.secondary.withOpacity(0.7),
                        child: Text(
                          quiz['author'][0],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                // Nom de l'auteur
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            quiz['author'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          if (quiz['verified'])
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.verified,
                                color: AppColors.primary,
                                size: 12,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        quiz['created'],
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                // Bouton menu
                IconButton(
                  icon: Icon(Icons.more_vert, size: 16),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ),
          
          // Content du quiz
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: quiz['featured'] 
                    ? [AppColors.primary, AppColors.secondary]
                    : [AppColors.surfaceVariant, AppColors.surfaceVariant.withOpacity(0.7)],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    quiz['category'] == 'Sport' ? Icons.sports : 
                    quiz['category'] == 'Sciences' ? Icons.science :
                    quiz['category'] == 'Histoire' ? Icons.history : 
                    quiz['category'] == 'Géographie' ? Icons.public :
                    quiz['category'] == 'Technologie' ? Icons.devices :
                    quiz['category'] == 'Culture' ? Icons.diversity_3 :
                    Icons.quiz,
                    color: quiz['featured'] ? Colors.white : AppColors.primary,
                    size: 28,
                  ),
                  SizedBox(height: 8),
                  Text(
                    quiz['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: quiz['featured'] ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: quiz['featured'] ? Colors.white.withOpacity(0.3) : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      quiz['category'],
                      style: TextStyle(
                        fontSize: 12,
                        color: quiz['featured'] ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Pied de page avec info et actions
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Statistiques
                Row(
                  children: [
                    Icon(Icons.timer, size: 14, color: AppColors.textSecondary),
                    SizedBox(width: 4),
                    Text(
                      quiz['duration'],
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 12),
                    
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: difficultyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.signal_cellular_alt, 
                            size: 12, 
                            color: difficultyColor,
                          ),
                          SizedBox(width: 2),
                          Text(
                            quiz['difficulty'],
                            style: TextStyle(
                              color: difficultyColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Spacer(),
                    
                    Icon(Icons.person, size: 14, color: AppColors.textSecondary),
                    SizedBox(width: 2),
                    Text(
                      quiz['participants'],
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("Jouer maintenant"),
                      ),
                    ),
                    SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        side: BorderSide(color: AppColors.surfaceVariant, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Icon(
                        Icons.share_outlined,
                        size: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        side: BorderSide(color: AppColors.surfaceVariant, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Icon(
                        Icons.bookmark_border_outlined,
                        size: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}