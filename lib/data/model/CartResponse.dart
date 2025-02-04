class CartResponse {
  final bool success;
  final String message;
  final CartData data;

  CartResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: CartData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class CartData {
  final List<CartItem> cartItems;
  final int totalItems;
  final double totalCartAmount;
  final double gst;
  final double totalDeliveryCharges;
  final double discount;
  final double finalAmount;

  CartData({
    required this.cartItems,
    required this.totalItems,
    required this.totalCartAmount,
    required this.gst,
    required this.totalDeliveryCharges,
    required this.discount,
    required this.finalAmount,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      cartItems: (json['cartItems'] as List)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalItems: json['totalItems'] as int,
      totalCartAmount: (json['totalCartAmount'] as num).toDouble(),
      gst: (json['gst'] as num).toDouble(),
      totalDeliveryCharges: (json['totalDeliveryCharges'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      finalAmount: (json['finalAmount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartItems': cartItems.map((item) => item.toJson()).toList(),
      'totalItems': totalItems,
      'totalCartAmount': totalCartAmount,
      'gst': gst,
      'totalDeliveryCharges': totalDeliveryCharges,
      'discount': discount,
      'finalAmount': finalAmount,
    };
  }
}

class CartItem {
  final int productId;
  final int variantId;
  final String mainImageUrl;
  final String productTitle;
  final String sku;
  final String? colour; // Nullable
  final String? size; // Nullable
  int quantity;
  double unitPrice; // Changed to double
  double totalAmount;
  double gstPercentage;
  double gstAmount;
  double shippingCharges;
  final String? couponTitle; // Nullable
  final String createdOn;
  double mrp; // Changed to double

  CartItem({
    required this.productId,
    required this.variantId,
    required this.mainImageUrl,
    required this.productTitle,
    required this.sku,
    this.colour,
    this.size,
    required this.quantity,
    required this.unitPrice,
    required this.mrp,
    required this.totalAmount,
    required this.gstPercentage,
    required this.gstAmount,
    required this.shippingCharges,
    this.couponTitle,
    required this.createdOn,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] as int,
      variantId: json['variantId'] as int,
      mainImageUrl: json['mainImageUrl'] as String,
      productTitle: json['productTitle'] as String,
      sku: json['sku'] as String,
      colour: json['colour'] as String?,
      size: json['size'] as String?,
      quantity: (json['quantity'] is int)
          ? json['quantity'] as int
          : int.tryParse(json['quantity'].toString()) ?? 0,
      unitPrice: (json['unitPrice'] is double)
          ? json['unitPrice'] as double
          : double.tryParse(json['unitPrice'].toString()) ?? 0.0,
      mrp: (json['mrp'] is double)
          ? json['mrp'] as double
          : double.tryParse(json['mrp'].toString()) ?? 0.0,
      totalAmount: (json['totalAmount'] is double)
          ? json['totalAmount'] as double
          : double.tryParse(json['totalAmount'].toString()) ?? 0.0,
      gstPercentage: (json['gstPercentage'] is double)
          ? json['gstPercentage'] as double
          : double.tryParse(json['gstPercentage'].toString()) ?? 0.0,
      gstAmount: (json['gstAmount'] is double)
          ? json['gstAmount'] as double
          : double.tryParse(json['gstAmount'].toString()) ?? 0.0,
      shippingCharges: (json['shippingCharges'] is double)
          ? json['shippingCharges'] as double
          : double.tryParse(json['shippingCharges'].toString()) ?? 0.0,
      couponTitle: json['couponTitle'] as String?,
      createdOn: json['createdOn'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'variantId': variantId,
      'mainImageUrl': mainImageUrl,
      'productTitle': productTitle,
      'sku': sku,
      'colour': colour,
      'size': size,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalAmount': totalAmount,
      'gstPercentage': gstPercentage,
      'gstAmount': gstAmount,
      'shippingCharges': shippingCharges,
      'couponTitle': couponTitle,
      'createdOn': createdOn,
      'mrp': mrp, // Added mrp to JSON conversion
    };
  }
}
