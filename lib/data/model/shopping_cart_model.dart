

class CartItem {
  final String name;
  final String image;
  final int originalPrice;
  final int discountedPrice;
  int quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.originalPrice,
    required this.discountedPrice,
    required this.quantity,
  });
}