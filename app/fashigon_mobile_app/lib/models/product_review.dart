import 'dart:convert';

class ProductReview {
  final String id;
  final String buyerId;
  final String email;
  final String fullName;
  final String productId;
  final double rating;
  final String review;

  ProductReview({
    required this.id,
    required this.buyerId,
    required this.fullName,
    required this.email,
    required this.productId,
    required this.rating,
    required this.review,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'buyerId': buyerId,
      'email': email,
      'fullName': fullName,
      'productId': productId,
      'rating': rating,
      'review': review,
    };
  }

  factory ProductReview.fromMap(Map<String, dynamic> map) {
    return ProductReview(
      id: map['id'] as String,
      buyerId: map['buyerId'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      productId: map['productId'] as String,
      rating: (map['rating'] as num).toDouble(),
      review: map['review'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductReview.fromJson(String source) =>
      ProductReview.fromMap(json.decode(source) as Map<String, dynamic>);
}
