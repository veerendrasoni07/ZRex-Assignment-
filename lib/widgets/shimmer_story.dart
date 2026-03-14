import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

class ShimmerStory extends StatelessWidget {
  const ShimmerStory({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.storyBorderSize,
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.shimmerBase,
            highlightColor: AppColors.shimmerHighlight,
            child: Container(
              width: AppSizes.storyBorderSize,
              height: AppSizes.storyBorderSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.shimmerBase,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Shimmer.fromColors(
            baseColor: AppColors.shimmerBase,
            highlightColor: AppColors.shimmerHighlight,
            child: Container(
              width: 56,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
