class Subcategory {
  final int categoryId;
  final String categoryName;
  final int subcategoryId;
  final String subcategoryTitle;
  final String appIcon;
  final String webImage;
  final String mainImage;
  final int position;
  final int status;
  final String createdOn;

  Subcategory({
    required this.categoryId,
    required this.categoryName,
    required this.subcategoryId,
    required this.subcategoryTitle,
    required this.appIcon,
    required this.webImage,
    required this.mainImage,
    required this.position,
    required this.status,
    required this.createdOn,
  });

  // From JSON method with null handling
  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      categoryId: int.tryParse(json['categoryId'].toString()) ?? 0, // Convert to int
      categoryName: json['categoryName'] ?? '', // Provide empty string if null
      subcategoryId: int.tryParse(json['subcategoryId'].toString()) ?? 0, // Convert to int
      subcategoryTitle: json['subcategoryTitle'] ?? '', // Provide empty string if null
      appIcon: json['appIcon'] ?? '', // Provide empty string if null
      webImage: json['webImage'] ?? '', // Provide empty string if null
      mainImage: json['mainImage'] ?? '', // Provide empty string if null
      position: int.tryParse(json['position'].toString()) ?? 0, // Convert to int
      status: int.tryParse(json['status'].toString()) ?? 0, // Convert to int
      createdOn: json['createdOn'] ?? '', // Provide empty string if null
    );
  }
}
