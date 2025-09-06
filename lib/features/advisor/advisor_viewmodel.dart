import 'package:flutter/foundation.dart';
import 'package:skillforge/services/gemini_service.dart';
import 'package:skillforge/models/user_data.dart';

class AdvisorViewModel extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String _currentInput = '';

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String get currentInput => _currentInput;

  set currentInput(String value) {
    _currentInput = value;
    notifyListeners();
  }

  void addMessage(String content, bool isUser) {
    debugPrint('💬 Adding ${isUser ? 'user' : 'AI'} message: ${content.substring(0, content.length > 50 ? 50 : content.length)}...');
    _messages.add(ChatMessage(content: content, isUser: isUser));
    notifyListeners();
  }

  Future<void> sendMessage(String message, UserData userData) async {
    if (message.trim().isEmpty) {
      debugPrint('⚠️ Empty message, ignoring');
      return;
    }

    debugPrint('📤 Sending message: $message');
    
    // Add user message
    addMessage(message, true);
    currentInput = '';

    // Show loading
    _isLoading = true;
    notifyListeners();
    debugPrint('⏳ Waiting for AI response...');

    // Add placeholder message for typewriter effect
    addMessage('', false);

    try {
      // Get AI response with conversation history
      final response = await GeminiService.generateCareerAdvice(
        userData: userData,
        question: message,
        conversationHistory: _messages.take(_messages.length - 1).toList(), // Exclude the placeholder message
      );

      // Replace placeholder with actual response
      if (_messages.isNotEmpty) {
        _messages[_messages.length - 1] = ChatMessage(
          content: response,
          isUser: false,
        );
        notifyListeners();
        debugPrint('🔄 Message updated with response: ${response.substring(0, response.length > 100 ? 100 : response.length)}...');
      }
      debugPrint('✅ AI response received and added to chat');
    } catch (e) {
      debugPrint('❌ Error in sendMessage: $e');
      if (_messages.isNotEmpty) {
        _messages[_messages.length - 1] = ChatMessage(
          content: 'Sorry, I encountered an error. Please try again.',
          isUser: false,
        );
        notifyListeners();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendQuickQuestion(String question, UserData userData) async {
    await sendMessage(question, userData);
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}

class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
