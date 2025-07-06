class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final String categoryId;
  final String restaurantId;
  final bool isAvailable;
  final int preparationTime; // in minutes
  final List<String>? tags;
  final Map<String, dynamic>? nutritionalInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.categoryId,
    required this.restaurantId,
    required this.isAvailable,
    required this.preparationTime,
    this.tags,
    this.nutritionalInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['image_url'],
      categoryId: json['category_id'] ?? '',
      restaurantId: json['restaurant_id'] ?? '',
      isAvailable: json['is_available'] ?? true,
      preparationTime: json['preparation_time'] ?? 0,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      nutritionalInfo: json['nutritional_info'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category_id': categoryId,
      'restaurant_id': restaurantId,
      'is_available': isAvailable,
      'preparation_time': preparationTime,
      'tags': tags,
      'nutritional_info': nutritionalInfo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? categoryId,
    String? restaurantId,
    bool? isAvailable,
    int? preparationTime,
    List<String>? tags,
    Map<String, dynamic>? nutritionalInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      restaurantId: restaurantId ?? this.restaurantId,
      isAvailable: isAvailable ?? this.isAvailable,
      preparationTime: preparationTime ?? this.preparationTime,
      tags: tags ?? this.tags,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 