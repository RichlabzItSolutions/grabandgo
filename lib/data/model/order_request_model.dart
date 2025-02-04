class OrderRequest {
  final int orderId;
  final int userId;

  OrderRequest({
    required this.orderId,
    required this.userId,
  });

  factory OrderRequest.fromJson(Map<String, dynamic> json) {
    return OrderRequest(
      orderId: json['orderId'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
    };
  }
}
