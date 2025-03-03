import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '/controllers/user_controller.dart';
import '/controllers/video_conference_controller.dart';
import '/dialogs/answer_call_dialog.dart';
import '/models/call.dart';
import '/models/candidate.dart';
import '/routes/app_routes.dart';

typedef StreamStateCallback = void Function(MediaStream stream);

class SocketService extends GetxController {
  Socket? socket;
  UserController userController = Get.find();

  handleSocket(String host) {
    if (socket?.connected == true) {
      printInfo(info: 'Already connected');
      return;
    }

    printInfo(info: 'Trying to connect');

    if (socket == null) {
      socket = io(
        host,
        {
          'transports': ['websocket'],
          'autoConnect': false,
        },
      );

      socket!.onConnect((_) {
        printInfo(info: 'SOCKETT connected');
        socket!.emit('connectUser', userController.user.toJson());
      });

      socket!.on('username-already-exist', (data) {
        socket!.disconnect();
        Get.snackbar("Error", "Username already exist");
      });

      socket!.on('user-registered', (data) {
        Get.offNamed(AppRoutes.USERS);
      });

      socket!.onDisconnect((_) {
        printInfo(info: 'SOCKETT disconnect');
      });

      // Listen for online users
      socket!.on('users', (data) {
        printInfo(info: 'SOCKETT Users $data');
        userController.addUsers(data);
      });

      // Handle Receive Call
      socket!.on('call-made', (data) async {
        printInfo(info: 'SOCKETT CALL MADE $data');
        Call call = Call.fromJson(data);
        if (call.sdp != null) {
          Get.dialog(
            AnswerCallDialog(call: call),
            // barrierDismissible: true,
          );
        }
      });

      // Handle Answer
      socket!.on('answer-made', (data) async {
        printInfo(info: 'SOCKETT ANSWER MADE $data');
        if (Get.isRegistered<VideoConferenceController>()) {
          Get.find<VideoConferenceController>()
              .handleAnswer(Call.fromJson(data).sdp!);
        }
      });

      // Handle Ice Candidate
      socket!.on('ice-candidate', (data) async {
        printInfo(info: 'SOCKETT Ice candidate $data');
        if (Get.isRegistered<VideoConferenceController>()) {
          Get.find<VideoConferenceController>()
              .handleNewIceCandidates(CandidateModel.fromJson(data));
        }
      });

      // Listen for hangup
      socket!.on('hangup', (data) async {
        printInfo(info: 'SOCKETT Hangup $data');
        if (Get.isRegistered<VideoConferenceController>()) {
          Get.find<VideoConferenceController>()
              .hangUp(snackbarMessage: "User closed call");
        }

        if (Get.isDialogOpen!) {
          Get.back();
        }
      });

      // Listen for busy
      socket!.on('busy', (data) async {
        printInfo(info: 'SOCKETT busy $data');
        if (Get.isRegistered<VideoConferenceController>()) {
          Get.find<VideoConferenceController>()
              .hangUp(snackbarMessage: "User is busy");
        }

        if (Get.isDialogOpen!) {
          Get.back();
        }
      });
    } else {
      socket!.emitWithAck('connectUser', userController.user.toJson());
      print('emitted');
    }

    socket!.connect();
  }

  // Call a user
  callSocketUser(Call call) {
    socket!.emit('call-user', call.toJson());
  }

  // Answer call
  makeAnswer(Call call) {
    socket!.emit('make-answer', call.toJson());
  }

  // Send Ice Candidate
  sendIceCandidate(CandidateModel candidate) {
    socket!.emit('ice-candidate', candidate.toJson());
  }

  // Close call
  hangupCall(Call call) {
    socket!.emit('hangup', call.toJson());
  }

  // Get busy
  busyCall(Call call) {
    socket!.emit('busy', call.toJson());
  }
}
