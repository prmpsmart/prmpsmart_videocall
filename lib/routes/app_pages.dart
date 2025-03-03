import 'package:get/get.dart';

import '/bindings/video_binding.dart';
import '../screens/connect_screen.dart';
import '/screens/users_screen.dart';
import '/screens/video_conference_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL_ROUTE = AppRoutes.CONNECT;
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.CONNECT,
      page: () => ConnectScreen(),
    ),
    GetPage(
      name: AppRoutes.USERS,
      page: () => const UsersScreen(),
    ),
    GetPage(
      name: AppRoutes.VIDEO,
      page: () => const VideoConferenceScreen(),
      binding: VideoBinding(),
    ),
  ];
}
