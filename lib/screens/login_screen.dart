import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jk_hospitality/services/otp_service.dart';
import 'package:jk_hospitality/screens/booking_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOTPSent = false;
  bool _isButtonDisabled = false; // Button disabled state
  int _seconds = 30; // Timer duration

  // Timer function to control OTP resend
  void _startTimer() {
    setState(() {
      _isButtonDisabled = true;
      _seconds = 30;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds--;
      });
      if (_seconds == 0) {
        timer.cancel();
        setState(() {
          _isButtonDisabled = false;
        });
      }
    });
  }

  // Validation for mobile number
  String? validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    } else if (value.length != 10) {
      return 'Mobile number must be 10 digits';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Mobile number must contain only digits';
    }
    return null;
  }

// Request OTP when the form is validated
  void _requestOTP() async {
    if (_formKey.currentState!.validate()) {
      // Call OTP Service to send OTP
      String otpResult = await OTPService.sendOTP(_mobileController.text);

      if (otpResult == 'success') {
        setState(() {
          _isOTPSent = true;
          _startTimer();
        });

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP requested on SANDES App')),
        );
      } else if (otpResult == 'not_registered') {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Mobile no. not registered. Please get regiistered on SANDES App.')),
        );
      } else if (otpResult == 'server_error') {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Server error. Please try again later.')),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to send OTP. Please try again.')),
        );
      }
    }
  }

  void _verifyOTP() async {
    String mobileNumber = _mobileController.text;
    String otp = _otpController.text;

    bool isVerified = await OTPService.verifyOTP(mobileNumber, otp);
    if (isVerified) {
      // Store user login status in Shared Preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('mob_no', _mobileController.text);

      // Navigate to BookingOptions screen
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const BookingOptions()),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Union Territory of Jammu and Kashmir'),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Image.asset(
              //       'images/background.png',
              //       height: 100,
              //     ),
              //     const SizedBox(width: 20),
              //     const Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             'आतिथ्य तथा प्रोटोकॉल विभाग',
              //             style: TextStyle(
              //                 fontSize: 18, fontWeight: FontWeight.bold),
              //             maxLines: 2, // Allow text wrapping
              //             overflow: TextOverflow.ellipsis,
              //           ),
              //           Text(
              //             'Department of Hospitality & Protocol',
              //             style: TextStyle(
              //               fontSize: 18,
              //               height: 1.5, // Space between lines
              //               fontWeight: FontWeight.bold,
              //             ),
              //             maxLines: 2, // Allow text wrapping
              //             overflow: TextOverflow.ellipsis,
              //           ),
              //           Text(
              //             'مہمان نوازی اور پروٹوکول محکمہ',
              //             style: TextStyle(
              //                 fontSize: 18, fontWeight: FontWeight.bold),
              //             maxLines: 2, // Allow text wrapping
              //             overflow: TextOverflow.ellipsis,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'images/background.png',
                    height: 100,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final maxWidth = constraints.maxWidth;
                            final fontSize = maxWidth *
                                0.08; // Adjust font size based on width
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'आतिथ्य तथा प्रोटोकॉल विभाग',
                                  style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2, // Allow text wrapping
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Department of Hospitality & Protocol',
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    height: 1.5, // Space between lines
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2, // Allow text wrapping
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'مہمان نوازی اور پروٹوکول محکمہ',
                                  style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2, // Allow text wrapping
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText:
                            'Enter the mobile no. registered on SANDES app',
                        labelStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.width *
                              0.028, // Adjust the multiplier as needed
                        ),
                        isDense: true,
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: validateMobileNumber,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isButtonDisabled ? null : _requestOTP,
                        child: _isButtonDisabled
                            ? Text('Send OTP Again ($_seconds s)')
                            : const Text('Send OTP'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_isOTPSent)
                      Column(
                        children: [
                          TextFormField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Enter OTP received on SANDES app',
                              labelStyle: const TextStyle(fontSize: 14),
                              isDense: true,
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _verifyOTP,
                              child: const Text('Verify OTP'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Note : In case the OTP is not being delivered in SANDES App, you may try reinstalling the SANDES App from PlayStore/ AppStore & giving all the required permissions as requested, while installing the SANDES App.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: null,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
