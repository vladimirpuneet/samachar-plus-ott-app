import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:samachar_plus_ott_app/providers/auth_provider.dart';
import 'package:samachar_plus_ott_app/widgets/custom_spinner.dart';
import 'package:samachar_plus_ott_app/theme.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _phone;
  bool? _isNewUser;
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    // Get data from route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      print('OtpVerificationScreen initState: extra = $extra');
      if (extra != null) {
        setState(() {
          _phone = extra['phone'] as String;
          _isNewUser = extra['isNewUser'] as bool;
          print('_phone set to $_phone, _isNewUser set to $_isNewUser');
        });
      } else {
        print('extra is null in initState');
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _nameController.dispose();
    super.dispose();
  }

  String get _otp => _otpControllers.map((c) => c.text).join();

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  Future<void> _verifyOtp() async {
    if (_otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter complete OTP')),
      );
      return;
    }

    assert(_phone != null && _isNewUser != null);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_isNewUser!) {
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your name')),
        );
        return;
      }

      await authProvider.verifyOtpAndSignUp(_phone!, _otp, _nameController.text.trim());
    } else {
      await authProvider.verifyOtpAndSignIn(_phone!, _otp);
    }

    if (authProvider.error == null) {
      // Navigate to home
      context.go('/');
    }
  }

  Future<void> _resendOtp() async {
    if (_resendCountdown > 0) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.sendOtp(_phone!);

    if (authProvider.error == null) {
      setState(() => _resendCountdown = 30);
      _startResendTimer();
    }
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendCountdown > 0) {
        setState(() => _resendCountdown--);
        _startResendTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    print('OtpVerificationScreen build: _phone = $_phone, _isNewUser = $_isNewUser');

    if (_phone == null || _isNewUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Verify OTP'),
          backgroundColor: AppTheme.red500,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        backgroundColor: AppTheme.red500,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter OTP sent to $_phone',
                style: const TextStyle(
                  fontSize: 18,
                  color: AppTheme.gray800,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 40,
                    child: TextFormField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => _onOtpChanged(index, value),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              if (_isNewUser!) ...[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
              ],
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
                  onPressed: authProvider.isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.red500,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    authProvider.isLoading
                        ? (_isNewUser! ? 'Creating Account...' : 'Signing In...')
                        : (_isNewUser! ? 'Create Account' : 'Sign In'),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: _resendCountdown > 0 ? null : _resendOtp,
                  child: Text(
                    _resendCountdown > 0
                        ? 'Resend OTP in $_resendCountdown seconds'
                        : 'Resend OTP',
                    style: TextStyle(
                      color: _resendCountdown > 0 ? AppTheme.gray500 : AppTheme.red500,
                    ),
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