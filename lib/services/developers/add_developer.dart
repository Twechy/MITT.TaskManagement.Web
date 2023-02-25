class DeveloperDto {
  DeveloperDto({
    required this.id,
    required this.fullName,
    required this.nickName,
    required this.type,
    required this.email,
    required this.phone,
  });

  final String? id;
  final String fullName;
  final String nickName;
  final int type;
  final String email;
  final String phone;

  factory DeveloperDto.fromJson(Map<String, dynamic> json) => DeveloperDto(
        id: json["id"],
        fullName: json["fullName"],
        nickName: json["nickName"],
        type: json["type"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "nickName": nickName,
        "type": type,
        "email": email,
        "phone": phone,
      };
}
