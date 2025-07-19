import 'package:flutter/material.dart';
import '../../../widgets/role_card.dart';
import 'choose_role_controller.dart';
import '../../../widgets/header_widget.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';

class ChooseRoleScreen extends StatefulWidget {
  const ChooseRoleScreen({super.key});

  @override
  State<ChooseRoleScreen> createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends State<ChooseRoleScreen>
    with SingleTickerProviderStateMixin {
  late ChooseRoleController _controller;
  late AnimationController _animationController;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = ChooseRoleController(context);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pageController = PageController(viewportFraction: 0.85);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Variables pour la responsivité
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight - 200; // Hauteur disponible après l'en-tête
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Fond blanc
          Container(color: Colors.white),
      
          // En-tête animé
          HeaderWidget(
            animationController: _animationController,
            title: "ORIENTATION CI",
          ),
      
          // Contenu principal
          Positioned(
            top: 200,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Liste des rôles avec hauteur flexible
                Expanded(
                  flex: 3,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: availableHeight > 400 ? 400 : availableHeight,
                      minHeight: 300,
                    ),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: ChooseRoleController.roles.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            double value = 1.0;
                            if (_pageController.position.haveDimensions) {
                              value = _pageController.page! - index;
                              value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                            }
                            return Center(
                              child: SizedBox(
                                height: Curves.easeOut.transform(value) * 
                                       (availableHeight > 350 ? 350 : availableHeight - 50),
                                width: Curves.easeOut.transform(value) * 300,
                                child: RoleCardWidget(
                                  role: ChooseRoleController.roles[index],
                                  scale: Curves.easeOut.transform(value),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
      
                // Partie inférieure scrollable
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Indicateurs de page
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            ChooseRoleController.roles.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              width: _currentPage == index ? 20 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? ChooseRoleController.roles[index]["color"]
                                    : Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
      
                        // Bouton de sélection
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: CustomButton(
                            label: "Sélectionner ce rôle",
                            onPressed: () => _controller.performAction(
                              ChooseRoleController.roles[_currentPage]["action"],
                            ),
                            backgroundColor:
                                ChooseRoleController.roles[_currentPage]["color"],
                            textColor: Colors.white,
                            borderRadius: 30,
                            icon: const Icon(Icons.arrow_forward,
                                color: Colors.white),
                          ),
                        ),
      
                        // Section connexion
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                flex: 2,
                                child: Text(
                                  'Déjà inscrit ?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomButton(
                                  label: "Se connecter",
                                  onPressed: _controller.goToLogin,
                                  backgroundColor: AppColors.white,
                                  textColor: AppColors.secondary,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  borderRadius: 30,
                                  borderColor: AppColors.secondary,
                                  icon: const Icon(Icons.login,
                                      color: AppColors.secondary, size: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
      
                        // Version de l'application
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            "Orientation CI - Version 1.0",
                            style: TextStyle(
                              color: AppColors.textSecondary.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}