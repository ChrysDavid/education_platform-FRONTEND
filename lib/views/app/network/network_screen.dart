import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/user_service.dart';
import '../../../core/services/auth_provider.dart';
import '../../../core/constants/app_colors.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  UserModel? _currentUser;

  // Initialisez directement au lieu d'utiliser 'late'
  Future<List<dynamic>> _eventsFuture = Future.value([]);
  Future<List<dynamic>> _groupsFuture = Future.value([]);
  Map<String, Future<List<UserModel>>> _usersByTypeFutures = {};

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _loadData();
    _animationController.forward();
  }

  void _loadData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    _eventsFuture = _simulateEvents();
    _groupsFuture = _simulateGroups();
    _currentUser = authProvider.user;

    if (_currentUser != null) {
      if (_currentUser!.type == 'student' || _currentUser!.type == 'pupil') {
        _usersByTypeFutures = {
          'teacher': UserService.getUsersByType(
            'teacher', 
            authProvider: authProvider,
          ),
          'advisor': UserService.getUsersByType(
            'advisor',
            authProvider: authProvider,
          ),
        };
      } else {
        _usersByTypeFutures = {
          'student': UserService.getUsersByType(
            'student',
            authProvider: authProvider,
          ),
          'pupil': UserService.getUsersByType(
            'pupil', 
            authProvider: authProvider,
          ),
        };
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> _simulateEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {
        'title': 'Conférence IA & Éducation',
        'date': '15 Mars 2024',
        'participants': 45,
        'type': 'conference',
      },
      {
        'title': 'Workshop Flutter',
        'date': '20 Mars 2024',
        'participants': 28,
        'type': 'workshop',
      },
      {
        'title': 'Séminaire Pédagogie',
        'date': '25 Mars 2024',
        'participants': 62,
        'type': 'seminar',
      },
    ];
  }

  Future<List<dynamic>> _simulateGroups() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return [
      {
        'name': 'Développeurs Mobile',
        'members': 124,
        'category': 'tech',
        'isJoined': false,
      },
      {
        'name': 'Pédagogie Innovante',
        'members': 89,
        'category': 'education',
        'isJoined': true,
      },
      {
        'name': 'Étudiants CI',
        'members': 256,
        'category': 'community',
        'isJoined': false,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (!authProvider.isAuthenticated || authProvider.user == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Connectez-vous pour accéder à votre réseau",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Se connecter",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final currentUser = authProvider.user!;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        _buildStatsCard(currentUser),
                        const SizedBox(height: 24),
                        ..._buildUserSections(currentUser).map(
                          (widget) => Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: widget,
                          ),
                        ),
                        _buildEventsSection(),
                        const SizedBox(height: 24),
                        _buildGroupsSection(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGroupsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // En-tête de la section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.warning.withOpacity(0.1),
                  AppColors.warning.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Icône
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.group_work,
                    color: AppColors.warning,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Titre et sous-titre
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Groupes recommandés",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rejoignez des communautés actives",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bouton "Voir tout"
                TextButton(
                  onPressed: () {
                    // Navigation vers la page complète des groupes
                    Navigator.pushNamed(context, '/groups');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.warning,
                    backgroundColor: AppColors.warning.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Voir tout"),
                ),
              ],
            ),
          ),

          // Contenu de la liste des groupes
          Padding(padding: const EdgeInsets.all(16), child: _buildGroupsList()),
        ],
      ),
    );
  }

  //   Widget _buildUnauthenticatedView(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: AppColors.background,
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(
  //             Icons.person_off,
  //             size: 80,
  //             color: AppColors.textSecondary,
  //           ),
  //           const SizedBox(height: 24),
  //           Text(
  //             "Connectez-vous pour accéder à votre réseau",
  //             style: TextStyle(
  //               fontSize: 18,
  //               color: AppColors.textSecondary,
  //               fontWeight: FontWeight.w500,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //           const SizedBox(height: 32),
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.pushNamed(context, '/login');
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: AppColors.primary,
  //               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //             ),
  //             child: const Text(
  //               "Se connecter",
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 16),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pushNamed(context, '/register');
  //             },
  //             child: Text(
  //               "Créer un compte",
  //               style: TextStyle(
  //                 fontSize: 14,
  //                 color: AppColors.primary,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildEventsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.success.withOpacity(0.1),
                  AppColors.success.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.event, color: AppColors.success, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Événements à venir",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Participez aux prochains événements",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Naviguer vers la page des événements
                    Navigator.pushNamed(context, '/events');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.success,
                    backgroundColor: AppColors.success.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Voir tout"),
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(16), child: _buildEventsList()),
        ],
      ),
    );
  }

  List<Widget> _buildUserSections(UserModel currentUser) {
    if (currentUser.type == 'student' || currentUser.type == 'pupil') {
      return [
        _buildSection(
          title: "Enseignants",
          subtitle: "Connectez-vous avec vos formateurs",
          icon: Icons.school,
          color: AppColors.primary,
          future: _usersByTypeFutures['teacher'],
          type: 'teacher',
        ),
        const SizedBox(height: 24),
        _buildSection(
          title: "Conseillers",
          subtitle: "Obtenez des conseils personnalisés",
          icon: Icons.support_agent,
          color: AppColors.secondary,
          future: _usersByTypeFutures['advisor'],
          type: 'advisor',
        ),
      ];
    } else {
      return [
        _buildSection(
          title: "Étudiants",
          subtitle: "Accompagnez vos apprenants",
          icon: Icons.groups,
          color: AppColors.primary,
          future: _usersByTypeFutures['student'],
          type: 'student',
        ),
        const SizedBox(height: 24),
        _buildSection(
          title: "Élèves",
          subtitle: "Guidez les plus jeunes",
          icon: Icons.child_friendly,
          color: AppColors.secondary,
          future: _usersByTypeFutures['pupil'],
          type: 'pupil',
        ),
      ];
    }
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Future<List<UserModel>>? future,
    required String type,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // En-tête de la section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: color,
                    backgroundColor: color.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Voir tout"),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildUserList(future, type),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(Future<List<UserModel>>? usersFuture, String type) {
    return FutureBuilder<List<UserModel>>(
      future: usersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        } else if (snapshot.hasError) {
          print('Erreur: ${snapshot.error}');
          return _buildErrorState(snapshot.error.toString());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState(
            icon: Icons.person_outline,
            message: "Aucun ${_getUserTypeText(type)} pour le moment",
          );
        }

        return SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];
              return _buildUserCard(user, index);
            },
          ),
        );
      },
    );
  }

  // Widget _buildAppBar(UserModel currentUser) {
  //   return SliverAppBar(
  //     expandedHeight: 120,
  //     floating: false,
  //     pinned: true,
  //     backgroundColor: AppColors.primary,
  //     elevation: 0,
  //     flexibleSpace: FlexibleSpaceBar(
  //       background: Container(
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             begin: Alignment.topLeft,
  //             end: Alignment.bottomRight,
  //             colors: [
  //               AppColors.primary,
  //               AppColors.primary.withOpacity(0.8),
  //             ],
  //           ),
  //         ),
  //         child: SafeArea(
  //           child: Padding(
  //             padding: const EdgeInsets.all(16),
  //             child:
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Text(
  //                   "Bonjour ${currentUser.firstName} !",
  //                   style: const TextStyle(
  //                     fontSize: 24,
  //                     fontWeight: FontWeight.bold,
  //                     color: AppColors.white,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 Text(
  //                   "Découvrez votre réseau éducatif",
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     color: AppColors.white.withOpacity(0.9),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildStatsCard(UserModel currentUser) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatItem(
            icon: Icons.people,
            label: "Connexions",
            value: "127",
            color: AppColors.primary,
          ),
          const SizedBox(width: 24),
          _buildStatItem(
            icon: Icons.event_available,
            label: "Événements",
            value: "8",
            color: AppColors.success,
          ),
          const SizedBox(width: 24),
          _buildStatItem(
            icon: Icons.groups,
            label: "Groupes",
            value: "5",
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildSection({
  //   required String title,
  //   required String subtitle,
  //   required IconData icon,
  //   required Color color,
  //   required Widget child,
  // }) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16),
  //     decoration: BoxDecoration(
  //       color: AppColors.surface,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: AppColors.shadow,
  //           blurRadius: 8,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(20),
  //           decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //               colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //             ),
  //             borderRadius: const BorderRadius.vertical(
  //               top: Radius.circular(16),
  //             ),
  //           ),
  //           child: Row(
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.all(12),
  //                 decoration: BoxDecoration(
  //                   color: color.withOpacity(0.2),
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 child: Icon(
  //                   icon,
  //                   color: color,
  //                   size: 24,
  //                 ),
  //               ),
  //               const SizedBox(width: 16),
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       title,
  //                       style: const TextStyle(
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.bold,
  //                         color: AppColors.textPrimary,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 4),
  //                     Text(
  //                       subtitle,
  //                       style: const TextStyle(
  //                         fontSize: 14,
  //                         color: AppColors.textSecondary,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               TextButton(
  //                 onPressed: () {},
  //                 style: TextButton.styleFrom(
  //                   foregroundColor: color,
  //                   backgroundColor: color.withOpacity(0.1),
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 16,
  //                     vertical: 8,
  //                   ),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(20),
  //                   ),
  //                 ),
  //                 child: const Text("Voir tout"),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: child,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildUserList(Future<List<UserModel>>? usersFuture) {
  //   if (usersFuture == null) {
  //     return _buildEmptyState(
  //       icon: Icons.person_outline,
  //       message: "Aucun utilisateur pour le moment",
  //     );
  //   }

  //   return FutureBuilder<List<UserModel>>(
  //     future: usersFuture,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return _buildLoadingState();
  //       } else if (snapshot.hasError) {
  //         return _buildErrorState(snapshot.error.toString());
  //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //         return _buildEmptyState(
  //           icon: Icons.person_outline,
  //           message: "Aucun utilisateur pour le moment",
  //         );
  //       }

  //       return SizedBox(
  //         height: 180,
  //         child: ListView.builder(
  //           scrollDirection: Axis.horizontal,
  //           padding: const EdgeInsets.symmetric(horizontal: 4),
  //           itemCount: snapshot.data!.length,
  //           itemBuilder: (context, index) {
  //             final user = snapshot.data![index];
  //             return _buildUserCard(user, index);
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildUserCard(UserModel user, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 100)),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ProfileViewScreen(user: user),
              //   ),
              // );
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceVariant, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.3),
                          AppColors.secondary.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text(
                        '${user.firstName[0]}${user.lastName[0]}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${user.firstName} ${user.lastName}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getUserTypeColor(user.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getUserTypeText(user.type),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _getUserTypeColor(user.type),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getUserTypeColor(String type) {
    switch (type) {
      case 'teacher':
        return AppColors.primary;
      case 'advisor':
        return AppColors.secondary;
      case 'student':
        return AppColors.success;
      case 'pupil':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getUserTypeText(String type) {
    switch (type) {
      case 'teacher':
        return 'Enseignant';
      case 'advisor':
        return 'Conseiller';
      case 'student':
        return 'Étudiant';
      case 'pupil':
        return 'Élève';
      default:
        return 'Utilisateur';
    }
  }

  Widget _buildEventsList() {
    return FutureBuilder<List<dynamic>>(
      future: _eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState(
            icon: Icons.event_busy,
            message: "Aucun événement pour le moment",
          );
        }

        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return _buildEventCard(snapshot.data![index], index);
            },
          ),
        );
      },
    );
  }

  Widget _buildEventCard(dynamic event, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              width: 220,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.success.withOpacity(0.8),
                          AppColors.success.withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${event['participants']} participants',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const Center(
                          child: Icon(
                            Icons.event,
                            size: 48,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['title'] ?? 'Événement',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              event['date'] ?? 'Date non spécifiée',
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGroupsList() {
    return FutureBuilder<List<dynamic>>(
      future: _groupsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState(
            icon: Icons.group_off,
            message: "Aucun groupe pour le moment",
          );
        }

        return SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return _buildGroupCard(snapshot.data![index], index);
            },
          ),
        );
      },
    );
  }

  Widget _buildGroupCard(dynamic group, int index) {
    final isJoined = group['isJoined'] ?? false;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + (index * 100)),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              width: 160,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isJoined
                      ? AppColors.primary
                      : AppColors.surfaceVariant,
                  width: isJoined ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isJoined
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isJoined ? Icons.group : Icons.group_add,
                        size: 32,
                        color: isJoined ? AppColors.primary : AppColors.warning,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      group['name'] ?? 'Groupe',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${group['members'] ?? '0'} membres',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (isJoined) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Membre',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            'Erreur: $error',
            style: const TextStyle(fontSize: 16, color: AppColors.error),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
