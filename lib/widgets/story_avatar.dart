import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../models/story_model.dart';

class StoryAvatar extends StatelessWidget {
  const StoryAvatar({super.key, required this.story});

  final StoryModel story;

  @override
  Widget build(BuildContext context) {
    final gradient = story.isSeen
        ? const LinearGradient(colors: [AppColors.border, AppColors.border])
        : const LinearGradient(
            colors: [Color(0xFFFCAF45), Color(0xFFE1306C), Color(0xFF5851DB)],
          );

    return SizedBox(
      width: AppSizes.storyBorderSize,
      child: Column(
        children: [
          Container(
            width: AppSizes.storyBorderSize,
            height: AppSizes.storyBorderSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
            ),
            padding: const EdgeInsets.all(2.2),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(2.2),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: story.avatarUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, _) => Container(
                    color: AppColors.shimmerBase,
                  ),
                  errorWidget: (context, _, __) => Container(
                    color: AppColors.shimmerBase,
                    child: const Icon(Icons.person, color: AppColors.textSecondary),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            story.userName,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
