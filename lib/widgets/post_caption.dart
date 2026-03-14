import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/post_model.dart';

class PostCaption extends StatelessWidget {
  const PostCaption({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: AppColors.textPrimary,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${post.likeCount} likes',
            style: baseStyle.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: post.userName,
                  style: baseStyle.copyWith(fontWeight: FontWeight.w600),
                ),
                const TextSpan(text: '  '),
                TextSpan(text: post.caption, style: baseStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
