class CartItemModel {
  final int productId;
  final int variantId;
  final String qty;
  final String userId;

  CartItemModel({
    required this.productId,
    required this.variantId,
    required this.qty,
    required this.userId,
  });
}
