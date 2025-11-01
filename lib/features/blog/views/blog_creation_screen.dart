import 'package:auto_route/auto_route.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create post"),
        centerTitle: true,
        actions: [
          ShadButton.ghost(
            foregroundColor: Colors.blue,
            child: Text("Post", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ShadInput(
              placeholder: Text("Title", style: TextStyle(fontSize: 22)),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              decoration: ShadDecoration.none,
            ),
            ShadInputFormField(
              placeholder: Text("Content", style: TextStyle(fontSize: 16)),
              decoration: ShadDecoration.none,
            ),
          ],
        ),
      ),
    );
  }
}
