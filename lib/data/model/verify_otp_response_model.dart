class OtpVerificationResponse {
  final bool success;
  final String message;
  final UserData? data;

  OtpVerificationResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerificationResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class UserData {
  final User? user;

  UserData({this.user});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
    };
  }
}

class User {
  final int id;
  final String? name;
  final String? email;
  final String mobile;
  final String otp;
  final int otpStatus;
  final int status;
  final int  location_id;
  final String? deviceToken;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    this.name,
    this.email,
    required this.mobile,
    required this.otp,
    required this.location_id,
    required this.otpStatus,
    required this.status,
    this.deviceToken,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      otp: json['otp'],
      otpStatus: json['otp_status'],
      location_id: json['location_id'],
      updatedAt: json['updated_at'],
      status: json['status'],
      deviceToken: json['device_token'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'otp': otp,
      'location_id': location_id,
      'otp_status': otpStatus,
      'status': status,
      'device_token': deviceToken,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
