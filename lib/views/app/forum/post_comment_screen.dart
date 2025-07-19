// post_comment_screen.dart
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class PostCommentScreen extends StatefulWidget {
  const PostCommentScreen({super.key});

  @override
  State<PostCommentScreen> createState() => _PostCommentScreenState();
}

class _PostCommentScreenState extends State<PostCommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSending = false;

  void _submitComment() {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) return;

    setState(() {
      _isSending = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isSending = false;
      });
      Navigator.pop(context, comment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _commentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Votre commentaire...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isSending ? null : _submitComment,
              icon: _isSending
                  ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  : const Icon(Icons.send),
              label: Text(_isSending ? "Envoi..." : "Publier"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
