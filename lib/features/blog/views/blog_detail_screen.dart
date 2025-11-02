import 'package:auto_route/annotations.dart';
import 'package:blogspace/features/blog/models/blog_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

@RoutePage()
class BlogDetailScreen extends ConsumerStatefulWidget {
  final BlogPost post;

  const BlogDetailScreen({super.key, required this.post});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BlogDetailScreenState();
}

class _BlogDetailScreenState extends ConsumerState<BlogDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showFloatingTitle) {
      setState(() => _showFloatingTitle = true);
    } else if (_scrollController.offset <= 200 && _showFloatingTitle) {
      setState(() => _showFloatingTitle = false);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final post = widget.post;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar with animated title
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            title: AnimatedOpacity(
              opacity: _showFloatingTitle ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                post.title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  // TODO: Implement share functionality
                },
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {
                  // TODO: Implement bookmark functionality
                },
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    post.title!,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),

                Gap(20),

                  // Author info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          post.user!.username!.isNotEmpty
                              ? post.user!.username![0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.user!.username!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          Gap(2),
                            Row(
                              children: [
                                Text(
                                  timeago.format(post.createdAt!),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                                if (post.createdAt != post.updatedAt) ...[
                                  Text(
                                    ' • ',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                  Text(
                                    'Edited',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Follow button (optional)
                      OutlinedButton(
                        onPressed: () {
                          // TODO: Implement follow functionality
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text('Follow'),
                      ),
                    ],
                  ),

                Gap(32),

                  // Divider
                  Divider(color: theme.colorScheme.outlineVariant),

                Gap(24),

                  // Content
                  SelectableText(
                    post.content!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.8,
                      fontSize: 17,
                      letterSpacing: 0.1,
                    ),
                  ),

                Gap(48),

                  Divider(color: theme.colorScheme.outlineVariant),

                Gap(24),

                  // Comments section
                  Text(
                    'Comments',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                Gap(16),

                  // Empty state for comments
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 48,
                            color: theme.colorScheme.onSurface.withOpacity(0.3),
                          ),
                        Gap(12),
                          Text(
                            'No comments yet',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.6,
                              ),
                            ),
                          ),
                        Gap(4),
                          Text(
                            'Be the first to share your thoughts',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                Gap(24),

                  // Comment input field
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.person,
                          size: 20,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Write a comment...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              // TODO: Submit comment
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: () {
                          // TODO: Submit comment
                        },
                        icon: const Icon(Icons.send, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
