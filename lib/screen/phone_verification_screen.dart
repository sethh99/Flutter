import 'package:flutter/material.dart';
import 'home_screen.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final String username;

  const PhoneVerificationScreen({super.key, required this.username});

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _phoneFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());
  bool _isOtpScreen = false;

  void _submitPhoneNumber() {
    if (_phoneFormKey.currentState!.validate()) {
      // Placeholder for sending phone number to backend and triggering OTP
      print('Phone number submitted: ${_phoneController.text}');
      setState(() {
        _isOtpScreen = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP sent to ${_phoneController.text}')),
      );
    }
  }

  void _verifyOtp() {
    if (_otpFormKey.currentState!.validate()) {
      // Combine OTP digits
      String otp = _otpControllers.map((controller) => controller.text).join();
      // Placeholder for OTP verification logic
      print('OTP submitted: $otp');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP verified successfully!')),
      );
      // Navigate to HomeScreen after successful OTP verification
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(username: widget.username),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isOtpScreen ? 'Verify OTP' : 'Enter Phone Number'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isOtpScreen ? _buildOtpForm() : _buildPhoneForm(),
      ),
    );
  }

  Widget _buildPhoneForm() {
    return Form(
      key: _phoneFormKey,
      child: Column(
        children: [
          const Spacer(),
          const Text(
            'Enter Your Phone Number',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
              hintText: 'e.g., 012345566 or +85512345566',
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter phone number';
              }
              // Regex for Cambodian phone numbers: +855 or 0 followed by valid prefix and 6 digits
              final phoneRegex = RegExp(
                  r'^((\+855|0)(10|11|12|15|16|17|69|70|76|77|78|85|89|92|95|99)\d{6})$');
              if (!phoneRegex.hasMatch(value)) {
                return 'Enter a valid Cambodian phone number (e.g., 012345566 or +85512345566)';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitPhoneNumber,
            child: const Text('Send OTP'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildOtpForm() {
    return Form(
      key: _otpFormKey,
      child: Column(
        children: [
          const Spacer(),
          const Text(
            'Enter OTP',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Sent to ${_phoneController.text}',
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
            child: const Text('Verify OTP'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}