import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raj_eat/repository/firebase_auth_service.dart';


/*
class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();


  //TextField Controllers to get data from TextFields
  final email = TextEditingController();
  final password = TextEditingController();


  /// This func will be used to register user with [EMAIL] & [Password]
  void registerUser(String email, String password) {
    String? error = AuthenticationRepository.instance.createUserWithEmailAndPassword(email, password) as String?;
    if (error != null) {
      Get.showSnackbar(GetSnackBar(message: error.toString()));
    }
  }

}*/