class OrderModel {
  final String orderId;
  final String customerName;
  final String paymentMethod;
  final String amount;
  final String dateTime;
  final String status;
  final String orderCode;

  OrderModel({
    required this.orderId,
    required this.customerName,
    required this.paymentMethod,
    required this.amount,
    required this.dateTime,
    required this.status,
    required this.orderCode,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId']?.toString() ?? '',
      customerName: json['customerName'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      amount: json['amount']?.toString() ?? '0.00',
      dateTime: json['dateTime'] ?? '',
      status: json['status'] ?? '',
      orderCode: json['orderCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'customerName': customerName,
      'paymentMethod': paymentMethod,
      'amount': amount,
      'dateTime': dateTime,
      'status': status,
      'orderCode': orderCode,
    };
  }

  @override
  String toString() {
    return 'OrderModel(orderId: $orderId, customerName: $customerName, paymentMethod: $paymentMethod, amount: $amount, status: $status, orderCode: $orderCode)';
  }
}

class OrdersResponse {
  final bool success;
  final String message;
  final List<OrderModel> orders;

  OrdersResponse({
    required this.success,
    required this.message,
    required this.orders,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      orders:
          (json['orders'] as List<dynamic>?)
              ?.map((order) => OrderModel.fromJson(order))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'orders': orders.map((order) => order.toJson()).toList(),
    };
  }
}
