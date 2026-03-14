import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/post_model.dart';
import 'post_actions.dart';
import 'post_caption.dart';
import 'post_carousel.dart';
import 'post_header.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.onToggleLike,
    required this.onToggleSave,
  });

  final PostModel post;
  final void Function(String postId) onToggleLike;
  final void Function(String postId) onToggleSave;

  void _showActionSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.textPrimary,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostHeader(post: post),
        PostCarousel(imageUrls: post.imageUrls),
        PostActions(
          isLiked: post.isLiked,
          isSaved: post.isSaved,
          onLike: () => onToggleLike(post.id),
          onSave: () => onToggleSave(post.id),
          onComment: () => _showActionSnack(context, 'Comments coming soon'),
          onShare: () => _showActionSnack(context, 'Share sheet opening'),
        ),
        PostCaption(post: post),
        const SizedBox(height: 8),
      ],
    );
  }
}
