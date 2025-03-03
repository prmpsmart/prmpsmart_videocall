import 'package:get/get.dart';

import '/controllers/video_conference_controller.dart';

class VideoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VideoConferenceController());
  }
}
