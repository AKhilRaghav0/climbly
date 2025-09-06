import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skillforge/app/theme.dart';
import 'package:skillforge/features/advisor/advisor_viewmodel.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ClimblyTheme.charcoal,
                borderRadius: BorderRadius.circular(8),
              ),
              child: PhosphorIcon(
                PhosphorIcons.robot(),
                color: ClimblyTheme.cream,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser ? ClimblyTheme.charcoal : ClimblyTheme.cream,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: ClimblyTheme.charcoal.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: message.isUser
                  ? Text(
                      message.content,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ClimblyTheme.cream,
                      ),
                    )
                  : Text(
                      message.content,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ClimblyTheme.charcoal,
                      ),
                    ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ClimblyTheme.gray,
                borderRadius: BorderRadius.circular(8),
              ),
              child:             PhosphorIcon(
              PhosphorIcons.user(),
              color: ClimblyTheme.cream,
              size: 16,
            ),
            ),
          ],
        ],
      ),
    );
  }
}
