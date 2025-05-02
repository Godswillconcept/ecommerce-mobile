import 'package:intl/intl.dart';

class Review {
  final String id;
  final String productId;
  final String userId;
  final double rating;
  final String comment;
  final DateTime reviewDate;

  // User info - these would typically come from a user service or be included in the review response
  String? userName;
  String? userAvatar;

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.reviewDate,
    this.userName,
    this.userAvatar,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    // Parse the review date, handling various formats
    DateTime reviewDate;
    try {
      reviewDate = DateTime.parse(json['review_date']);
    } catch (e) {
      reviewDate = DateTime.now(); // Fallback to now if parsing fails
    }

    return Review(
      id: json['_id'] ?? '',
      productId: json['product_id'] ?? '',
      userId: json['user_id'] ?? '',
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : json['rating']?.toDouble() ?? 0.0,
      comment: json['comment'] ?? '',
      reviewDate: reviewDate,
      // These fields might not be present in the API response
      // In a real app, you might need to fetch user info separately or have it included in the API
      userName: json['user_name'] ?? 'Anonymous',
      userAvatar: json['user_avatar'] ??
          'https://randomuser.me/api/portraits/lego/1.jpg',
    );
  }

  // Get a user-friendly date format
  String getFormattedDate() {
    final now = DateTime.now();
    final difference = now.difference(reviewDate);

    // If less than a day, show "today" or "X hours ago"
    if (difference.inDays < 1) {
      if (difference.inHours < 1) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    }
    // If less than a week, show "X days ago"
    else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    }
    // If less than a month, show "X weeks ago"
    else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    }
    // Otherwise show the date
    else {
      return DateFormat('MMM d, yyyy').format(reviewDate);
    }
  }
}
