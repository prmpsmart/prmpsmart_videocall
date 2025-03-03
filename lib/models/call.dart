import '/models/sdp_model.dart';
import '/models/user.dart';

class Call {
  Call({
    this.to,
    this.from,
    this.sdp,
    this.isVideoCall,
  });

  User? to;
  User? from;
  SdpModel? sdp;
  bool? isVideoCall;

  factory Call.fromJson(Map<String, dynamic> json) => Call(
        to: User.fromJson(json["to"]),
        from: User.fromJson(json["from"]),
        sdp: SdpModel.fromJson(json["sdp"]),
        isVideoCall: json["isVideoCall"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "to": to!.toJson(),
        "from": from!.toJson(),
        "sdp": sdp!.toJson(),
        "isVideoCall": isVideoCall,
      };
}
