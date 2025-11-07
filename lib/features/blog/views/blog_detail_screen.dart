import 'package:auto_route/annotations.dart';
import 'package:blogspace/features/blog/models/blog_post.dart';
import 'package:blogspace/features/blog/notifiers/comments_providers.dart';
import 'package:blogspace/features/blog/widgets/comment_textfield.dart';
import 'package:blogspace/features/blog/widgets/empty_comments_placeholder.dart';
import 'package:blogspace/shared/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
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
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
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
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
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
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Gap(2),
                                  Row(
                                    children: [
                                      Text(
                                        timeago.format(post.createdAt!),
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme.colorScheme.onSurface
                                                  .withOpacity(0.6),
                                            ),
                                      ),
                                      if (post.createdAt != post.updatedAt) ...[
                                        Text(
                                          ' • ',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.6),
                                              ),
                                        ),
                                        Text(
                                          'Edited',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurface
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

                        ref
                            .watch(commentsNotifierProvider(post.id!))
                            .when(
                              data: (comments) {
                                return comments.isEmpty
                                    ? EmptyCommentsPlaceholder()
                                    : Expanded(
                                        child: ListView.builder(
                                          itemBuilder: (context, index) {
                                            final comment = comments[index];
                                            return ListTile(
                                              title: Text(
                                                comment.user!.username!,
                                              ),
                                              subtitle: Text(comment.comment!),
                                              leading: CircleAvatar(
                                                child: Text(
                                                  comment.user!.username![0],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                              },
                              error: (err, _) {
                                return Center(child: Text(err.toString()));
                              },
                              loading: () {
                                return Center(child: LoadingWidget());
                              },
                            ),

                        Gap(24),

                        // Comment input field
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CommentTextfield(
              onSend: (comment) {
                ref
                    .read(commentsNotifierProvider(post.id!).notifier)
                    .addComment(context, comment);
              },
              isLoading: ref.watch(commentIsLoadingProvider),
            ),
          ),
          Gap(20),
        ],
      ),
    );
  }
}
