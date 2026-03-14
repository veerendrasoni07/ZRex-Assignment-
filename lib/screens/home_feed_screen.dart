import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../providers/post_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/shimmer_post.dart';
import '../widgets/shimmer_story.dart';
import '../widgets/story_avatar.dart';

class HomeFeedScreen extends ConsumerStatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  ConsumerState<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends ConsumerState<HomeFeedScreen> {
  late final ScrollController _scrollController;
  double _scrollThreshold = 1200;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = ref.read(postFeedProvider);

    // Trigger pagination when we are about two posts away from the end.
    if (_scrollController.position.extentAfter < _scrollThreshold &&
        !state.isLoadingMore &&
        !state.isInitialLoading) {
      ref.read(postFeedProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    _scrollThreshold = MediaQuery.of(context).size.height * 2;
    final postState = ref.watch(postFeedProvider);
    final storiesAsync = ref.watch(storiesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),
            const Divider(height: 1, color: AppColors.border),
            SizedBox(
              height: 110,
              child: storiesAsync.when(
                data: (stories) {
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.pageHorizontalPadding,
                      vertical: 8,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => StoryAvatar(story: stories[index]),
                    separatorBuilder: (context, index) => const SizedBox(width: AppSizes.storySpacing),
                    itemCount: stories.length,
                  );
                },
                loading: () {
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.pageHorizontalPadding,
                      vertical: 8,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => const ShimmerStory(),
                    separatorBuilder: (context, index) => const SizedBox(width: AppSizes.storySpacing),
                    itemCount: 8,
                  );
                },
                error: (error, _) => Center(
                  child: Text(
                    'Failed to load stories',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: postState.isInitialLoading && postState.posts.isEmpty
                  ? ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) => const ShimmerPost(),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: postState.posts.length + (postState.isLoadingMore ? 2 : 0),
                      itemBuilder: (context, index) {
                        if (index >= postState.posts.length) {
                          return const ShimmerPost();
                        }
                        final post = postState.posts[index];
                        return PostCard(
                          post: post,
                          onToggleLike: (postId) => ref.read(postFeedProvider.notifier).toggleLike(postId),
                          onToggleSave: (postId) => ref.read(postFeedProvider.notifier).toggleSave(postId),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Text(
            'Instagram',
            style: GoogleFonts.grandHotel(
              fontSize: 34,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border, color: AppColors.iconPrimary),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send_outlined, color: AppColors.iconPrimary),
          ),
        ],
      ),
    );
  }
}
