import 'package:flutter/material.dart';
import '../screens/bookingstatus_data.dart';
import '../services/bookingstatus_service.dart';
import '../models/bookingstatus_model.dart';

class BookingStatus extends StatefulWidget {
  const BookingStatus({super.key});

  @override
  _BookingStatusState createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus> {
  final TextEditingController _bookingIdController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    // Calculate button size based on screen width and height
    final buttonHeight = MediaQuery.of(context).size.height * 1 / 10;
    final buttonWidth = MediaQuery.of(context).size.width * 3 / 5;
    final textFieldHeight = MediaQuery.of(context).size.height * 1 / 14;

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
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Department of Hospitality & Protocol',
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    height: 1.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'مہمان نوازی اور پروٹوکول محکمہ',
                                  style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
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
              const SizedBox(height: 90),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                height: textFieldHeight,
                child: TextField(
                  controller: _bookingIdController,
                  decoration: InputDecoration(
                    labelText: 'Enter Booking ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              const SizedBox(height: 40), // Space between text field and button

              // Elevated Button with gradient background
              Center(
                child: SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                    ).copyWith(
                      elevation: ButtonStyleButton.allOrNull(0),
                      backgroundColor: WidgetStateProperty.resolveWith(
                        (states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.blue[900]; // Darker blue on press
                          }
                          return null;
                        },
                      ),
                    ),
                    onPressed: _isLoading ? null : _checkStatus,
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade900, // Dark blue
                            Colors.lightBlue.shade300, // Light blue
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Check Status',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
              const SizedBox(height: 40), // Space at the bottom
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkStatus() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset error message
    });

    try {
      final response = await BookingStatusService.fetchBookingStatus(
          _bookingIdController.text);
      if (response != null && response['rs'] == 'S') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingStatusData(
              bookingStatus: BookingStatusModel.fromJson(response['pd']),
            ),
          ),
        );
      } else {
        _showSnackBar('Booking ID not found.');
      }
    } catch (e) {
      _showSnackBar('Failed to check booking status');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
