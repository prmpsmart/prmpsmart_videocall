import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/services/socket_service.dart';
import '/models/call.dart';
import '/routes/app_routes.dart';

class AnswerCallDialog extends StatelessWidget {
  const AnswerCallDialog({super.key, required this.call});
  final Call call;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: Get.width,
              color: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.white,
                    child: Text(
                      "${call.from!.name![0].toUpperCase()}${call.from!.surname![0].toUpperCase()}",
                      style: const TextStyle(color: Colors.red, fontSize: 50),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${call.from!.name!} ${call.from!.surname!}",
                    style: const TextStyle(fontSize: 25, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    call.from!.username!,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    call.isVideoCall ?? true
                        ? "Incoming Video Call"
                        : "Incoming Audio Call",
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
                        Get.find<SocketService>().busyCall(call);
                        Get.back();
                      },
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.green,
                      child: const Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Get.back();
                        Get.toNamed(AppRoutes.VIDEO, arguments: {
                          "is_offer": false,
                          "call": call,
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
