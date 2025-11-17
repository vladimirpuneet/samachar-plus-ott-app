import 'package:supabase_flutter/supabase_flutter.dart';

/// Notification Service for Samachar Plus OTT App
/// 
/// Handles push notifications using Supabase Edge Functions and Realtime.
/// Replaces Firebase Cloud Messaging (FCM) with Supabase-native solution.
class NotificationService {
  static NotificationService? _instance;
  static NotificationService get instance => _instance ??= NotificationService._();

  NotificationService._();

  final SupabaseClient _client = Supabase.instance.client;
  
  /// Initialize notification service
  /// Sets up Supabase Realtime channel for push notifications
  Future<void> initialize() async {
    try {
      // Subscribe to user-specific notification channel
      final userId = _client.auth.currentUser?.id;
      if (userId != null) {
        await _subscribeToNotifications(userId);
      }
      
      // Listen to auth state changes to update subscription
      _client.auth.onAuthStateChange.listen((data) {
        final user = data.session?.user;
        if (user != null) {
          _subscribeToNotifications(user.id);
        } else {
          _unsubscribeFromNotifications();
        }
      });
    } catch (e) {
      print('Failed to initialize notification service: $e');
    }
  }

  /// Subscribe to user-specific notifications via Supabase Realtime
  Future<void> _subscribeToNotifications(String userId) async {
    try {
      // Subscribe to notifications table for this user
      _client
          .channel('notifications:$userId')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'notifications',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'user_id',
              value: userId,
            ),
            callback: (payload) {
              _handleNotification(payload.newRecord);
            },
          )
          .subscribe();
      
      print('Subscribed to notifications for user: $userId');
    } catch (e) {
      print('Failed to subscribe to notifications: $e');
    }
  }

  /// Unsubscribe from notifications
  Future<void> _unsubscribeFromNotifications() async {
    try {
      await _client.removeAllChannels();
      print('Unsubscribed from all notification channels');
    } catch (e) {
      print('Failed to unsubscribe from notifications: $e');
    }
  }

  /// Handle incoming notification
  void _handleNotification(Map<String, dynamic> notification) {
    print('Received notification: $notification');
    
    // You can add custom notification handling here
    // For example: show local notification, update UI, etc.
    
    // Example notification structure:
    // {
    //   'id': 'uuid',
    //   'user_id': 'uuid',
    //   'title': 'Breaking News',
    //   'body': 'New article published',
    //   'data': {'article_id': 'uuid'},
    //   'created_at': 'timestamp'
    // }
  }

  /// Send notification to a user (via Supabase Edge Function)
  /// 
  /// This calls a Supabase Edge Function that inserts into notifications table
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _client.from('notifications').insert({
        'user_id': userId,
        'title': title,
        'body': body,
        'data': data,
        'read': false,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      print('Notification sent to user: $userId');
    } catch (e) {
      print('Failed to send notification: $e');
      rethrow;
    }
  }

  /// Send notification to multiple users
  Future<void> sendBulkNotification({
    required List<String> userIds,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final notifications = userIds.map((userId) => {
        'user_id': userId,
        'title': title,
        'body': body,
        'data': data,
        'read': false,
        'created_at': DateTime.now().toIso8601String(),
      }).toList();
      
      await _client.from('notifications').insert(notifications);
      
      print('Bulk notification sent to ${userIds.length} users');
    } catch (e) {
      print('Failed to send bulk notification: $e');
      rethrow;
    }
  }

  /// Send broadcast notification to all users
  /// 
  /// This should call a Supabase Edge Function for better performance
  Future<void> sendBroadcastNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Call Supabase Edge Function to handle broadcast
      await _client.functions.invoke(
        'send-broadcast-notification',
        body: {
          'title': title,
          'body': body,
          'data': data,
        },
      );
      
      print('Broadcast notification sent');
    } catch (e) {
      print('Failed to send broadcast notification: $e');
      rethrow;
    }
  }

  /// Get user notifications
  Future<List<Map<String, dynamic>>> getNotifications({
    int limit = 50,
    bool unreadOnly = false,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      var query = _client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);
      
      if (unreadOnly) {
        query = query.eq('read', false);
      }
      
      return await query;
    } catch (e) {
      print('Failed to get notifications: $e');
      return [];
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _client
          .from('notifications')
          .update({'read': true})
          .eq('id', notificationId);
      
      print('Notification marked as read: $notificationId');
    } catch (e) {
      print('Failed to mark notification as read: $e');
      rethrow;
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      await _client
          .from('notifications')
          .update({'read': true})
          .eq('user_id', userId)
          .eq('read', false);
      
      print('All notifications marked as read');
    } catch (e) {
      print('Failed to mark all notifications as read: $e');
      rethrow;
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _client
          .from('notifications')
          .delete()
          .eq('id', notificationId);
      
      print('Notification deleted: $notificationId');
    } catch (e) {
      print('Failed to delete notification: $e');
      rethrow;
    }
  }

  /// Get unread notification count
  Future<int> getUnreadCount() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        return 0;
      }
      
      final response = await _client
          .from('notifications')
          .select('id', const FetchOptions(count: CountOption.exact))
          .eq('user_id', userId)
          .eq('read', false);
      
      return response.count ?? 0;
    } catch (e) {
      print('Failed to get unread count: $e');
      return 0;
    }
  }

  /// Stream unread notification count
  Stream<int> streamUnreadCount() {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      return Stream.value(0);
    }
    
    return _client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .eq('read', false)
        .map((data) => data.length);
  }

  /// Request notification permission (for local notifications)
  /// 
  /// Note: This is for local notifications display, not for receiving
  /// Supabase notifications (which work via Realtime)
  Future<bool> requestPermission() async {
    // For local notifications, you would use a package like flutter_local_notifications
    // This is a placeholder for permission request
    print('Notification permission requested');
    return true;
  }

  /// Dispose notification service
  Future<void> dispose() async {
    await _unsubscribeFromNotifications();
  }
}
