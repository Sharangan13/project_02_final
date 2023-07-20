import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:project_02_final/authentication/models/user_model.dart';
import '../../repository/authendication_repository/authendication_repository.dart';
import '../../repository/user_repository/user_repository.dart';

class registerontroller extends GetxController {
  static registerontroller get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final username = TextEditingController();
  final phonenumber = TextEditingController();
  final userRepo = Get.put(UserRepository());

  Future<void> createUser(UserModel user) async {
    await userRepo.createUser(user);
  }

//Call these Functions from Design & they will do the logic

  void registerUser(String email, String password) {
    String? error = AuthenticationRepository.instance
        .createUserWithEmailAndPassword(email, password) as String?;

    if (error != null) {
      Get.showSnackbar(GetSnackBar(message: error.toString()));
    }
  }
}