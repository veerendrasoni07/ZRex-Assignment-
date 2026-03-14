class StoryModel {
  StoryModel({
    required this.id,
    required this.userName,
    required this.avatarUrl,
    this.isSeen = false,
  });

  final String id;
  final String userName;
  final String avatarUrl;
  final bool isSeen;
}
