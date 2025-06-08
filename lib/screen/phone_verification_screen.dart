import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Import the new OTP screen
import 'otp_confirmation_screen.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const PhoneVerificationScreen({super.key, required this.user});

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _phoneFormKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submitPhoneNumber() {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (_phoneFormKey.currentState!.validate()) {
      final phoneNumber = _phoneController.text;

      if (kDebugMode) {
        debugPrint('Phone number submitted: $phoneNumber');
      }

      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('OTP sent to $phoneNumber')),
      );

      // **CHANGE HERE: Navigate to the new OTP screen.**
      navigator.push(
        MaterialPageRoute(
          builder: (context) => OtpConfirmationScreen(
            user: widget.user,
            phoneNumber: phoneNumber,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Phone Number'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
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
        ),
      ),
    );
  }
}
