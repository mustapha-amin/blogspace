import 'package:auto_route/auto_route.dart';
import 'package:blogspace/core/routes/router.gr.dart';
import 'package:blogspace/features/blog/models/blog_response.dart';
import 'package:blogspace/features/blog/notifiers/blog_notifer.dart';
import 'package:blogspace/features/blog/widgets/blog_post_card.dart';
import 'package:blogspace/shared/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

@RoutePage()
class BlogsScreen extends ConsumerWidget {
  const BlogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blogsAsync = ref.watch(blogNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.router.push(ProfileRoute());
            },
            icon: Icon(Iconsax.profile_circle, size: 30),
          ),
          Gap(5),
        ],
        scrolledUnderElevation: 0,
        title: Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(Iconsax.note, size: 20, color: Colors.white),
              ),
            ),
            Text(
              'BlogSpace',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: blogsAsync.when(
        data: (blogResponse) {
          if (blogResponse.error != null) {
            return Center(child: Text(blogResponse.error!));
          }

          final posts = blogResponse.posts;
          if (posts == null || posts.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.article_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No blog posts found'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(blogNotifierProvider.future),
            child: ListView.builder(
              itemCount: posts.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final post = posts[index];
                return BlogPostCard(
                  post: post,
                  onTap: () {
                    context.router.push(BlogDetailRoute(post: post));
                  },
                );
              },
            ),
          );
        },
        loading: () => const LoadingScreen(),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.push(BlogCreationRoute());
        },
        child: Icon(Iconsax.note_add),
      ),
    );
  }
}
