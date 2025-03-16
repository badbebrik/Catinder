import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const ActionButtons({
    super.key,
    required this.onLike,
    required this.onDislike,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FloatingActionButton(
          heroTag: 'dislike',
          onPressed: onDislike,
          backgroundColor: Colors.red,
          child: const Icon(Icons.close, color: Colors.white, size: 32),
        ),
        FloatingActionButton(
          heroTag: 'like',
          onPressed: onLike,
          backgroundColor: Colors.green,
          child: const Icon(Icons.favorite, color: Colors.white, size: 32),
        ),
      ],
    );
  }
}
