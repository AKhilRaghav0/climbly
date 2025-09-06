import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skillforge/features/advisor/advisor_viewmodel.dart';
import 'package:skillforge/features/advisor/widgets/typewriter_text_widget.dart';

class ModernChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ModernChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: PhosphorIcon(
                PhosphorIcons.robot(),
                color: Theme.of(context).colorScheme.onPrimary,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: isUser 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(6),
                  bottomRight: isUser ? const Radius.circular(6) : const Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isUser 
                  ? Text(
                      message.content,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  : TypewriterTextWidget(
                      text: message.content,
                      isMarkdown: true,
                      speed: const Duration(milliseconds: 15),
                      markdownStyleSheet: MarkdownStyleSheet(
                        p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                        h1: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                        h2: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        h3: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        strong: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                        em: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                        listBullet: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                        code: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontFamily: 'monospace',
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          fontSize: 13,
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        codeblockPadding: const EdgeInsets.all(12),
                      ),
                    ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: PhosphorIcon(
                PhosphorIcons.user(),
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
