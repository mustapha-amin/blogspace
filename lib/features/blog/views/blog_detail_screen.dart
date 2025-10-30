import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


@RoutePage()
class BlogDetailScreen extends ConsumerStatefulWidget {
  const BlogDetailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends ConsumerState<BlogDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}