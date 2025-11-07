import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CommentTextfield extends StatefulWidget {
  final void Function(String) onSend;
  final bool isLoading;

  const CommentTextfield({required this.onSend, required this.isLoading, super.key});

  @override
  State<CommentTextfield> createState() => _CommentTextfieldState();
}

class _CommentTextfieldState extends State<CommentTextfield> {
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
          child: ShadInput(
            maxLines: null,
            controller: commentController,
            placeholder: Text('Write a comment...'),
            padding: EdgeInsets.all(15),
            decoration: ShadDecoration(
              border: ShadBorder.all(
                radius: BorderRadius.circular(12),
                color: Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        widget.isLoading
            ? SizedBox.square(dimension: 50, child: CircularProgressIndicator())
            : IconButton.filled(
                onPressed: () => widget.onSend(commentController.text),
                icon: const Icon(Icons.send, color: Colors.white),
              ),
      ],
    );
  }
}
