import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/controllers/user_controller.dart';
import '/models/call.dart';
import '/models/user.dart';
import '/routes/app_routes.dart';

class UsersScreen extends GetView<UserController> {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf2f2f2),
      appBar: AppBar(
        leading: const Center(
          child: Text(
            'Video Call',
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.start,
          ),
        ),
        leadingWidth: double.infinity,
        backgroundColor: Colors.red,
      ),
      body: GetBuilder<UserController>(
        builder: (_) => controller.users.isEmpty
            ? Center(
                child: Text(
                  "No users found",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade500,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: controller.users.length,
                itemBuilder: (context, index) {
                  User user = controller.users[index];
                  return Container(
                    width: Get.width,
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 27.5,
                          backgroundColor: Colors.red,
                          child: Text(
                            "${user.name![0]}${user.surname![0]}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 25),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "${user.name!} ${user.surname!}",
                          style: const TextStyle(fontSize: 20),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.VIDEO, arguments: {
                                "is_offer": true,
                                "call": Call(
                                  to: controller.users[index],
                                  from: controller.user,
                                  isVideoCall: false,
                                ),
                              });
                            },
                            icon: const Icon(Icons.call)),
                        IconButton(
                            onPressed: () {
                              Get.toNamed(
                                AppRoutes.VIDEO,
                                arguments: {
                                  "is_offer": true,
                                  "call": Call(
                                    to: controller.users[index],
                                    from: controller.user,
                                    isVideoCall: true,
                                  ),
                                },
                              );
                            },
                            icon: const Icon(Icons.video_call)),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
