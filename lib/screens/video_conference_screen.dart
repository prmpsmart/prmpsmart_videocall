import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

import '/services/socket_service.dart';
import '/controllers/video_conference_controller.dart';

class VideoConferenceScreen extends GetView<VideoConferenceController> {
  const VideoConferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoConferenceController>(
      builder: (_) => Stack(
        children: [
          Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBar: buildAppBar(),
            floatingActionButton: controller.call!.isVideoCall!
                ? buildVideoCallControlButtons()
                : buildAudioCallControlButtons(),
            body: buildVideoRenderers(),
          ),
          buildCallingScreen()
        ],
      ),
    );
  }

  Visibility buildCallingScreen() {
    return Visibility(
      visible: controller.isOffer
          ? controller.connectionState !=
              RTCPeerConnectionState.RTCPeerConnectionStateConnected
          : false,
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: Column(
            children: [
              Container(
                width: Get.width,
                color: Colors.red,
                padding: const EdgeInsets.only(top: kToolbarHeight, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.white,
                      child: Text(
                        "${controller.user!.name![0].toUpperCase()}${controller.user!.surname![0].toUpperCase()}",
                        style: const TextStyle(color: Colors.red, fontSize: 50),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${controller.user!.name!} ${controller.user!.surname!}",
                      style: const TextStyle(fontSize: 25, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      controller.user!.username!,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      controller.call!.isVideoCall!
                          ? "Outgoing Video Call"
                          : "Outgoing Audio Call",
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 50),
                  color: Colors.grey.shade900,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        backgroundColor: Colors.red,
                        child: const Icon(
                          Icons.call_end,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          controller.socketService.hangupCall(controller.call!);
                          controller.hangUp();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildVideoCallControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          heroTag: "switch-camera",
          backgroundColor: controller.mediaDevices.length > 1
              ? Colors.grey.shade800
              : Colors.grey.shade400,
          onPressed: controller.mediaDevices.length > 1
              ? controller.switchCamera
              : null,
          child: const Icon(
            Icons.switch_camera,
            color: Colors.white,
          ),
        ),
        FloatingActionButton(
          heroTag: "hangup",
          backgroundColor: Colors.red,
          onPressed: () {
            if (controller.call != null) {
              Get.find<SocketService>().hangupCall(controller.call!);
            }
            controller.hangUp();
          },
          child: const Icon(
            Icons.call_end,
            color: Colors.white,
          ),
        ),
        FloatingActionButton(
          heroTag: "mute",
          backgroundColor:
              controller.isMuted ? Colors.white : Colors.grey.shade800,
          onPressed: controller.muteMicrophone,
          child: controller.isMuted
              ? Icon(
                  Icons.mic,
                  color: Colors.grey.shade800,
                )
              : const Icon(
                  Icons.mic_off,
                  color: Colors.white,
                ),
        ),
      ],
    );
  }

  Column buildAudioCallControlButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: "mute",
          backgroundColor:
              controller.isMuted ? Colors.white : Colors.grey.shade800,
          onPressed: controller.muteMicrophone,
          child: controller.isMuted
              ? Icon(
                  Icons.mic,
                  color: Colors.grey.shade800,
                )
              : const Icon(
                  Icons.mic_off,
                  color: Colors.white,
                ),
        ),
        const SizedBox(height: 15),
        FloatingActionButton(
          heroTag: "hangup",
          backgroundColor: Colors.red,
          onPressed: () {
            if (controller.call != null) {
              Get.find<SocketService>().hangupCall(controller.call!);
            }
            controller.hangUp();
          },
          child: const Icon(
            Icons.call_end,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Stack buildVideoRenderers() {
    return Stack(
      children: [
        SizedBox(
          width: Get.width,
          height: Get.height,
          child: controller.connectionState ==
                  RTCPeerConnectionState.RTCPeerConnectionStateConnected
              ? RTCVideoView(
                  controller.remoteRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                )
              : RTCVideoView(
                  controller.localRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  mirror: controller.isFrontCamera ? true : false,
                ),
        ),
        Visibility(
          visible: !controller.call!.isVideoCall!,
          child: SizedBox(
            width: Get.width,
            height: Get.height,
            child: const Center(
              child: Icon(
                Icons.volume_up,
                color: Colors.white,
                size: 100,
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: SizedBox(
            width: 125,
            height: 187.5,
            child: Stack(
              children: [
                RTCVideoView(
                  controller.localRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  mirror: controller.isFrontCamera ? true : false,
                ),
                Visibility(
                  visible: controller.connectionState !=
                      RTCPeerConnectionState.RTCPeerConnectionStateConnected,
                  child: Container(
                    width: 125,
                    height: 187.5,
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leadingWidth: 0.0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Text(
              "${controller.user!.name![0]}${controller.user!.surname![0]}",
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "${controller.user!.name!} ${controller.user!.surname!}",
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
      backgroundColor: Colors.red,
    );
  }
}
