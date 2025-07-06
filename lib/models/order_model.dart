enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  outForDelivery,
  delivered,
  cancelled
}

class OrderModel {
  final String id;
  final String userId;
  final String restaurantId;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final OrderStatus status;
  final String? deliveryAddress;
  final String? deliveryInstructions;
  final DateTime estimatedDeliveryTime;
  final DateTime? actualDeliveryTime;
  final String? driverId;
  final String? paymentMethod;
  final bool isPaid;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.status,
    this.deliveryAddress,
    this.deliveryInstructions,
    required this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    this.driverId,
    this.paymentMethod,
    required this.isPaid,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      restaurantId: json['restaurant_id'] ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromJson(item))
          .toList() ?? [],
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
      deliveryFee: (json['delivery_fee'] ?? 0.0).toDouble(),
      tax: (json['tax'] ?? 0.0).toDouble(),
      total: (json['total'] ?? 0.0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      deliveryAddress: json['delivery_address'],
      deliveryInstructions: json['delivery_instructions'],
      estimatedDeliveryTime: DateTime.parse(json['estimated_delivery_time']),
      actualDeliveryTime: json['actual_delivery_time'] != null
          ? DateTime.parse(json['actual_delivery_time'])
          : null,
      driverId: json['driver_id'],
      paymentMethod: json['payment_method'],
      isPaid: json['is_paid'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'restaurant_id': restaurantId,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'delivery_fee': deliveryFee,
      'tax': tax,
      'total': total,
      'status': status.toString().split('.').last,
      'delivery_address': deliveryAddress,
      'delivery_instructions': deliveryInstructions,
      'estimated_delivery_time': estimatedDeliveryTime.toIso8601String(),
      'actual_delivery_time': actualDeliveryTime?.toIso8601String(),
      'driver_id': driverId,
      'payment_method': paymentMethod,
      'is_paid': isPaid,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    List<OrderItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? total,
    OrderStatus? status,
    String? deliveryAddress,
    String? deliveryInstructions,
    DateTime? estimatedDeliveryTime,
    DateTime? actualDeliveryTime,
    String? driverId,
    String? paymentMethod,
    bool? isPaid,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      status: status ?? this.status,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      actualDeliveryTime: actualDeliveryTime ?? this.actualDeliveryTime,
      driverId: driverId ?? this.driverId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isPaid: isPaid ?? this.isPaid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? specialInstructions;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.specialInstructions,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 0,
      specialInstructions: json['special_instructions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'quantity': quantity,
      'special_instructions': specialInstructions,
    };
  }

  double get total => price * quantity;
} 