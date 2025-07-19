// chat_detail_screen.dart (suite et fin)
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';

class Message {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final MessageStatus status;

  Message({
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });
}

enum MessageStatus { sending, sent, delivered, read }

class ChatDetailScreen extends StatefulWidget {
  final String chatName;
  
  const ChatDetailScreen({
    super.key,
    required this.chatName,
  });

  @override
  State createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isTyping = false;
  bool _showScrollToBottom = false;
  bool _isAttachmentMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
    _scrollController.addListener(_scrollListener);

    // Simuler que l'autre personne est en train d'écrire
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isTyping = true;
      });
      
      Future.delayed(const Duration(seconds: 4), () {
        _receiveMessage("Bonjour ! Comment puis-je vous aider dans votre orientation scolaire aujourd'hui ?");
        setState(() {
          _isTyping = false;
        });
      });
    });
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      setState(() {
        _showScrollToBottom = currentScroll < maxScroll - 200;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialMessages() {
    // Charger quelques messages d'exemple
    final now = DateTime.now();
    
    if (widget.chatName == "Conseiller d'orientation") {
      _messages.addAll([
        Message(
          text: "Bonjour, je suis en terminale et j'hésite entre plusieurs filières après le bac. Comment choisir ?",
          isMe: true,
          timestamp: now.subtract(const Duration(days: 1, hours: 2)),
          status: MessageStatus.read,
        ),
        Message(
          text: "Bonjour ! C'est normal d'hésiter à ce stade. Pour vous aider, j'aurais besoin de connaître vos matières préférées et vos points forts.",
          isMe: false,
          timestamp: now.subtract(const Duration(days: 1, hours: 1, minutes: 55)),
        ),
        Message(
          text: "J'aime beaucoup les mathématiques et la physique, mais aussi la littérature.",
          isMe: true,
          timestamp: now.subtract(const Duration(days: 1, hours: 1, minutes: 50)),
          status: MessageStatus.read,
        ),
        Message(
          text: "Excellent ! Avec ce profil, plusieurs voies s'offrent à vous : classes préparatoires scientifiques, écoles d'ingénieurs avec prépa intégrée, ou licences double-cursus sciences/lettres.",
          isMe: false,
          timestamp: now.subtract(const Duration(days: 1, hours: 1, minutes: 45)),
        ),
      ]);
    } else if (widget.chatName == "Dr. Konan - Psychologue") {
      _messages.addAll([
        Message(
          text: "Bonjour Dr. Konan, je suis très stressé(e) par l'approche des examens et l'orientation.",
          isMe: true,
          timestamp: now.subtract(const Duration(days: 2, hours: 3)),
          status: MessageStatus.read,
        ),
        Message(
          text: "Je comprends votre inquiétude. Le stress face aux examens est tout à fait normal. Avez-vous essayé des techniques de relaxation ?",
          isMe: false,
          timestamp: now.subtract(const Duration(days: 2, hours: 2, minutes: 55)),
        ),
      ]);
    } else if (widget.chatName.contains("Bot")) {
      _messages.addAll([
        Message(
          text: "J'aimerais en savoir plus sur les études de médecine.",
          isMe: true,
          timestamp: now.subtract(const Duration(days: 3, hours: 5)),
          status: MessageStatus.read,
        ),
        Message(
          text: "Les études de médecine sont exigeantes mais passionnantes. Voici les points essentiels :\n\n• Durée : 9 à 12 ans selon la spécialité\n• Admission : concours très sélectif\n• Qualités requises : rigueur, capacité de travail, empathie\n• Débouchés : nombreux et variés",
          isMe: false,
          timestamp: now.subtract(const Duration(days: 3, hours: 4, minutes: 55)),
        ),
      ]);
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(
          Message(
            text: text,
            isMe: true,
            timestamp: DateTime.now(),
            status: MessageStatus.sending,
          ),
        );
        _messageController.clear();
      });
      
      // Simuler l'envoi du message (délai et changement de statut)
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _messages.last = Message(
            text: _messages.last.text,
            isMe: true,
            timestamp: _messages.last.timestamp,
            status: MessageStatus.sent,
          );
        });
      });
      
      _scrollToBottom();
      
      // Simuler que l'autre personne est en train d'écrire
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isTyping = true;
        });
        
        // Simuler une réponse après un délai
        Future.delayed(Duration(seconds: 2 + Random().nextInt(3)), () {
          _simulateResponse(text);
          setState(() {
            _isTyping = false;
          });
        });
      });
    }
  }
  
  void _receiveMessage(String text) {
    setState(() {
      _messages.add(
        Message(
          text: text,
          isMe: false,
          timestamp: DateTime.now(),
        ),
      );
    });
    _scrollToBottom();
  }
  
  void _simulateResponse(String userMessage) {
    String response;
    
    if (widget.chatName == "Conseiller d'orientation") {
      if (userMessage.toLowerCase().contains("orientation") || 
          userMessage.toLowerCase().contains("filière") ||
          userMessage.toLowerCase().contains("étude")) {
        response = "Pour vous orienter, je vous conseille de faire un bilan d'orientation. Nous pouvons organiser un rendez-vous pour discuter de vos aptitudes et centres d'intérêt.";
      } else if (userMessage.toLowerCase().contains("bac") || 
                userMessage.toLowerCase().contains("examen")) {
        response = "Le baccalauréat est une étape importante. Avez-vous déjà commencé vos révisions ? Je peux vous proposer des méthodes efficaces adaptées à votre profil.";
      } else {
        response = "C'est noté. Avez-vous des questions spécifiques concernant votre orientation ou votre parcours académique ?";
      }
    } else if (widget.chatName == "Dr. Konan - Psychologue") {
      response = "Je vous propose de prendre rendez-vous pour approfondir ce sujet en séance. Êtes-vous disponible la semaine prochaine ?";
    } else if (widget.chatName.contains("Bot")) {
      response = "Voici des informations qui pourraient vous intéresser. Souhaitez-vous en savoir plus sur un aspect particulier ?";
    } else {
      response = "Merci pour votre message. Comment puis-je vous aider davantage dans votre parcours d'orientation ?";
    }
    
    _receiveMessage(response);
  }

  void _scrollToBottom() {
    // Donner un petit délai pour que la liste soit mise à jour
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  Widget _buildMessageBubble(Message message) {
    final isMe = message.isMe;
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: isMe ? 64 : 16,
          right: isMe ? 16 : 64,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe 
              ? AppColors.primary.withOpacity(0.9)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(18).copyWith(
            bottomRight: isMe ? const Radius.circular(4) : null,
            bottomLeft: !isMe ? const Radius.circular(4) : null,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: isMe ? AppColors.white : AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    color: isMe ? AppColors.white.withOpacity(0.7) : AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.status == MessageStatus.sending
                        ? Icons.schedule
                        : message.status == MessageStatus.sent
                            ? Icons.check
                            : message.status == MessageStatus.delivered
                                ? Icons.done_all
                                : Icons.done_all,
                    size: 14,
                    color: message.status == MessageStatus.read
                        ? AppColors.white.withOpacity(0.9)
                        : AppColors.white.withOpacity(0.7),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSeparator(DateTime date) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          DateFormat('dd MMMM yyyy', 'fr_FR').format(date),
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Grouper les messages par date
    final groupedMessages = <DateTime, List<Message>>{};
    for (var message in _messages) {
      final date = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );
      
      if (!groupedMessages.containsKey(date)) {
        groupedMessages[date] = [];
      }
      
      groupedMessages[date]!.add(message);
    }
    
    // Trier les dates
    final sortedDates = groupedMessages.keys.toList()..sort();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surface,
              child: Text(
                widget.chatName.substring(0, 1),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatName,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_isTyping)
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'En train d\'écrire...',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 11,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: AppColors.white),
            onPressed: () {
              // Appel vidéo
            },
          ),
          IconButton(
            icon: const Icon(Icons.call, color: AppColors.white),
            onPressed: () {
              // Appel vocal
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.white),
            onPressed: () {
              // Menu d'options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const NetworkImage('https://via.placeholder.com/400x800'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        AppColors.background.withOpacity(0.95),
                        BlendMode.lighten,
                      ),
                    ),
                  ),
                  child: sortedDates.isEmpty
                      ? const Center(
                          child: Text(
                            'Démarrez la conversation !',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          reverse: false,
                          itemCount: sortedDates.length * 2 - 1, // Pour les séparateurs
                          itemBuilder: (context, index) {
                            if (index % 2 == 0) {
                              // Séparateur de date
                              final dateIndex = index ~/ 2;
                              final date = sortedDates[dateIndex];
                              
                              return Column(
                                children: [
                                  _buildDateSeparator(date),
                                  ...groupedMessages[date]!.map((message) => _buildMessageBubble(message)),
                                ],
                              );
                            } else {
                              return const SizedBox(); // Espace entre les groupes
                            }
                          },
                        ),
                ),
                if (_showScrollToBottom)
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: AppColors.surface,
                      elevation: 4,
                      onPressed: _scrollToBottom,
                      child: const Icon(
                        Icons.arrow_downward,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isAttachmentMenuOpen ? 120 : 0,
            color: AppColors.surface,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAttachmentOption(Icons.image, 'Photos', Colors.purple),
                    _buildAttachmentOption(Icons.insert_drive_file, 'Documents', Colors.blue),
                    _buildAttachmentOption(Icons.location_on, 'Lieu', Colors.orange),
                    _buildAttachmentOption(Icons.poll, 'Sondage', Colors.green),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isAttachmentMenuOpen ? Icons.close : Icons.attach_file,
                    color: AppColors.secondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isAttachmentMenuOpen = !_isAttachmentMenuOpen;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: AppColors.secondary),
                  onPressed: () {
                    // Accès à la caméra
                  },
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Message',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: AppColors.secondary),
                  onPressed: () {
                    // Enregistrement vocal
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primary),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
