import 'dart:convert';

class Favourite {
  final String productName;
  final int productPrice;
  final String category;
  final List<String> image;
  final String vendorId;
  final int productQuantity;
  int quantity;
  final String productId;
  final String description;
  final String fullName;

  Favourite({
    required this.productName,
    required this.productPrice,
    required this.category,
    required this.image,
    required this.vendorId,
    required this.productQuantity,
    required this.quantity,
    required this.productId,
    required this.description,
    required this.fullName,
  });

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'category': category,
      'image': image,
      'vendorId': vendorId,
      'productQuantity': productQuantity,
      'quantity': quantity,
      'productId': productId,
      'description': description,
      'fullName': fullName,
    };
  }

  factory Favourite.fromMap(Map<String, dynamic> map) {
    return Favourite(
      productName: map['productName'] as String,
      productPrice: map['productPrice'] as int,
      category: map['category'] as String,
      image:
          map['images'] != null
              ? List<String>.from(map['images'] as List<dynamic>)
              : [],
      vendorId: map['vendorId'] as String,
      productQuantity: map['productQuantity'] as int,
      quantity: map['quantity'] as int,
      productId: map['productId'] as String,
      description: map['description'] as String,
      fullName: map['fullName'] as String,
    );
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory Favourite.fromJson(String source) {
    final Map<String, dynamic> map = json.decode(source);
    return Favourite.fromMap(map);
  }
}
