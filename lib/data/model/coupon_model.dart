// Model Class for Coupon
class CouponModel {
  final String code;
  final String description;
  final String validity;
  final bool isUnlocked;
  CouponModel({
    required this.code,
    required this.description,
    required this.validity,
    required this.isUnlocked,
  });
}

class CouponResponse {
  final bool success;
  final String message;
  final CouponData data;

  CouponResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) {
    return CouponResponse(
      success: json['success'],
      message: json['message'],
      data: CouponData.fromJson(json['data']),
    );
  }
}

class CouponData {
  final String discount;

  CouponData({required this.discount});

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      discount: json['discount'],
    );
  }
}
