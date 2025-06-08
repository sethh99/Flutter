import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class OtpConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final String phoneNumber;

  const OtpConfirmationScreen({
    super.key,
    required this.user,
    required this.phoneNumber,
  });

  @override
  State<OtpConfirmationScreen> createState() => _OtpConfirmationScreenState();
}

class _OtpConfirmationScreenState extends State<OtpConfirmationScreen> {
  final _otpFormKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (_otpFormKey.currentState!.validate()) {
      String otp = _otpControllers.map((controller) => controller.text).join();
      if (kDebugMode) {
        debugPrint('OTP submitted: $otp');
      }

      // In a real app, you would verify the OTP with your backend here.
      // For this simulation, we'll assume it's always successful.

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('OTP verified successfully!')),
      );

      // Navigate to HomeScreen after successful OTP verification.
      // Note: In a real "Forgot Password" flow, you'd navigate to a "Reset Password" screen.
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: widget.user),
        ),
            (route) => false, // Removes all previous routes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _otpFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter OTP',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Sent to ${widget.phoneNumber}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextFormField(
                      controller: _otpControllers[index],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      validator: (value) =>
                      value == null || value.isEmpty ? ' ' : null,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _verifyOtp,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
