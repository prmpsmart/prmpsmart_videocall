import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/user_controller.dart';
import 'routes/app_pages.dart';
import 'services/socket_service.dart';

void main() {
  Get.put(UserController());
  Get.put(SocketService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: AppPages.pages,
      initialRoute: AppPages.INITIAL_ROUTE,
    );
  }
}
