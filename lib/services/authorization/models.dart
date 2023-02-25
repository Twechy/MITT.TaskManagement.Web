class SigninDto {
  SigninDto({
    required this.phone,
    required this.pin,
  });

  final String phone;
  final String pin;

  factory SigninDto.fromJson(Map<String, dynamic> json) => SigninDto(
        phone: json["phone"],
        pin: json["pin"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "pin": pin,
      };
}

class JwtResponse {
  JwtResponse({
    required this.content,
    required this.type,
    required this.messages,
    required this.traceId,
  });

  final Content content;
  final int type;
  final List<dynamic> messages;
  final dynamic traceId;

  factory JwtResponse.fromJson(Map<String, dynamic> json) => JwtResponse(
        content: Content.fromJson(json["content"]),
        type: json["type"],
        messages: List<dynamic>.from(json["messages"].map((x) => x)),
        traceId: json["traceId"],
      );

  Map<String, dynamic> toJson() => {
        "content": content.toJson(),
        "type": type,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "traceId": traceId,
      };
}

class Content {
  Content({
    required this.validTo,
    required this.refreshToken,
    required this.systemIdentity,
    required this.creds,
    required this.tag,
    required this.value,
  });

  final DateTime validTo;
  final dynamic refreshToken;
  final String systemIdentity;
  final int creds;
  final int tag;
  final String value;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        validTo: DateTime.parse(json["validTo"]),
        refreshToken: json["refreshToken"],
        systemIdentity: json["systemIdentity"],
        creds: json["creds"],
        tag: json["tag"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "validTo": validTo.toIso8601String(),
        "refreshToken": refreshToken,
        "systemIdentity": systemIdentity,
        "creds": creds,
        "tag": tag,
        "value": value,
      };
}

class ChangePinDto {
  ChangePinDto({
    required this.phone,
    required this.pin,
    required this.newPin,
  });

  final String phone;
  final String pin;
  final String newPin;

  factory ChangePinDto.fromJson(Map<String, dynamic> json) => ChangePinDto(
        phone: json["phone"],
        pin: json["pin"],
        newPin: json["newPin"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "pin": pin,
        "newPin": newPin,
      };
}
