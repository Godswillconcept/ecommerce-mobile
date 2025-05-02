// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey[800]),
            onPressed: () {
              // Show options like "Mark all as read" or "Clear all"
              showModalBottomSheet(
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.check_circle_outline),
                      title: Text('Mark all as read'),
                      onTap: () {
                        Navigator.pop(context);
                        // Implement mark all as read functionality
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.delete_outline),
                      title: Text('Clear all notifications'),
                      onTap: () {
                        Navigator.pop(context);
                        // Implement clear all functionality
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _buildNotificationsList(context),
    );
  }

  Widget _buildNotificationsList(BuildContext context) {
    // Sample notifications data - in a real app, this would come from your data source
    final notifications = [
      {
        'type': 'order',
        'title': 'Order #4385 Shipped',
        'description':
            'Your order has been shipped and will arrive in 2-3 business days.',
        'time': DateTime.now().subtract(Duration(minutes: 30)),
        'isRead': false,
        'icon': Icons.local_shipping,
        'color': Colors.blue,
      },
      {
        'type': 'promo',
        'title': 'Flash Sale: 50% OFF',
        'description':
            'Limited time offer on all summer collections. Ends in 12 hours!',
        'time': DateTime.now().subtract(Duration(hours: 3)),
        'isRead': true,
        'icon': Icons.flash_on,
        'color': Colors.orange,
      },
      {
        'type': 'wishlist',
        'title': 'Price Drop Alert',
        'description':
            'An item in your wishlist is now 15% off! Check it out before stock runs out.',
        'time': DateTime.now().subtract(Duration(hours: 8)),
        'isRead': true,
        'icon': Icons.favorite,
        'color': Colors.red,
      },
      {
        'type': 'review',
        'title': 'Review Requested',
        'description':
            'How was your experience with the Wireless Headphones? Share your feedback!',
        'time': DateTime.now().subtract(Duration(days: 1)),
        'isRead': true,
        'icon': Icons.star,
        'color': Colors.amber,
      },
      {
        'type': 'account',
        'title': 'Account Security',
        'description': 'We noticed a login from a new device. Was this you?',
        'time': DateTime.now().subtract(Duration(days: 2)),
        'isRead': true,
        'icon': Icons.security,
        'color': Colors.teal,
      },
    ];

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              "No notifications yet",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "We'll notify you when something arrives",
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      padding: EdgeInsets.symmetric(vertical: 12),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final bool isRead = notification['isRead'] as bool;
        final DateTime time = notification['time'] as DateTime;
        final IconData icon = notification['icon'] as IconData;
        final Color color = notification['color'] as Color;

        return Dismissible(
          key: Key('notification-$index'),
          background: Container(
            color: Colors.red[400],
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            // Handle notification removal
          },
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            elevation: isRead ? 0 : 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isRead
                  ? BorderSide(color: Colors.grey[200]!)
                  : BorderSide.none,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isRead ? Colors.white : Colors.white,
              ),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(
                    icon,
                    color: color,
                    size: 22,
                  ),
                ),
                title: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(
                    notification['title'] as String,
                    style: TextStyle(
                      fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification['description'] as String,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Text(
                      _formatNotificationTime(time),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                trailing: !isRead
                    ? Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : null,
                onTap: () {
                  // Handle notification tap
                  // e.g., navigate to relevant screen
                },
                isThreeLine: true,
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatNotificationTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(time);
    }
  }
}
