class TransactionModel {
  final String transactionId;
  final String mlId;
  final String serverId;
  final String productName;
  final int totalPrice;
  final String paymentMethod;
  final String date;
  final String status;

  TransactionModel({
    required this.transactionId,
    required this.mlId,
    required this.serverId,
    required this.productName,
    required this.totalPrice,
    required this.paymentMethod,
    required this.date,
    required this.status,
  });
}