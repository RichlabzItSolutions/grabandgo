import 'package:hygi_health/data/model/subcategory_model.dart';

class SubcategoryListResponse {
  final bool success;
  final String message;
  final List<Subcategory> subcategories;

  SubcategoryListResponse({
    required this.success,
    required this.message,
    required this.subcategories,
  });

  // Factory constructor to convert JSON response to SubcategoryListResponse object
  factory SubcategoryListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data']['listsubcategories'] as List;
    List<Subcategory> subcategoriesList =
    list.map((i) => Subcategory.fromJson(i)).toList();

    return SubcategoryListResponse(
      success: json['success'],
      message: json['message'],
      subcategories: subcategoriesList,
    );
  }
}
