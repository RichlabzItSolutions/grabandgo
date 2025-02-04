class ProductResponse {
  final bool success;
  final String message;
  final List<Product> products;

  ProductResponse({
    required this.success,
    required this.message,
    required this.products,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      success: json['success'],
      message: json['message'],
      products: (json['data']['products'] as List).map((p) => Product.fromJson(p)).toList(),
    );
  }
}

class Product {
  final int productId;
  final String productTitle;
  final int productStatus;
  final String createdOn;
  final List<Variant> variants;

  Product({
    required this.productId,
    required this.productTitle,
    required this.productStatus,
    required this.createdOn,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'] as int,
      productTitle: json['productTitle'] as String,
      productStatus: json['productStatus'] as int,
      createdOn: json['createdOn'] as String,
      variants: (json['variants'] as List)
          .map((variant) => Variant.fromJson(variant))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productTitle': productTitle,
      'productStatus': productStatus,
      'createdOn': createdOn,
      'variants': variants.map((variant) => variant.toJson()).toList(),
    };
  }
}

class Variant {
  final int variantId;
  final String colorName;
  final String sizeName;
  final int isMainVariant;
  final String sku;
  final String eanCode;
  final int stock;
  final double mrp; // Changed to double for decimal values like 54.2
  final double sellingPrice; // Changed to double for decimal values
  final double minSellingPrice; // Changed to double for decimal values
  final int status;
  final List<ImageModel> images;

  // New fields
  late final int addedToCart;  // Quantity added to cart (nullable)
  late final int qty;          // Quantity (nullable)

  Variant({
    required this.variantId,
    required this.colorName,
    required this.sizeName,
    required this.isMainVariant,
    required this.sku,
    required this.eanCode,
    required this.stock,
    required this.mrp,
    required this.sellingPrice,
    required this.minSellingPrice,
    required this.status,
    required this.images,
    this.addedToCart = 0, // Default to 0 if not provided
    this.qty = 0,         // Default to 0 if not provided
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      variantId: json['variantId'] as int,
      colorName: json['colorName'] as String? ?? '', // Default to empty string if null
      sizeName: json['sizeName'] as String? ?? '',  // Default to empty string if null
      isMainVariant: json['isMainVariant'] as int,
      sku: json['sku'] as String? ?? '', // Default to empty string if null
      eanCode: json['eanCode'] as String? ?? '', // Default to empty string if null
      stock: json['stock'] as int? ?? 0, // Default to 0 if null
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0, // Convert to double if needed
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? 0.0, // Convert to double if needed
      minSellingPrice: (json['minSellingPrice'] as num?)?.toDouble() ?? 0.0, // Convert to double if needed
      status: json['status'] as int? ?? 0, // Default to 0 if null
      images: (json['images'] as List?)?.map((image) => ImageModel.fromJson(image)).toList() ?? [],
      addedToCart: json['addedToCart'] as int? ?? 0, // Handle addedToCart field (nullable)
      qty: json['qty'] as int? ?? 0, // Handle qty field (nullable)
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variantId': variantId,
      'colorName': colorName,
      'sizeName': sizeName,
      'isMainVariant': isMainVariant,
      'sku': sku,
      'eanCode': eanCode,
      'stock': stock,
      'mrp': mrp,
      'sellingPrice': sellingPrice,
      'minSellingPrice': minSellingPrice,
      'status': status,
      'addedToCart': addedToCart, // Include addedToCart in toJson
      'qty': qty,                 // Include qty in toJson
      'images': images.map((image) => image.toJson()).toList(),
    };
  }
}

class ImageModel {
  final String url;
  final int isMainImage;

  ImageModel({
    required this.url,
    required this.isMainImage,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      url: json['url'] as String,
      isMainImage: json['isMainImage'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'isMainImage': isMainImage,
    };
  }
}

class ProductFilterRequest {
  String categoryId;
  String subCategoryId;
  String listSubCategoryId;
  String productTitle;
  List<String> brand;
  String priceFrom;
  String priceTo;
  List<String> uomOrSize;
  List<String> colour;
  String priceSort;

  ProductFilterRequest({
    required this.categoryId,
    this.subCategoryId = "",
    this.listSubCategoryId = "",
    this.productTitle = "",
    this.brand = const [],
    this.priceFrom = "",
    this.priceTo = "",
    this.uomOrSize = const [],
    this.colour = const [],
    this.priceSort = "",
  });

  factory ProductFilterRequest.fromJson(Map<String, dynamic> json) {
    return ProductFilterRequest(
      categoryId: json['categoryId'] as String,
      subCategoryId: json['subCategoryId'] as String? ?? "",
      listSubCategoryId: json['listSubCategoryId'] as String? ?? "",
      productTitle: json['productTitle'] as String? ?? "",
      brand: List<String>.from(json['brand'] ?? []),
      priceFrom: json['priceFrom'] as String? ?? "",
      priceTo: json['priceTo'] as String? ?? "",
      uomOrSize: List<String>.from(json['uomOrSize'] ?? []),
      colour: List<String>.from(json['colour'] ?? []),
      priceSort: json['priceSort'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
      'listSubCategoryId': listSubCategoryId,
      'productTitle': productTitle,
      'brand': brand,
      'priceFrom': priceFrom,
      'priceTo': priceTo,
      'uomOrSize': uomOrSize,
      'colour': colour,
      'priceSort': priceSort,
    };
  }
}
