class ProductView {
  final int productId;
  final String productTitle;
  final String brand;
  final String model;
  final String weight;
  final double sla;
  final String gstPercentage;
  final double deliveryCharges;
  final int minQtyPurchase;
  final int maxQtyPurchase;
  final String height;
  final String width;
  final String length;
  final String description;
  final int productStatus;
  final String createdOn;
  final int variantId;
  final String colorName;
  final String sizeName;
  final String sku;
  final String eanCode;
  final int stock;
  final double mrp;
  final double sellingPrice;
  final double minSellingPrice;
  final int status;
  final List<ImageData> images;
  final int addedToCart; // New property
  final int qty; // New property

  ProductView({
    required this.productId,
    required this.productTitle,
    required this.brand,
    required this.model,
    required this.weight,
    required this.sla,
    required this.gstPercentage,
    required this.deliveryCharges,
    required this.minQtyPurchase,
    required this.maxQtyPurchase,
    required this.height,
    required this.width,
    required this.length,
    required this.description,
    required this.productStatus,
    required this.createdOn,
    required this.variantId,
    required this.colorName,
    required this.sizeName,
    required this.sku,
    required this.eanCode,
    required this.stock,
    required this.mrp,
    required this.sellingPrice,
    required this.minSellingPrice,
    required this.status,
    required this.images,
    required this.addedToCart, // Add to constructor
    required this.qty, // Add to constructor
  });

  factory ProductView.fromJson(Map<String, dynamic> json) {
    var list = json['images'] as List?;
    List<ImageData> imagesList = list?.map((i) => ImageData.fromJson(i)).toList() ?? [];

    return ProductView(
      productId: json['productId'] ?? 0,
      productTitle: json['productTitle'] ?? 'Unknown Title',
      brand: json['brand'] ?? 'Unknown Brand',
      model: json['model'] ?? 'Unknown Model',
      weight: json['weight'] ?? 'Unknown Weight',
      sla: (json['sla'] ?? 0).toDouble(),
      gstPercentage: json['gstPercentage']?.toString() ?? '0',
      deliveryCharges: (json['deliveryCharges'] ?? 0).toDouble(),
      minQtyPurchase: json['minQtyPurchase'] ?? 1,
      maxQtyPurchase: json['maxQtyPurchase'] ?? 1,
      height: json['height'] ?? 'Unknown Height',
      width: json['width'] ?? 'Unknown Width',
      length: json['length'] ?? 'Unknown Length',
      description: json['description'] ?? 'No Description Available',
      productStatus: json['productStatus'] ?? 0,
      createdOn: json['createdOn'] ?? '',
      variantId: json['variantId'] ?? 0,
      colorName: json['colorName'] ?? 'No Color',
      sizeName: json['sizeName'] ?? 'No Size',
      sku: json['sku'] ?? 'No SKU',
      eanCode: json['eanCode'] ?? 'No EAN Code',
      stock: json['stock'] ?? 0,
      mrp: (json['mrp'] ?? 0).toDouble(),
      sellingPrice: (json['sellingPrice'] ?? 0).toDouble(),
      minSellingPrice: (json['minSellingPrice'] ?? 0).toDouble(),
      status: json['status'] ?? 0,
      images: imagesList,
      addedToCart: json['addedToCart'] ?? 0, // Parse addedToCart
      qty: json['qty'] ?? 0, // Parse qty
    );
  }
}

class ImageData {
  final String url;
  final bool isMainImage;

  ImageData({
    required this.url,
    required this.isMainImage,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      url: json['url'] ?? '',
      isMainImage: json['isMainImage'] == 1,
    );
  }
}
