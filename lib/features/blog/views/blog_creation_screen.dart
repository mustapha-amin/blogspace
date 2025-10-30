import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class BlogCreationScreen extends ConsumerStatefulWidget {
  const BlogCreationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlogCreationScreenState();
}

class _BlogCreationScreenState extends ConsumerState<BlogCreationScreen> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}