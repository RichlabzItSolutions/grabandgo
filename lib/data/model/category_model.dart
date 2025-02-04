class Category {
  final int categoryId;
  final String categoryTitle;
  final String appIcon;
  final String webImage;
  final String mainImage;
  final int position;
  final int status;
  final String createdOn;

  Category({
    required this.categoryId,
    required this.categoryTitle,
    required this.appIcon,
    required this.webImage,
    required this.mainImage,
    required this.position,
    required this.status,
    required this.createdOn,
  });

  // Factory method to create Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId']?? '',
      categoryTitle: json['categoryTitle']?? '',
      appIcon: json['appIcon']?? '',
      webImage: json['webImage']?? '',
      mainImage: json['mainImage']?? '',
      position: json['position']?? '',
      status: json['status'],
      createdOn: json['createdOn'],
    );
  }

  // Method to convert Category object back to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryTitle': categoryTitle,
      'appIcon': appIcon,
      'webImage': webImage,
      'mainImage': mainImage,
      'position': position,
      'status': status,
      'createdOn': createdOn,
    };
  }
}
