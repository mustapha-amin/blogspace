import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class BlogsScreen extends ConsumerStatefulWidget {
  const BlogsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends ConsumerState<BlogsScreen> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}