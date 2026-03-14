import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/post_model.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: post.userAvatarUrl,
              width: 36,
              height: 36,
              fit: BoxFit.cover,
              placeholder: (context, _) => Container(color: AppColors.shimmerBase),
              errorWidget: (context, _, __) => Container(
                width: 36,
                height: 36,
                color: AppColors.shimmerBase,
                child: const Icon(Icons.person, color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              post.userName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
          const Icon(Icons.more_vert, color: AppColors.iconPrimary),
        ],
      ),
    );
  }
}
