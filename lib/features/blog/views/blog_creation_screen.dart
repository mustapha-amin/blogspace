import 'package:auto_route/auto_route.dart';
import 'package:blogspace/features/blog/notifiers/blog_notifer.dart';
import 'package:blogspace/shared/app_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

@RoutePage()
class BlogCreationScreen extends ConsumerStatefulWidget {
  const BlogCreationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BlogCreationScreenState();
}

class _BlogCreationScreenState extends ConsumerState<BlogCreationScreen> {
  late final TextEditingController titleController, contentController;

  @override
  void initState() {
    titleController = TextEditingController();
    contentController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(blogNotifierProvider, (_, next) {
      if (next.hasError) {
        showCustomFlushbar(
          context,
          message: next.error.toString(),
          isError: true,
        );
        ref.invalidate(blogNotifierProvider);
        return;
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Create post"),
        centerTitle: true,
        actions: [
          ShadButton.ghost(
            foregroundColor: Colors.blue,
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  contentController.text.isNotEmpty) {
                ref
                    .read(blogNotifierProvider.notifier)
                    .createPost(
                      title: titleController.text.trim(),
                      content: contentController.text.trim(),
                    );
              }
            },
            child: ref.watch(blogNotifierProvider).isLoading
                ? SizedBox.square(
                    dimension: 30,
                    child: CircularProgressIndicator(),
                  )
                : Text("Post", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ShadInput(
              controller: titleController,
              placeholder: Text("Title", style: TextStyle(fontSize: 22)),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              decoration: ShadDecoration.none,
            ),
            ShadInput(
              controller: contentController,
              placeholder: Text("Content", style: TextStyle(fontSize: 16)),
              decoration: ShadDecoration.none,
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
