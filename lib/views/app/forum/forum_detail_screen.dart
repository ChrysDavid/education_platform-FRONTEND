// forum_detail_screen.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'post_comment_screen.dart';

class ForumDetailScreen extends StatelessWidget {
  final String postTitle;
  final String author;

  const ForumDetailScreen({super.key, required this.postTitle, required this.author});

  final List<String> comments = const [
    "Tu peux créer un planning et réviser chaque jour.",
    "Regarde aussi les vidéos sur YouTube, ça aide !",
    "Ne néglige pas les annales !",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Auteur : $author", style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 16),
            const Text(
              "Contenu du post ici... (Expliquer les détails du problème ou de la question posée).",
              style: TextStyle(fontSize: 16),
            ),
            const Divider(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Commentaires", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(comments[index]),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PostCommentScreen()),
                );
              },
              icon: const Icon(Icons.comment),
              label: const Text("Ajouter un commentaire"),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            )
          ],
        ),
      ),
    );
  }
}