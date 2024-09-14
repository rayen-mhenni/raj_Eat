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

  UserModel copyWith({
    String? userName,
    String? userEmail,
    String? userImage,
    String? userUid,
    String? role,
  }) {
    return UserModel(
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userImage: userImage ?? this.userImage,
      userUid: userUid ?? this.userUid,
      role: role ?? this.role,
    );
  }
}
