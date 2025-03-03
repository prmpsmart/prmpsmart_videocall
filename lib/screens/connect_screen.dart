import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/controllers/user_controller.dart';

class ConnectScreen extends GetView<UserController> {
  ConnectScreen({super.key});

  final usernameController = TextEditingController(text: 'prmpsmart');
  final nameController = TextEditingController(text: 'Miracle');
  final surnameController = TextEditingController(text: 'Apata');
  final hostController = TextEditingController(text: "http://10.0.2.2:3000");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf2f2f2),
      appBar: AppBar(
        leading: const Center(
          child: Text(
            'PRMPSmart Video Call',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        leadingWidth: double.infinity,
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Form(
          key: controller.connectFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: usernameController,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Can not blank";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Username",
                  labelStyle: TextStyle(color: Colors.red),
                  prefixIcon: Icon(
                    Icons.personal_video,
                    color: Colors.red,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  hintText: "Username",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Can not blank";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.red),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.red,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  hintText: "Name",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: surnameController,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Can not blank";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Surname",
                    labelStyle: TextStyle(color: Colors.red),
                    prefixIcon: Icon(
                      Icons.people,
                      color: Colors.red,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    hintText: "Surname"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: hostController,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Can not blank";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Host",
                    labelStyle: TextStyle(color: Colors.red),
                    prefixIcon: Icon(
                      Icons.link,
                      color: Colors.red,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    hintText: "http://10.0.2.2:3000"),
              ),
              const SizedBox(height: 30),
              Container(
                width: Get.width,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: MaterialButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  onPressed: () {
                    controller.user.username = usernameController.text;
                    controller.user.surname = surnameController.text;
                    controller.user.name = nameController.text;

                    controller.connectToSocket(hostController.text);
                  },
                  child: const Text(
                    'Connect',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
