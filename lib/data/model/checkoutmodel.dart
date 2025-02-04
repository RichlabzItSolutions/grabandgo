

class CheckoutResponse {
  final bool success;
  final String message;
  final List<CartItem> cartItems;

  CheckoutResponse({
    required this.success,
    required this.message,
    required this.cartItems,
  });

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      success: json['success'],
      message: json['message'],
      cartItems: (json['data']['cartItems'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }
}

class CartItem {
  final int productId;
  final int variantId;
  final String productTitle;
  final String sku;
  final String? colour;
  final String size;
  final int quantity;
  final String unitPrice;
  final String totalAmount;
  final String gstPercentage;
  final int appliedCouponId;
  final String couponTitle;
  final String createdOn;

  CartItem({
    required this.productId,
    required this.variantId,
    required this.productTitle,
    required this.sku,
    this.colour,
    required this.size,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
    required this.gstPercentage,
    required this.appliedCouponId,
    required this.couponTitle,
    required this.createdOn,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      variantId: json['variantId'],
      productTitle: json['productTitle'],
      sku: json['sku'],
      colour: json['colour'],
      size: json['size'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'],
      totalAmount: json['totalAmount'],
      gstPercentage: json['gstPercentage'],
      appliedCouponId: json['appliedCouponId'],
      couponTitle: json['couponTitle'],
      createdOn: json['createdOn'],
    );
  }
}

