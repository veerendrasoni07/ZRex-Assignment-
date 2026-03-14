import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class PostActions extends StatelessWidget {
  const PostActions({
    super.key,
    required this.isLiked,
    required this.isSaved,
    required this.onLike,
    required this.onSave,
    required this.onComment,
    required this.onShare,
  });

  final bool isLiked;
  final bool isSaved;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onComment;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onLike,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                key: ValueKey<bool>(isLiked),
                color: isLiked ? AppColors.like : AppColors.iconPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: onComment,
            icon: const Icon(Icons.chat_bubble_outline, color: AppColors.iconPrimary),
          ),
          IconButton(
            onPressed: onShare,
            icon: const Icon(Icons.send_outlined, color: AppColors.iconPrimary),
          ),
          const Spacer(),
          IconButton(
            onPressed: onSave,
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: AppColors.iconPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
