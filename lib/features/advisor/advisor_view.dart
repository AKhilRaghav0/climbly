import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skillforge/app/theme.dart';
import 'package:skillforge/providers/user_provider.dart';
import 'package:skillforge/features/advisor/advisor_viewmodel.dart';
import 'package:skillforge/features/advisor/widgets/chat_message_widget.dart';

class AdvisorView extends StatefulWidget {
  const AdvisorView({super.key});

  @override
  State<AdvisorView> createState() => _AdvisorViewState();
}

class _AdvisorViewState extends State<AdvisorView> {
  late AdvisorViewModel _viewModel;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel = AdvisorViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: ClimblyTheme.subtleGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: _buildContent(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ClimblyTheme.charcoal,
              borderRadius: BorderRadius.circular(12),
            ),
            child:             PhosphorIcon(
              PhosphorIcons.robot(),
              color: ClimblyTheme.cream,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Career Advisor',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ClimblyTheme.charcoal,
                  ),
                ),
                Text(
                  'Your personalized career companion',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ClimblyTheme.gray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildQuickQuestions(context),
          const SizedBox(height: 24),
          _buildChatSection(context),
        ],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Questions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: ClimblyTheme.charcoal,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: questions.map((question) => _buildQuestionCard(context, question)).toList(),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(BuildContext context, String question) {
    return Consumer2<AdvisorViewModel, UserProvider>(
      builder: (context, viewModel, userProvider, child) {
        return GestureDetector(
          onTap: () => viewModel.sendQuickQuestion(question, userProvider.userData),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ClimblyTheme.cream,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ClimblyTheme.grayLight),
            ),
            child: Row(
              children: [
                PhosphorIcon(
                  PhosphorIcons.chatCircle(),
                  color: ClimblyTheme.charcoal,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ClimblyTheme.charcoal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatSection(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: ClimblyTheme.cream,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: ClimblyTheme.charcoal.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: _buildChatMessages(context),
            ),
            _buildChatInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessages(BuildContext context) {
    return Consumer<AdvisorViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.messages.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PhosphorIcon(
                  PhosphorIcons.chatCircle(),
                  color: ClimblyTheme.gray,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Start a conversation',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ClimblyTheme.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ask me anything about your career journey',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ClimblyTheme.gray,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          itemCount: viewModel.messages.length,
          itemBuilder: (context, index) {
            return ChatMessageWidget(message: viewModel.messages[index]);
          },
        );
      },
    );
  }

  Widget _buildChatInput(BuildContext context) {
    return Consumer2<AdvisorViewModel, UserProvider>(
      builder: (context, viewModel, userProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ClimblyTheme.creamLight,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type your message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) => viewModel.currentInput = value,
                  onSubmitted: (value) => _sendMessage(viewModel, userProvider),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: viewModel.isLoading ? null : () => _sendMessage(viewModel, userProvider),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: viewModel.isLoading ? ClimblyTheme.grayLight : ClimblyTheme.charcoal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: viewModel.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(ClimblyTheme.cream),
                          ),
                        )
                      : PhosphorIcon(
                          PhosphorIcons.paperPlaneTilt(),
                          color: ClimblyTheme.cream,
                          size: 20,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendMessage(AdvisorViewModel viewModel, UserProvider userProvider) {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      viewModel.sendMessage(message, userProvider.userData);
      _messageController.clear();
      _scrollToBottom();
    }
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
}
