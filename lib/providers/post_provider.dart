import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post_model.dart';
import '../models/story_model.dart';
import '../services/post_repository.dart';

// Riverpod keeps state logic out of widgets, which makes the codebase
// easier to test, explain, and scale in an interview setting.
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

final postFeedProvider = StateNotifierProvider<PostFeedNotifier, PostFeedState>((ref) {
  final repository = ref.read(postRepositoryProvider);
  return PostFeedNotifier(repository: repository);
});

final storiesProvider = FutureProvider<List<StoryModel>>((ref) async {
  final repository = ref.read(postRepositoryProvider);
  return repository.fetchStories();
});

class PostFeedState {
  PostFeedState({
    required this.posts,
    required this.isInitialLoading,
    required this.isLoadingMore,
    required this.page,
    this.errorMessage,
  });

  final List<PostModel> posts;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final int page;
  final String? errorMessage;

  PostFeedState copyWith({
    List<PostModel>? posts,
    bool? isInitialLoading,
    bool? isLoadingMore,
    int? page,
    String? errorMessage,
  }) {
    return PostFeedState(
      posts: posts ?? this.posts,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      page: page ?? this.page,
      errorMessage: errorMessage,
    );
  }

  factory PostFeedState.initial() {
    return PostFeedState(
      posts: <PostModel>[],
      isInitialLoading: true,
      isLoadingMore: false,
      page: 0,
    );
  }
}

class PostFeedNotifier extends StateNotifier<PostFeedState> {
  PostFeedNotifier({required PostRepository repository})
      : _repository = repository,
        super(PostFeedState.initial()) {
    loadInitial();
  }

  final PostRepository _repository;

  Future<void> loadInitial() async {
    state = state.copyWith(isInitialLoading: true, errorMessage: null, page: 0);
    try {
      final posts = await _repository.fetchPosts(page: 0, limit: 10);
      state = state.copyWith(
        posts: posts,
        isInitialLoading: false,
        page: 0,
      );
    } catch (error) {
      state = state.copyWith(
        isInitialLoading: false,
        errorMessage: 'Failed to load feed',
      );
    }
  }

  // Pagination works by requesting the next page when the UI is
  // close to the end of the list. New posts are appended to the feed.
  Future<void> loadMore() async {
    if (state.isLoadingMore || state.isInitialLoading) {
      return;
    }

    state = state.copyWith(isLoadingMore: true, errorMessage: null);
    final int nextPage = state.page + 1;

    try {
      final posts = await _repository.fetchPosts(page: nextPage, limit: 10);
      final combined = List<PostModel>.from(state.posts)..addAll(posts);
      state = state.copyWith(
        posts: combined,
        isLoadingMore: false,
        page: nextPage,
      );
    } catch (error) {
      state = state.copyWith(isLoadingMore: false, errorMessage: 'Failed to load more');
    }
  }

  void toggleLike(String postId) {
    final updated = state.posts.map((post) {
      if (post.id != postId) {
        return post;
      }
      final bool newLiked = !post.isLiked;
      final int newCount = post.likeCount + (newLiked ? 1 : -1);
      return post.copyWith(isLiked: newLiked, likeCount: newCount);
    }).toList();

    state = state.copyWith(posts: updated);
  }

  void toggleSave(String postId) {
    final updated = state.posts.map((post) {
      if (post.id != postId) {
        return post;
      }
      return post.copyWith(isSaved: !post.isSaved);
    }).toList();

    state = state.copyWith(posts: updated);
  }
}
