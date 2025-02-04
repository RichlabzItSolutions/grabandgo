class RemoveCartItemRequest {
  final int userId;
  final String productId;
  final String variantId;

  // Constructor
  RemoveCartItemRequest({
    required this.userId,
    required this.productId,
    required this.variantId,
  });

  // Convert JSON to RemoveCartItemRequest object
  factory RemoveCartItemRequest.fromJson(Map<String, dynamic> json) {
    return RemoveCartItemRequest(
      userId: json['userId'],
      productId: json['productId'],
      variantId: json['variantId'],
    );
  }

  // Convert RemoveCartItemRequest object to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'productId': productId,
      'variantId': variantId,
    };
  }
}
