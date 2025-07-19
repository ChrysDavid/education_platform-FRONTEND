import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _bioController = TextEditingController();

  final String _userType = 'Élève';
  final String _verificationStatus = 'En attente';
  final String _profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    // Simulation du chargement des données utilisateur
    _nameController.text = "John Doe";
    _emailController.text = "john.doe@example.com";
    _phoneController.text = "+225 01 23 45 67 89";
    _locationController.text = "Abidjan, Côte d'Ivoire";
    _bioController.text =
        "Étudiant en informatique passionné par les nouvelles technologies.";
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      // decoration: BoxDecoration(
      //   color: AppColors.surface,
      //   borderRadius: BorderRadius.circular(12),
      //   boxShadow: [
      //     BoxShadow(
      //       color: AppColors.shadow,
      //       blurRadius: 8,
      //       offset: Offset(0, 2),
      //     ),
      //   ],
      // ),
      
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.surfaceVariant,
                backgroundImage: _profileImageUrl.isNotEmpty
                    ? NetworkImage(_profileImageUrl)
                    : null,
                child: _profileImageUrl.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.textSecondary,
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showImagePicker,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            _nameController.text,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            _userType,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 12),
          _buildVerificationBadge(),
        ],
      ),
    );
  }

  Widget _buildVerificationBadge() {
    Color badgeColor;
    IconData badgeIcon;
    String badgeText;

    switch (_verificationStatus) {
      case 'Vérifié':
        badgeColor = AppColors.success;
        badgeIcon = Icons.verified;
        badgeText = 'Profil vérifié';
        break;
      case 'Rejeté':
        badgeColor = AppColors.error;
        badgeIcon = Icons.cancel;
        badgeText = 'Vérification rejetée';
        break;
      default:
        badgeColor = AppColors.warning;
        badgeIcon = Icons.pending;
        badgeText = 'En attente de vérification';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, color: badgeColor, size: 16),
          SizedBox(width: 4),
          Text(
            badgeText,
            style: TextStyle(
              color: badgeColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations personnelles',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 20),
          _buildInfoDisplay(
            label: 'Nom complet',
            value: _nameController.text,
            icon: Icons.person,
          ),
          SizedBox(height: 16),
          _buildInfoDisplay(
            label: 'Adresse email',
            value: _emailController.text,
            icon: Icons.email,
          ),
          SizedBox(height: 16),
          _buildInfoDisplay(
            label: 'Numéro de téléphone',
            value: _phoneController.text,
            icon: Icons.phone,
          ),
          SizedBox(height: 16),
          _buildInfoDisplay(
            label: 'Localisation',
            value: _locationController.text,
            icon: Icons.location_on,
          ),
          SizedBox(height: 16),
          _buildInfoDisplay(
            label: 'À propos de moi',
            value: _bioController.text,
            icon: Icons.description,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoDisplay({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.surfaceVariant),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  value.isEmpty ? 'Non renseigné' : value,
                  style: TextStyle(
                    color: value.isEmpty
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildInfoField({
  //   required TextEditingController controller,
  //   required String label,
  //   required IconData icon,
  //   String? Function(String?)? validator,
  //   TextInputType? keyboardType,
  //   int maxLines = 1,
  // }) {
  //   return TextFormField(
  //     controller: controller,
  //     validator: validator,
  //     keyboardType: keyboardType,
  //     maxLines: maxLines,
  //     decoration: InputDecoration(
  //       labelText: label,
  //       prefixIcon: Icon(icon, color: AppColors.primary),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(8),
  //         borderSide: BorderSide(color: AppColors.surfaceVariant),
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(8),
  //         borderSide: BorderSide(color: AppColors.surfaceVariant),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(8),
  //         borderSide: BorderSide(color: AppColors.primary),
  //       ),
  //       filled: true,
  //       fillColor: AppColors.background,
  //       labelStyle: TextStyle(color: AppColors.textSecondary),
  //     ),
  //   );
  // }


  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Sauvegarder les modifications',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          // if (_verificationStatus == 'En attente' ||
          //     _verificationStatus == 'Rejeté')
          //   SizedBox(
          //     width: double.infinity,
          //     height: 50,
          //     child: OutlinedButton(
          //       onPressed: _navigateToVerification,
          //       style: OutlinedButton.styleFrom(
          //         foregroundColor: AppColors.secondary,
          //         side: BorderSide(color: AppColors.secondary),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(12),
          //         ),
          //       ),
          //       child: Text(
          //         _verificationStatus == 'Rejeté'
          //             ? 'Refaire la vérification'
          //             : 'Compléter la vérification',
          //         style: TextStyle(
          //           fontSize: 16,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  // Widget _buildQuickActions() {
  //   return Container(
  //     padding: EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //       color: AppColors.surface,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: AppColors.shadow,
  //           blurRadius: 8,
  //           offset: Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Actions rapides',
  //           style: TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //             color: AppColors.textPrimary,
  //           ),
  //         ),
  //         SizedBox(height: 16),
  //         _buildQuickActionTile(
  //           icon: Icons.settings,
  //           title: 'Paramètres du compte',
  //           onTap: () => Navigator.pushNamed(context, '/settings'),
  //         ),
  //         _buildQuickActionTile(
  //           icon: Icons.help_outline,
  //           title: 'Aide et support',
  //           onTap: () => Navigator.pushNamed(context, '/help'),
  //         ),
  //         _buildQuickActionTile(
  //           icon: Icons.privacy_tip,
  //           title: 'Confidentialité',
  //           onTap: () => Navigator.pushNamed(context, '/privacy'),
  //         ),
  //         _buildQuickActionTile(
  //           icon: Icons.logout,
  //           title: 'Se déconnecter',
  //           textColor: AppColors.error,
  //           onTap: _showLogoutDialog,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildQuickActionTile({
  //   required IconData icon,
  //   required String title,
  //   required VoidCallback onTap,
  //   Color? textColor,
  // }) {
  //   return ListTile(
  //     contentPadding: EdgeInsets.zero,
  //     leading: Icon(icon, color: textColor ?? AppColors.primary),
  //     title: Text(
  //       title,
  //       style: TextStyle(
  //         color: textColor ?? AppColors.textPrimary,
  //         fontWeight: FontWeight.w500,
  //       ),
  //     ),
  //     trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
  //     onTap: onTap,
  //   );
  // }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Changer la photo de profil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.camera_alt,
                          size: 40, color: AppColors.primary),
                      onPressed: () {
                        Navigator.pop(context);
                        // Implémentation de la prise de photo
                      },
                    ),
                    Text('Appareil photo'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.photo_library,
                          size: 40, color: AppColors.primary),
                      onPressed: () {
                        Navigator.pop(context);
                        // Implémentation de la galerie
                      },
                    ),
                    Text('Galerie'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      // Implémentation de la sauvegarde
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil sauvegardé avec succès'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  // void _navigateToVerification() {
  //   Navigator.pushNamed(context, '/verification');
  // }

  // void _showLogoutDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Déconnexion'),
  //       content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text('Annuler'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             // Implémentation de la déconnexion
  //           },
  //           style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
  //           child: Text('Déconnecter', style: TextStyle(color: AppColors.white)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildProfileHeader(),
              SizedBox(height: 16),
              _buildInfoSection(),
              SizedBox(height: 16),
              // _buildQuickActions(),
              // SizedBox(height: 16),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
