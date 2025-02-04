class MinAmountResponse {
  final bool success;
  final String message;
  final MinAmountData data;

  MinAmountResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  // Factory constructor to parse JSON
  factory MinAmountResponse.fromJson(Map<String, dynamic> json) {
    return MinAmountResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: MinAmountData.fromJson(json['data'] ?? {}),
    );
  }

  // Method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class MinAmountData {
  final MinAmount minAmount;

  MinAmountData({
    required this.minAmount,
  });

  // Factory constructor to parse JSON
  factory MinAmountData.fromJson(Map<String, dynamic> json) {
    return MinAmountData(
      minAmount: MinAmount.fromJson(json['minAmount'] ?? {}),
    );
  }

  // Method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'minAmount': minAmount.toJson(),
    };
  }
}

class MinAmount {
  final int id;
  final double minAmount;

  MinAmount({
    required this.id,
    required this.minAmount,
  });

  // Factory constructor to parse JSON
  factory MinAmount.fromJson(Map<String, dynamic> json) {
    return MinAmount(
      id: json['id'] ?? 0,
      minAmount: (json['minAmount'] ?? 0).toDouble(),
    );
  }

  // Method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'minAmount': minAmount,
    };
  }
}
