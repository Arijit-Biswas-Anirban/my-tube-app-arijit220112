class UserModel {
  final String displayName;
  final String userName;
  final String email;
  final String profilePic;
  final String subscriptions;
  final String videos;
  final String userId;
  final String description;
  final String type;

  UserModel(
  {
      required this.displayName,
      required this.userName,
      required this.email,
      required this.profilePic,
      required this.subscriptions,
      required this.videos,
      required this.userId,
      required this.description,
      required this.type
  }
  );
}
