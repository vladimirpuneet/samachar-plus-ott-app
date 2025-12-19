import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../env.dart';

/// WhatsApp OTP Service
///
/// Handles sending OTP messages via WhatsApp Business API
/// and manages OTP verification
class WhatsAppOtpService {
  static final WhatsAppOtpService _instance = WhatsAppOtpService._internal();
  static WhatsAppOtpService get instance => _instance;

  WhatsAppOtpService._internal();

  // WhatsApp Business API credentials
  static const String _phoneNumberId = Env.whatsappPhoneNumberId;
  static const String _accessToken = Env.whatsappAccessToken;
  static const String _apiVersion = Env.whatsappApiVersion;

  // OTP storage (in production, use secure server-side storage)
  final Map<String, OtpData> _otpStore = {};

  /// Send OTP to phone number
  Future<bool> sendOtp(String phoneNumber) async {
    try {
      // Generate 6-digit OTP
      final otp = _generateOtp();

      // Store OTP with expiration (5 minutes)
      _otpStore[phoneNumber] = OtpData(
        otp: otp,
        expiresAt: DateTime.now().add(const Duration(minutes: 5)),
      );

      // Send via WhatsApp API
      final success = await _sendWhatsAppMessage(phoneNumber, 'Your OTP for Samachar Plus is: $otp. Valid for 5 minutes.');

      if (!success) {
        // Remove OTP if sending failed
        _otpStore.remove(phoneNumber);
      }

      return success;
    } catch (e) {
      print('Error sending OTP: $e');
      return false;
    }
  }

  /// Verify OTP for phone number
  bool verifyOtp(String phoneNumber, String enteredOtp) {
    final otpData = _otpStore[phoneNumber];

    if (otpData == null) {
      return false; // No OTP sent
    }

    if (DateTime.now().isAfter(otpData.expiresAt)) {
      _otpStore.remove(phoneNumber); // Expired
      return false;
    }

    if (otpData.otp == enteredOtp) {
      _otpStore.remove(phoneNumber); // Valid, remove
      return true;
    }

    return false;
  }

  /// Check if OTP was sent to phone number
  bool hasOtp(String phoneNumber) {
    final otpData = _otpStore[phoneNumber];
    return otpData != null && DateTime.now().isBefore(otpData.expiresAt);
  }

  /// Generate 6-digit OTP
  String _generateOtp() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  /// Send message via WhatsApp Business API
  Future<bool> _sendWhatsAppMessage(String to, String message) async {
    try {
      final url = 'https://graph.facebook.com/$_apiVersion/$_phoneNumberId/messages';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'messaging_product': 'whatsapp',
          'to': to,
          'type': 'text',
          'text': {
            'body': message,
          },
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['messages'] != null;
      } else {
        print('WhatsApp API error: ${response.statusCode} - ${response.body}');
        if (response.statusCode == 401) {
          print('Token expired or invalid: Access token needs refresh');
        }
        return false;
      }
    } catch (e) {
      print('Error sending WhatsApp message: $e');
      return false;
    }
  }
}

/// OTP data storage
class OtpData {
  final String otp;
  final DateTime expiresAt;

  OtpData({
    required this.otp,
    required this.expiresAt,
  });
}