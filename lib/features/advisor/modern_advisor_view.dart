import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skillforge/providers/user_provider.dart';
import 'package:skillforge/features/advisor/advisor_viewmodel.dart';
import 'package:skillforge/features/advisor/widgets/modern_chat_message_widget.dart';
import 'package:skillforge/features/advisor/widgets/typewriter_text_widget.dart';
import 'package:skillforge/services/resume_service.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ModernAdvisorView extends StatefulWidget {
  const ModernAdvisorView({super.key});

  @override
  State<ModernAdvisorView> createState() => _ModernAdvisorViewState();
}

class _ModernAdvisorViewState extends State<ModernAdvisorView>
    with TickerProviderStateMixin {
  late final TextEditingController _messageController;
  late final ScrollController _scrollController;
  late final AnimationController _sendButtonController;
  late final AdvisorViewModel _viewModel;
  bool _hasMessages = false;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    _sendButtonController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _viewModel = AdvisorViewModel();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _sendButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildChatArea(context),
              ),
              _buildInputArea(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _hasMessages ? 60 : 80,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: _hasMessages
          ? Row(
              children: [
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: PhosphorIcon(
                            PhosphorIcons.robot(),
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AI Career Advisor',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _showClearChatDialog(context),
                  icon: PhosphorIcon(
                    PhosphorIcons.trash(),
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                'AI Career Advisor',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }

  Widget _buildChatArea(BuildContext context) {
    return Consumer<AdvisorViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.messages.isEmpty) {
          return _buildEmptyState(context);
        }

        return Column(
          children: [
            if (!_hasMessages) _buildQuickQuestions(context),
            Expanded(
              child: _buildIntegratedChat(context, viewModel),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIntegratedChat(BuildContext context, AdvisorViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withOpacity(0.95),
          ],
        ),
      ),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: viewModel.messages.length,
        itemBuilder: (context, index) {
          final message = viewModel.messages[index];
          return _buildIntegratedMessage(context, message, index);
        },
      ),
    );
  }

  Widget _buildIntegratedMessage(BuildContext context, ChatMessage message, int index) {
    final isUser = message.isUser;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Message content
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.85,
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isUser 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isUser 
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                      : Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isUser
                  ? Text(
                      message.content,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        height: 1.6,
                      ),
                    )
                  : TypewriterTextWidget(
                      text: message.content,
                      isMarkdown: true,
                      speed: const Duration(milliseconds: 15),
                      markdownStyleSheet: MarkdownStyleSheet(
                        p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.6,
                        ),
                        h1: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                        h2: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                        h3: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                        strong: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                        listBullet: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        code: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                          backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        codeblockPadding: const EdgeInsets.all(12),
                      ),
                    ),
            ),
          ),
          
          // Message metadata and actions
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isUser) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: PhosphorIcon(
                    PhosphorIcons.robot(),
                    color: Theme.of(context).colorScheme.primary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                isUser ? 'You' : 'Climbly AI',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatMessageTime(DateTime.now()),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                ),
              ),
              
              // Action buttons for AI messages
              if (!isUser) ...[
                const SizedBox(width: 16),
                _buildActionButton(
                  context,
                  PhosphorIcons.copy(),
                  'Copy',
                  () => _copyMessage(message.content),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  context,
                  PhosphorIcons.filePdf(),
                  'Generate PDF',
                  () => _generatePDF(message.content),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  context,
                  PhosphorIcons.mapTrifold(),
                  'Create Roadmap',
                  () => _createRoadmap(message.content),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatMessageTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.day}/${time.month}';
    }
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String tooltip, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: PhosphorIcon(
          icon,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 14,
        ),
      ),
    );
  }

  void _copyMessage(String content) {
    // TODO: Implement copy to clipboard
    debugPrint('📋 Copying message: ${content.substring(0, content.length > 50 ? 50 : content.length)}...');
  }

  void _generatePDF(String content) {
    // TODO: Implement PDF generation using flutter_pdf
    debugPrint('📄 Generating PDF for: ${content.substring(0, content.length > 50 ? 50 : content.length)}...');
  }

  void _createRoadmap(String content) {
    // TODO: Implement roadmap creation
    debugPrint('🗺️ Creating roadmap for: ${content.substring(0, content.length > 50 ? 50 : content.length)}...');
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: PhosphorIcon(
                PhosphorIcons.chatCircle(),
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'What can I help with?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildQuickQuestions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickQuestions(BuildContext context) {
    final questions = [
      'Assess my skills',
      'Career path suggestions',
      'Learning recommendations',
      'Interview preparation',
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: questions.map((question) {
        return GestureDetector(
          onTap: () => _sendMessage(question),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Text(
              question,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surface.withOpacity(0.95),
            Theme.of(context).colorScheme.surface,
          ],
        ),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          PopupMenuButton<String>(
            icon: PhosphorIcon(
              PhosphorIcons.image(),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onSelected: (value) => _handleFileSelection(value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'image',
                child: Row(
                  children: [
                    PhosphorIcon(PhosphorIcons.image()),
                    const SizedBox(width: 8),
                    const Text('Upload Resume Image'),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _messageController,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Ask anything about your career...',
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  prefixIcon: PhosphorIcon(
                    PhosphorIcons.chatCircle(),
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                    size: 20,
                  ),
                ),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.4,
                ),
                onSubmitted: (value) => _sendMessage(value),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Consumer<AdvisorViewModel>(
            builder: (context, viewModel, child) {
              return GestureDetector(
                onTap: viewModel.isLoading ? null : () {
                  _sendButtonController.forward();
                  _sendMessage(_messageController.text);
                },
                child: AnimatedBuilder(
                  animation: _sendButtonController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: viewModel.isLoading ? _sendButtonController.value * 2 * 3.14159 : 0,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: PhosphorIcon(
                          PhosphorIcons.paperPlaneTilt(),
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;
    
    setState(() {
      _hasMessages = true;
    });
    
    _viewModel.sendMessage(message, Provider.of<UserProvider>(context, listen: false).userData!);
    _messageController.clear();
    
    // Scroll to bottom
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

  void _handleFileSelection(String type) async {
    if (type == 'image') {
      try {
        final imageFile = await ResumeService.pickResumeImage();
        
        if (imageFile != null) {
          setState(() {
            _hasMessages = true;
          });
          
          _viewModel.sendMessage('I uploaded my resume for analysis', Provider.of<UserProvider>(context, listen: false).userData!);
          
          // Analyze the resume
          final result = await ResumeService.analyzeResume(imageFile);
          
          // Add AI response about resume
          _viewModel.addMessage(result, false);
        }
      } catch (e) {
        debugPrint('Error handling file selection: $e');
      }
    }
  }

  void _showClearChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Chat'),
          content: const Text('Are you sure you want to clear all messages?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _viewModel.clearChat();
                setState(() {
                  _hasMessages = false;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}
