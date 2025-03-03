import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/services/socket_service.dart';
import '/models/user.dart';

class UserController extends GetxController {
  List users = [];
  User user = User();
  GlobalKey<FormState> connectFormKey = GlobalKey<FormState>();

  connectToSocket(String host) {
    if (connectFormKey.currentState!.validate()) {
      Get.find<SocketService>().handleSocket(host);
    }
  }

  addUsers(data) {
    users.clear();
    for (var item in data) {
      User newUser = User.fromJson(item);
      if (newUser.username != user.username) {
        users.add(User.fromJson(item));
      }
      // users.add(User.fromJson(item));
    }
    update();
  }
}
