import 'package:education_platform_frontend_flutter/core/models/user_model.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  const EditProfilePage({required this.user, super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Contrôleurs pour les champs de texte
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;
  late TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs avec les valeurs de l'utilisateur
    _nomController = TextEditingController(text: widget.user.lastName);
    _prenomController = TextEditingController(text: widget.user.firstName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phoneNumber ?? '');
    _addressController = TextEditingController(text: widget.user.address ?? '');
    _cityController = TextEditingController(text: widget.user.city ?? '');
    _postalCodeController = TextEditingController(text: widget.user.postalCode ?? '');
    _countryController = TextEditingController(text: widget.user.country ?? '');
  }

  @override
  void dispose() {
    // Libérer les ressources
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier mon profil', 
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Photo de profil
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.surfaceVariant,
                  backgroundImage: widget.user.profilePicture != null 
                    ? NetworkImage(widget.user.profilePicture!)
                    : const AssetImage('assets/default_profile.png') as ImageProvider,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      color: AppColors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      // Logique pour changer la photo
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Informations de base
            _buildSectionTitle('Informations personnelles'),
            _buildTextField('Nom', _nomController, Icons.person),
            _buildTextField('Prénom', _prenomController, Icons.person),
            _buildTextField('Email', _emailController, Icons.email, enabled: false),
            _buildTextField('Téléphone', _phoneController, Icons.phone),
            
            // Adresse
            _buildSectionTitle('Adresse'),
            _buildTextField('Adresse', _addressController, Icons.home),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField('Ville', _cityController, Icons.location_city),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField('Code postal', _postalCodeController, Icons.numbers),
                ),
              ],
            ),
            _buildTextField('Pays', _countryController, Icons.public),
            
            // Autres informations selon le type d'utilisateur
            if (widget.user.type == 'student' || widget.user.type == 'pupil')
              _buildSectionTitle('Informations scolaires'),
            
            if (widget.user.type == 'student')
              Column(
                children: [
                  _buildTextField('Établissement', TextEditingController(), Icons.school),
                  _buildTextField('Niveau', TextEditingController(), Icons.grade),
                  _buildTextField('Filière', TextEditingController(), Icons.book),
                ],
              ),
            
            if (widget.user.type == 'pupil')
              Column(
                children: [
                  _buildTextField('École', TextEditingController(), Icons.school),
                  _buildTextField('Classe', TextEditingController(), Icons.grade),
                ],
              ),
            
            // Boutons d'action
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.textSecondary),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Sauvegarder'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.secondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          filled: true,
          fillColor: enabled ? AppColors.surface : AppColors.surfaceVariant,
        ),
      ),
    );
  }

  void _saveChanges() {
    // Créer un nouvel objet UserModel avec les modifications
    final updatedUser = widget.user.copyWith(
      firstName: _prenomController.text,
      lastName: _nomController.text,
      phoneNumber: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      address: _addressController.text.isNotEmpty ? _addressController.text : null,
      city: _cityController.text.isNotEmpty ? _cityController.text : null,
      postalCode: _postalCodeController.text.isNotEmpty ? _postalCodeController.text : null,
      country: _countryController.text.isNotEmpty ? _countryController.text : null,
    );

    // Ici, vous devriez appeler votre service API pour mettre à jour l'utilisateur
    // Par exemple: AuthService.updateProfile(updatedUser);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil mis à jour avec succès'),
        backgroundColor: AppColors.success,
      ),
    );
    
    Navigator.pop(context, updatedUser);
  }
}