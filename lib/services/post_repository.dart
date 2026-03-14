import 'dart:async';
import 'dart:math';

import '../models/post_model.dart';
import '../models/story_model.dart';

class PostRepository {
  PostRepository({Random? random}) : _random = random ?? Random();

  final Random _random;

  // This repository simulates an API call with a delay
  // so the UI can demonstrate loading states like shimmer.
  Future<List<PostModel>> fetchPosts({required int page, int limit = 10}) async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    final int seedBase = page * 1000;

    return List<PostModel>.generate(limit, (int index) {
      final int seed = seedBase + index;
      final int imageCount = 1 + _random.nextInt(3);
      final List<String> images = List<String>.generate(imageCount, (int imgIndex) {
        final int imgSeed = seed + imgIndex * 7;
        return 'https://picsum.photos/seed/post_$imgSeed/900/900';
      });

      final int avatarId = (seed % 70) + 1;

      return PostModel(
        id: 'post_$seed',
        userName: 'user_${seed % 100}',
        userAvatarUrl: 'https://i.pravatar.cc/150?img=$avatarId',
        imageUrls: images,
        caption: 'Exploring the city vibes and sunshine #travel #life',
        likeCount: 120 + _random.nextInt(980),
      );
    });
  }

  Future<List<StoryModel>> fetchStories() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    return List<StoryModel>.generate(12, (int index) {
      final int avatarId = (index % 70) + 1;
      return StoryModel(
        id: 'story_$index',
        userName: 'story_${index + 1}',
        avatarUrl: 'https://i.pravatar.cc/150?img=$avatarId',
        isSeen: index % 4 == 0,
      );
    });
  }
}
