import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EmptyCommentsPlaceholder extends StatelessWidget {
  const EmptyCommentsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha:0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha:0.3),
            ),
            Gap(12),
            Text(
              'No comments yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha:0.6),
              ),
            ),
            Gap(4),
            Text(
              'Be the first to share your thoughts',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha:0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
