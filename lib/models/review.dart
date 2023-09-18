import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Review {
  int? id;
  int productId;
  int userId;
  String rating;
  String? comment;
  DateTime? reviewDate;
  Review({
    this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    this.comment,
    DateTime? reviewDate,
  }) : reviewDate = reviewDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'rating': rating,
      'comment': comment,
      'review_date': reviewDate?.toIso8601String(),
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] != null ? map['id'] as int : null,
      productId: map['product_id'] as int,
      userId: map['user_id'] as int,
      rating: map['rating'] as String,
      comment: map['comment'] != null ? map['comment'] as String : null,
      reviewDate: map['review_date'] != null
          ? DateTime.parse(map['reviewDate'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) =>
      Review.fromMap(json.decode(source) as Map<String, dynamic>);
}
