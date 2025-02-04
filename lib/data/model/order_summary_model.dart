class OrderSummary {
  final int orderId;
  final int addressId;
  final String orderRefNumber;
  final String orderDate;
  final String totalAmount;
  final String gst;
  final String discount;
  final double finalAmount;
  final String shippingCharges;
  final double payableAmount;
  final int paymentStatus;
  final int paymentMode;
  final String? paymentRefNumber;
  final String ipAddress;
  final int orderStatus;
  final String? cancelledReason;
  final List<CartItem> cartItems;
  final AddressDetails addressDetails;

  OrderSummary({
    required this.orderId,
    required this.addressId,
    required this.orderRefNumber,
    required this.orderDate,
    required this.totalAmount,
    required this.gst,
    required this.discount,
    required this.finalAmount,
    required this.shippingCharges,
    required this.payableAmount,
    required this.paymentStatus,
    required this.paymentMode,
    this.paymentRefNumber,
    required this.ipAddress,
    required this.orderStatus,
    this.cancelledReason,
    required this.cartItems,
    required this.addressDetails,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    var data = json['data']; // The actual data object
    print("Data: $data"); // Log the response

    var list = data['cartItems'] as List?; // Safely handle null cartItems
    print("Cart Items: $list"); // Log cartItems for further debugging

    List<CartItem> cartItemsList = list?.map((i) => CartItem.fromJson(i))
        .toList() ?? [];

    return OrderSummary(
      orderId: data['orderId'] ?? 0,
      addressId: data['addressId'] ?? 0,
      orderRefNumber: data['orderRefNumber'] ?? '',
      orderDate: data['orderDate'] ?? '',
      totalAmount: data['totalAmount'] ?? '',
      gst: data['gst'] ?? '',
      discount: data['discount'] ?? '',
      finalAmount: data['finalAmount']?.toDouble() ?? 0.0,
      shippingCharges: data['shippingCharges'] ?? '',
      payableAmount: data['payableAmount']?.toDouble() ?? 0.0,
      paymentStatus: data['paymentStatus'] ?? 0,
      paymentMode: data['paymentMode'] ?? 0,
      paymentRefNumber: data['paymentRefNumber'],
      ipAddress: data['ipAddress'] ?? '',
      orderStatus: data['orderStatus'] ?? 0,
      cancelledReason: data['cancelledReason'],
      cartItems: cartItemsList,
      addressDetails: AddressDetails.fromJson(data['addressDetails'] ?? {}),
    );
  }
}

  class CartItem {
  final int cartId;
  final String productTitle;
  final String sku;
  final String sizeOrUOM;
  final String? color;
  final int quantity;
  final String unitPrice;
  final String gstPercentage;
  final String totalAmount;
  final String couponTitle;
  final int cartStatus;
  final String? cancelledReason;
  final String mainImage;

  CartItem({
    required this.cartId,
    required this.productTitle,
    required this.sku,
    required this.sizeOrUOM,
    this.color,
    required this.quantity,
    required this.unitPrice,
    required this.gstPercentage,
    required this.totalAmount,
    required this.couponTitle,
    required this.cartStatus,
    this.cancelledReason,
    required this.mainImage,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartId: json['cartId'] ?? 0, // Default value if null
      productTitle: json['productTitle'] ?? '', // Default empty string
      sku: json['sku'] ?? '',
      sizeOrUOM: json['sizeOrUOM'] ?? '',
      color: json['color'], // Nullable
      quantity: json['quantity'] ?? 0,
      unitPrice: json['unitPrice'] ?? '',
      gstPercentage: json['gstPercentage'] ?? '',
      totalAmount: json['totalAmount'] ?? '',
      couponTitle: json['couponTitle'] ?? '',
      cartStatus: json['cartStatus'] ?? 0,
      cancelledReason: json['cancelledReason'], // Nullable
      mainImage: json['mainImage'] ?? '',
    );
  }
}

class AddressDetails {
  final String name;
  final String mobile;
  final String address;
  final String city;
  final String area;
  final String? landmark;
  final double? latitude;
  final double? longitude;
  final String addressType;

  AddressDetails({
    required this.name,
    required this.mobile,
    required this.address,
    required this.city,
    required this.area,
    this.landmark,
    this.latitude,
    this.longitude,
    required this.addressType,
  });

  factory AddressDetails.fromJson(Map<String, dynamic> json) {
    return AddressDetails(
      name: json['name'] ?? '', // Default empty string
      mobile: json['mobile'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      area: json['area'] ?? '',
      landmark: json['landmark'], // Nullable
      latitude: json['latitude'] != null ? json['latitude'].toDouble() : null, // Safe conversion
      longitude: json['longitude'] != null ? json['longitude'].toDouble() : null, // Safe conversion
      addressType: json['addressType'] ?? '', // Default empty string
    );
  }
}
