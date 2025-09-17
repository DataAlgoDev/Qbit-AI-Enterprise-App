import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../services/rag_service.dart';

class AskMeScreen extends StatefulWidget {
  const AskMeScreen({super.key});

  @override
  State<AskMeScreen> createState() => _AskMeScreenState();
}

class _AskMeScreenState extends State<AskMeScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  
  static const String _welcomeMessage = "Hi! I'm your AI assistant. I can help you with:\n\n• Company policies and benefits\n• Leave policies and procedures\n• Health insurance information\n• IT support requests\n• HR queries\n\nWhat would you like to know?";

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(
      ChatMessage(
        text: _welcomeMessage,
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: _messageController.text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
    });

    // Get AI response from RAG service
    _getRagResponse(userMessage.text);

    _messageController.clear();
    _scrollToBottom();
  }

  void _getRagResponse(String userMessage) async {
    // Show typing indicator
    setState(() {
      _messages.add(
        ChatMessage(
          text: "Reasoning...",
          isUser: false,
          timestamp: DateTime.now(),
          isTyping: true,
        ),
      );
    });
    _scrollToBottom();

    try {
      // Call real RAG service
      final response = await RagService.sendMessage(userMessage);
      
      // Remove typing indicator
      setState(() {
        _messages.removeLast();
        
        // Add real AI response
        _messages.add(
          ChatMessage(
            text: response['response'] ?? 'Sorry, I could not generate a response.',
            isUser: false,
            timestamp: DateTime.now(),
            sources: List<String>.from(response['sources'] ?? []),
          ),
        );
      });
    } catch (e) {
      // Remove typing indicator and show error
      setState(() {
        _messages.removeLast();
        _messages.add(
          ChatMessage(
            text: "Sorry, I'm having trouble connecting to the knowledge base. Please make sure the RAG backend is running.\n\nError: $e",
            isUser: false,
            timestamp: DateTime.now(),
            isError: true,
          ),
        );
      });
    }
    
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask Me'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(MdiIcons.deleteOutline),
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add(
                  ChatMessage(
                    text: _welcomeMessage,
                    isUser: false,
                    timestamp: DateTime.now(),
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Actions
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickActionChip('Leave Policy', MdiIcons.calendarClock),
                  const SizedBox(width: 8),
                  _buildQuickActionChip('Health Insurance', MdiIcons.heartPulse),
                  const SizedBox(width: 8),
                  _buildQuickActionChip('IT Support', MdiIcons.laptopAccount),
                  const SizedBox(width: 8),
                  _buildQuickActionChip('Company Policies', MdiIcons.fileDocumentOutline),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          
          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything about company policies...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  mini: true,
                  child: Icon(MdiIcons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionChip(String label, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: () {
        _messageController.text = label;
        _sendMessage();
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF1565C0),
              child: Icon(
                MdiIcons.robot,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isError 
                    ? Colors.red[50]
                    : message.isUser 
                        ? const Color(0xFF1565C0) 
                        : Colors.grey[100],
                border: message.isError ? Border.all(color: Colors.red[300]!) : null,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: message.isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: message.isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Typing indicator
                  if (message.isTyping) ...[
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          message.text,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Regular message
                    Text(
                      message.text,
                      style: TextStyle(
                        color: message.isError
                            ? Colors.red[700]
                            : message.isUser 
                                ? Colors.white 
                                : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    
                    // Sources (for AI responses)
                    if (message.sources != null && message.sources!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.source,
                                  size: 14,
                                  color: Colors.blue[700],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Sources:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ...message.sources!.map((source) => Text(
                              '• $source',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.blue[600],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 4),
                    Text(
                      '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: message.isError
                            ? Colors.red[400]
                            : message.isUser 
                                ? Colors.white70 
                                : Colors.grey[600],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: Icon(
                MdiIcons.account,
                color: Colors.grey[600],
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? sources;
  final bool isTyping;
  final bool isError;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.sources,
    this.isTyping = false,
    this.isError = false,
  });
}
