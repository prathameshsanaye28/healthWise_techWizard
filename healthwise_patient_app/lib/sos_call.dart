import 'dart:convert';

import 'package:http/http.dart' as http;

class TwilioService {
  final String accountSid;
  final String authToken;

  TwilioService({
    required this.accountSid,
    required this.authToken,
  });

  Future<void> makeCall({
    required String to,
    required String from,
    required String url,
  }) async {
    final uri = Uri.https(
        'api.twilio.com', '/2010-04-01/Accounts/$accountSid/Calls.json');
    final headers = {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final body = {
      'To': to,
      'From': from,
      'Url': url,
    };

    try {
      final response = await http.post(uri, headers: headers, body: body);
      if (response.statusCode == 201) {
        print('Call initiated successfully');
      } else {
        print('Call initiation failed: ${response.body}');
      }
    } catch (e) {
      print('Error making Twilio call: $e');
    }
  }
}
