import 'package:flutter/material.dart';

enum ActionButtonType {
  like,
  dislike,
}

class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final ActionButtonType type;

  const ActionButton({
    super.key,
    required this.onPressed,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: type.name,
      onPressed: onPressed,
      backgroundColor:
          type == ActionButtonType.like ? Colors.green : Colors.red,
      child: Icon(
        type == ActionButtonType.like ? Icons.favorite : Icons.close,
        color: Colors.white,
        size: 32,
      ),
    );
  }
}

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
        ActionButton(
          type: ActionButtonType.dislike,
          onPressed: onDislike,
        ),
        ActionButton(
          type: ActionButtonType.like,
          onPressed: onLike,
        ),
      ],
    );
  }
}
