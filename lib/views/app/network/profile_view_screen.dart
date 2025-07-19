import 'package:flutter/material.dart';
import 'package:education_platform_frontend_flutter/core/models/user_model.dart';
import 'package:education_platform_frontend_flutter/core/services/user_service.dart';

class ProfileViewScreen extends StatefulWidget {
  final int userId;

  const ProfileViewScreen({super.key, required this.userId});

  @override
  _ProfileViewScreenState createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  late Future<UserModel> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = UserService.getUserDetails(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: FutureBuilder<UserModel>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Utilisateur non trouvé'));
          }

          final user = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section en-tête
                _buildProfileHeader(user),
                const SizedBox(height: 16),
                
                // Section À propos
                _buildAboutSection(user),
                const SizedBox(height: 16),
                
                // Section Informations
                _buildInfoSection(user),
                const SizedBox(height: 16),
                
                // Boutons d'action
                _buildActionButtons(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue[100],
            child: Text(
              '${user.firstName[0]}${user.lastName[0]}',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${user.firstName} ${user.lastName}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            user.type == 'teacher' 
                ? 'Enseignant' 
                : user.type == 'advisor'
                  ? 'Conseiller'
                  : user.type == 'student'
                    ? 'Étudiant'
                    : 'Élève',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(UserModel user) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'À propos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            user.verificationStatus == 'verified' 
                ? 'Profil vérifié ✅'
                : 'Profil non vérifié',
            style: TextStyle(
              color: user.verificationStatus == 'verified' 
                  ? Colors.green 
                  : Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user.address ?? 'Aucune information supplémentaire',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(UserModel user) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informations',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.email, user.email),
          if (user.phoneNumber != null) 
            _buildInfoRow(Icons.phone, user.phoneNumber!),
          if (user.city != null) 
            _buildInfoRow(Icons.location_on, user.city!),
          _buildInfoRow(Icons.calendar_today, 
              'Inscrit depuis ${user.dateJoined.year}'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: Colors.blue),
              ),
              child: const Text('Envoyer un message'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Connecter'),
            ),
          ),
        ],
      ),
    );
  }
}