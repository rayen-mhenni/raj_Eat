import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:raj_eat/models/user_model.dart';


class UserProvider with ChangeNotifier {
  UserModel? currentData;
  void addUserData({
    required  User currentUser,
    required String userName,
    required String userImage,
    required String userEmail,
    required String role,
  }) async {
    await FirebaseFirestore.instance
        .collection("usersData")
        .doc(currentUser.uid)
        .set(
      {
        "userName": userName,
        "userEmail": userEmail,
        "userImage": userImage,
        "userUid": currentUser.uid,
        "role": role,
      },
    );
  }

  void getUserData() async {
    var value = await FirebaseFirestore.instance
        .collection("usersData")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (value.exists) {
      currentData = UserModel(
        userEmail: value.get("userEmail"),
        userImage: value.get("userImage"),
        userName: value.get("userName"),
        userUid: value.get("userUid"),
        role: value.get("role"),
      );
      notifyListeners();
    }
  }

  UserModel? get currentUserData {
    return currentData;
  }
}