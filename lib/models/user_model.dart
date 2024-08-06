class UserModel {
  final String userName;
  final String userEmail;
  final String userImage;
  final String userUid;
  final String role;
  UserModel({
    required this.userEmail,
    required this.userImage,
    required this.userName,
    required this.userUid,
    required this.role,
  });
}