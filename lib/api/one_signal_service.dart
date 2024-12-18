import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safetracker/utils/logging/logger.dart';
import 'package:safetracker/utils/popups/loader.dart';

class OneSignalService {
  static const String oneSignalApiKey = "os_v2_app_5nyadopwufhotn5sfvzy42ex4zv2hfutljkulw4vmza7q7qindm5taowre3ddviik2wys4uap33psgdlydbfjfshb4cdkkqctyahn3q";
  static const String oneSignalAppId = "eb7001b9-f6a1-4ee9-b7b2-2d738e6897e6";

  /// Send a notification to a specific user
  static Future<void> sendNotification({
    required String title,
    required String body,
    required String userId, // External ID
    required String targetUserId, // OneSignal player ID
  }) async {
    const String url = "https://onesignal.com/api/v1/notifications";

    final headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": "Basic $oneSignalApiKey"
    };

    final payload = {
      "app_id": oneSignalAppId,
      // "include_aliases": {
      //   "external_id": [userId],
      // },
      "include_player_ids": [targetUserId],
      "headings": {"en": title},
      "contents": {"en": body},
    };

    try {
      SLoggerHelper.info('Sending notification... $payload');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );

      SLoggerHelper.debug('Response body: ${response.body}');
      SLoggerHelper.debug('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        SLoggerHelper.info('Notification sent successfully!');
        SLoaders.successSnackBar(title: 'Notification sent successfully!');
      } else {
        SLoggerHelper.error('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      SLoggerHelper.error('Error sending notification: $e');
    }
  }
}
