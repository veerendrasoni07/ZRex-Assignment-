class PostModel {
  PostModel({
    required this.id,
    required this.userName,
    required this.userAvatarUrl,
    required this.imageUrls,
    required this.caption,
    required this.likeCount,
    this.isLiked = false,
    this.isSaved = false,
  });

  final String id;
  final String userName;
  final String userAvatarUrl;
  final List<String> imageUrls;
  final String caption;
  final int likeCount;
  final bool isLiked;
  final bool isSaved;

  PostModel copyWith({
    bool? isLiked,
    bool? isSaved,
    int? likeCount,
  }) {
    return PostModel(
      id: id,
      userName: userName,
      userAvatarUrl: userAvatarUrl,
      imageUrls: imageUrls,
      caption: caption,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
