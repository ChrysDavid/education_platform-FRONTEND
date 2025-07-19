// forum_list_screen.dart
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ForumListScreen extends StatefulWidget {
  const ForumListScreen({super.key});

  @override
  _ForumListScreenState createState() => _ForumListScreenState();
}

class _ForumListScreenState extends State<ForumListScreen> {
  List<Post> posts = [
    Post(
      id: '1',
      authorName: 'Dr. Sarah Kouassi',
      authorAvatar: 'assets/avatars/sarah.jpg',
      authorTitle: 'Conseillère d\'orientation',
      timeAgo: '2h',
      content:
          'Les inscriptions pour les bourses d\'études à l\'étranger sont ouvertes ! N\'hésitez pas à postuler pour les programmes d\'ingénierie en Europe. Date limite : 15 mai 2025. Les inscriptions pour les bourses d\'études à l\'étranger sont ouvertes ! N\'hésitez pas à postuler pour les programmes d\'ingénierie en Europe. Date limite : 15 mai 2025. v Les inscriptions pour les bourses d\'études à l\'étranger sont ouvertes ! N\'hésitez pas à postuler pour les programmes d\'ingénierie en Europe. Date limite : 15 mai 2025. Les inscriptions pour les bourses d\'études à l\'étranger sont ouvertes ! N\'hésitez pas à postuler pour les programmes d\'ingénierie en Europe. Date limite : 15 mai 2025. Les inscriptions pour les bourses d\'études à l\'étranger sont ouvertes ! N\'hésitez pas à postuler pour les programmes d\'ingénierie en Europe. Date limite : 15 mai 2025. Les inscriptions pour les bourses d\'études à l\'étranger sont ouvertes ! N\'hésitez pas à postuler pour les programmes d\'ingénierie en Europe. Date limite : 15 mai 2025. Les inscriptions pour les bourses d\'études à l\'étranger sont ouvertes ! N\'hésitez pas à postuler pour les programmes d\'ingénierie en Europe. Date limite : 15 mai 2025.',
      imageUrl: 'assets/images/pngtree.png',
      likes: 24,
      comments: 8,
      isLiked: false,
    ),
    Post(
      id: '2',
      authorName: 'Mohamed Traoré',
      authorAvatar: 'assets/avatars/mohamed.jpg',
      authorTitle: 'Étudiant en Médecine',
      timeAgo: '4h',
      content:
          'Salut les étudiants ! Je partage mon expérience en première année de médecine. Les concours sont difficiles mais avec de la persévérance, tout est possible. Courage à tous ! 💪',
      likes: 45,
      comments: 12,
      isLiked: true,
    ),
    Post(
      id: '3',
      authorName: 'Prof. Aya Diabaté',
      authorAvatar: 'assets/avatars/aya.jpg',
      authorTitle: 'Professeure d\'Économie',
      timeAgo: '1j',
      content:
          'Nouvelle opportunité de stage dans le domaine de la finance à Abidjan. Les entreprises recherchent des profils en économie et gestion. Préparez vos CV !',
      imageUrl: 'assets/images/pngtree.png',
      likes: 67,
      comments: 23,
      isLiked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostCard(
            post: posts[index],
            onLike: () {
              setState(() {
                posts[index].isLiked = !posts[index].isLiked;
                if (posts[index].isLiked) {
                  posts[index].likes++;
                } else {
                  posts[index].likes--;
                }
              });
            },
            onComment: () {
              _showCommentsModal(context, posts[index]);
            },
            onShare: () {
              _sharePost(posts[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        onPressed: () {
          _showCreatePostModal(context);
        },
        child: Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  void _showCommentsModal(BuildContext context, Post post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsModal(post: post),
    );
  }

  void _sharePost(Post post) {
    // Logique de partage
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post partagé !'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showCreatePostModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreatePostModal(),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const PostCard({super.key, 
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête du post
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    post.authorName[0],
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        post.authorTitle,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  post.timeAgo,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: AppColors.textSecondary),
                  onPressed: () {
                    // Menu d'options
                  },
                ),
              ],
            ),
          ),
          // Contenu du post
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ExpandableText(
              post.content,
              expandText: 'Plus',
              collapseText: 'Moins',
              maxLines: 3,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.5,
              ),
              linkStyle: TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              animation: true,
              animationDuration: Duration(milliseconds: 200),
            ),
          ),
          // Image si présente
          if (post.imageUrl != null)
            Container(
              height: 200,
              width: double.infinity,
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(post.imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          // Boutons d'action
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: onLike,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: post.isLiked
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                post.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: post.isLiked
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                size: 20,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${post.likes}',
                                style: TextStyle(
                                  color: post.isLiked
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      GestureDetector(
                        onTap: onComment,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.comment_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${post.comments}',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onShare,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.share_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

class CommentsModal extends StatefulWidget {
  final Post post;

  const CommentsModal({super.key, required this.post});

  @override
  _CommentsModalState createState() => _CommentsModalState();
}

class _CommentsModalState extends State<CommentsModal> {
  final TextEditingController _commentController = TextEditingController();
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    // Données d'exemple pour les commentaires
    comments = [
      Comment(
        id: '1',
        authorName: 'Yaya Bamba',
        authorAvatar: 'assets/avatars/yaya.jpg',
        timeAgo: '1h',
        content: 'Merci pour l\'information ! C\'est très utile.',
        likes: 5,
        isLiked: false,
        replies: [
          Reply(
            id: '1-1',
            authorName: 'Dr. Sarah Kouassi',
            timeAgo: '45min',
            content:
                'Avec plaisir ! N\'hésitez pas si vous avez des questions.',
          ),
        ],
      ),
      Comment(
        id: '2',
        authorName: 'Fatou Cissé',
        authorAvatar: 'assets/avatars/fatou.jpg',
        timeAgo: '3h',
        content:
            'Quelqu\'un connaît-il les critères de sélection pour ces bourses ?',
        likes: 12,
        isLiked: true,
        replies: [],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // En-tête
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Text(
                      'Commentaires',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Liste des commentaires
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return CommentCard(
                      comment: comments[index],
                      onLike: () {
                        setState(() {
                          comments[index].isLiked = !comments[index].isLiked;
                          if (comments[index].isLiked) {
                            comments[index].likes++;
                          } else {
                            comments[index].likes--;
                          }
                        });
                      },
                      onReply: () {
                        _showReplyDialog(context, comments[index]);
                      },
                    );
                  },
                ),
              ),
              // Champ de saisie pour nouveau commentaire
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border:
                      Border(top: BorderSide(color: AppColors.surfaceVariant)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        'M', // Initial de l'utilisateur actuel
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Écrivez un commentaire...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppColors.surfaceVariant,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: IconButton(
                        icon: Icon(Icons.send, color: AppColors.white),
                        onPressed: () {
                          if (_commentController.text.isNotEmpty) {
                            setState(() {
                              comments.insert(
                                  0,
                                  Comment(
                                    id: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                    authorName: 'Vous',
                                    authorAvatar: '',
                                    timeAgo: 'maintenant',
                                    content: _commentController.text,
                                    likes: 0,
                                    isLiked: false,
                                    replies: [],
                                  ));
                              _commentController.clear();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReplyDialog(BuildContext context, Comment comment) {
    final TextEditingController replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Répondre à ${comment.authorName}'),
        content: TextField(
          controller: replyController,
          decoration: InputDecoration(
            hintText: 'Écrivez votre réponse...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (replyController.text.isNotEmpty) {
                setState(() {
                  comment.replies.add(Reply(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    authorName: 'Vous',
                    timeAgo: 'maintenant',
                    content: replyController.text,
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: Text('Répondre'),
          ),
        ],
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  final Comment comment;
  final VoidCallback onLike;
  final VoidCallback onReply;

  const CommentCard({super.key, 
    required this.comment,
    required this.onLike,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary,
                child: Text(
                  comment.authorName[0],
                  style: TextStyle(color: AppColors.white),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment.authorName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          comment.timeAgo,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      comment.content,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: onLike,
                          child: Row(
                            children: [
                              Icon(
                                comment.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 16,
                                color: comment.isLiked
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${comment.likes}',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        GestureDetector(
                          onTap: onReply,
                          child: Text(
                            'Répondre',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Affichage des réponses
          if (comment.replies.isNotEmpty)
            ...comment.replies.map((reply) => ReplyCard(reply: reply)),
        ],
      ),
    );
  }
}

class ReplyCard extends StatelessWidget {
  final Reply reply;

  const ReplyCard({super.key, required this.reply});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 48, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.secondary,
            child: Text(
              reply.authorName[0],
              style: TextStyle(color: AppColors.white, fontSize: 12),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      reply.authorName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      reply.timeAgo,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  reply.content,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
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

class CreatePostModal extends StatefulWidget {
  const CreatePostModal({super.key});

  @override
  _CreatePostModalState createState() => _CreatePostModalState();
}

class _CreatePostModalState extends State<CreatePostModal> {
  final TextEditingController _postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // En-tête
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Text(
                      'Créer un post',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (_postController.text.isNotEmpty) {
                          // Logique de création de post
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Post créé avec succès !'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                      ),
                      child: Text('Publier'),
                    ),
                  ],
                ),
              ),
              // Contenu
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              'M', // Initial de l'utilisateur actuel
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _postController,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: 'Que voulez-vous partager ?',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                ),
                              ),
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      // Options d'ajout de contenu
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.surfaceVariant),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildAddOption(
                              icon: Icons.image,
                              label: 'Photo',
                              onTap: () {
                                // Logique d'ajout de photo
                              },
                            ),
                            _buildAddOption(
                              icon: Icons.attach_file,
                              label: 'Fichier',
                              onTap: () {
                                // Logique d'ajout de fichier
                              },
                            ),
                            _buildAddOption(
                              icon: Icons.poll,
                              label: 'Sondage',
                              onTap: () {
                                // Logique d'ajout de sondage
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.textSecondary,
              size: 24,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// Modèles de données
class Post {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String authorTitle;
  final String timeAgo;
  final String content;
  final String? imageUrl;
  int likes;
  int comments;
  bool isLiked;

  Post({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.authorTitle,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.isLiked,
  });
}

class Comment {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String timeAgo;
  final String content;
  int likes;
  bool isLiked;
  List<Reply> replies;

  Comment({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.isLiked,
    required this.replies,
  });
}

class Reply {
  final String id;
  final String authorName;
  final String timeAgo;
  final String content;

  Reply({
    required this.id,
    required this.authorName,
    required this.timeAgo,
    required this.content,
  });
}
