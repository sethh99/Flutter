import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class PhoneVerificationScreen extends StatefulWidget {
  // **FIX: This screen must accept the entire user map.**
  final Map<String, dynamic> user;

  const PhoneVerificationScreen({super.key, required this.user});

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _phoneFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers =
  List.generate(6, (_) => TextEditingController());
  bool _isOtpScreen = false;

  @override
  void dispose() {
    _phoneController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitPhoneNumber() {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (_phoneFormKey.currentState!.validate()) {
      if (kDebugMode) {
        debugPrint('Phone number submitted: ${_phoneController.text}');
      }
      setState(() {
        _isOtpScreen = true;
      });
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('OTP sent to ${_phoneController.text}')),
      );
    }
  }

  void _verifyOtp() {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (_otpFormKey.currentState!.validate()) {
      String otp = _otpControllers.map((controller) => controller.text).join();
      if (kDebugMode) {
        debugPrint('OTP submitted: $otp');
      }

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('OTP verified successfully!')),
      );

      // **FIX: Pass the user map to the HomeScreen.**
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: widget.user),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Enter Your Phone Number',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
              hintText: 'e.g., 012345678',
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter phone number';
              }
              final phoneRegex = RegExp(r'^((\+855|0)(10|11|12|15|16|17|69|70|76|77|78|81|85|86|87|89|92|93|95|96|98|99)\d{6,7})$');
              if (!phoneRegex.hasMatch(value)) {
                return 'Enter a valid Cambodian phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitPhoneNumber,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Send OTP'),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpForm() {
    return Form(
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
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Verify OTP'),
          ),
        ],
      ),
    );
  }
}
