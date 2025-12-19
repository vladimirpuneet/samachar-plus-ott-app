import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samachar_plus_ott_app/providers/auth_provider.dart';
import 'package:samachar_plus_ott_app/widgets/custom_spinner.dart';
import 'package:samachar_plus_ott_app/theme.dart';
import 'package:samachar_plus_ott_app/components/uni_button.dart';
import 'package:go_router/go_router.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isNewUser = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    // Remove any spaces or special characters
    final cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');

    // Check if it's a valid Indian mobile number
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleanPhone)) {
      return 'Please enter a valid 10-digit Indian mobile number';
    }

    return null;
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = '+91${_phoneController.text.trim().replaceAll(RegExp(r'[^\d]'), '')}';

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Check if user exists
    final userExists = await authProvider.checkUserExists(phone);
    setState(() => _isNewUser = !userExists);

    await authProvider.sendOtp(phone);

    if (authProvider.error == null) {
      // Navigate to OTP screen
      context.push('/otp', extra: {
        'phone': phone,
        'isNewUser': _isNewUser,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In / Sign Up'),
        backgroundColor: AppTheme.red500,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your phone number',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.gray800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We\'ll send you an OTP via WhatsApp to verify your number',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.gray600,
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter 10-digit mobile number',
                  prefixText: '+91 ',
                  border: OutlineInputBorder(),
                ),
                validator: _validatePhone,
                maxLength: 10,
              ),
              const SizedBox(height: 24),
              if (authProvider.error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    authProvider.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading ? null : _sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.red500,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    authProvider.isLoading ? 'Sending OTP...' : 'Send OTP',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              if (authProvider.isLoading)
                const Center(child: CustomSpinner()),
            ],
          ),
        ),
      ),
    );
  }
}