import 'package:education_platform_frontend_flutter/views/app/notifications/notifications_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SearchForumScreen extends StatefulWidget {
  const SearchForumScreen({super.key});

  @override
  State<SearchForumScreen> createState() => _SearchForumScreenState();
}

class _SearchForumScreenState extends State<SearchForumScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _isSearching = false;

  // Catégories inspirées d'Instagram
  final List<String> _categories = [
    'Tous', 'Étudiants', 'Professeurs', 'Conseillers', 'Administrateurs', 'Favoris'
  ];
  String _selectedCategory = 'Tous';

  final List<Map<String, dynamic>> profiles = [
    {
      "name": "Dr. Sarah Kouassi",
      "role": "Conseillère d'orientation",
      "followers": "2.5K",
      "category": "Conseillers",
      "verified": true,
    },
    {
      "name": "Mohamed Traoré",
      "role": "Étudiant en Médecine",
      "followers": "843",
      "category": "Étudiants",
      "verified": false,
    },
    {
      "name": "Prof. Aya Diabaté",
      "role": "Professeure d'Économie",
      "followers": "1.2K",
      "category": "Professeurs",
      "verified": true,
    },
    {
      "name": "Abdou Ouattara",
      "role": "Administrateur",
      "followers": "672",
      "category": "Administrateurs",
      "verified": false,
    },
    {
      "name": "Konan Kouamé",
      "role": "Étudiant en Informatique",
      "followers": "521",
      "category": "Étudiants",
      "verified": false,
    },
    {
      "name": "Dr. Aminata Bamba",
      "role": "Conseillère académique",
      "followers": "1.8K",
      "category": "Conseillers",
      "verified": true,
    },
  ];

  List<Map<String, dynamic>> get filteredProfiles {
    List<Map<String, dynamic>> result = profiles;
    
    // Filtrer par catégorie
    if (_selectedCategory != 'Tous') {
      result = result.where((p) => p['category'] == _selectedCategory).toList();
    }
    
    // Filtrer par recherche
    if (_query.isNotEmpty) {
      result = result.where((p) =>
          p['name']!.toLowerCase().contains(_query.toLowerCase()) ||
          p['role']!.toLowerCase().contains(_query.toLowerCase())
      ).toList();
    }
    
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
        centerTitle: false,
        title: !_isSearching
            ? Text(
                "Recherche",
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: AppColors.white,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> NotificationScreen(),),);
            },
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
                          hintText: "Rechercher",
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
                              "Rechercher",
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

          // Catégories horizontales comme Instagram
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
            child: filteredProfiles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppColors.textSecondary.withOpacity(0.5),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Aucun résultat trouvé.",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredProfiles.length,
                    itemBuilder: (context, index) {
                      final profile = filteredProfiles[index];
                      return InstagramStyleProfileTile(profile: profile);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class InstagramStyleProfileTile extends StatelessWidget {
  final Map<String, dynamic> profile;

  const InstagramStyleProfileTile({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Action quand on clique sur un profil
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Avatar avec bordure comme Instagram
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
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
                          profile['name'][0],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12),
            // Informations du profil
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        profile['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      if (profile['verified'])
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.verified,
                            color: AppColors.primary,
                            size: 14,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    profile['role'],
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "${profile['followers']} abonnés",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Bouton suivre
            SizedBox(
              height: 28,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                ),
                child: Text(
                  "Suivre",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}