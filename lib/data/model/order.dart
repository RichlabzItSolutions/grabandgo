class Order {
  final String name;
  final String transactionId;
  final String orderDate;
  final double totalPayment;
  final String status;

  Order({
    required this.name,
    required this.transactionId,
    required this.orderDate,
    required this.totalPayment,
    required this.status,
  });
}