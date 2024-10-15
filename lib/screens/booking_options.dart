import 'package:flutter/material.dart';
import 'package:jk_hospitality/screens/guesthouse_list.dart';
import 'package:jk_hospitality/screens/booking_status.dart';

class BookingOptions extends StatelessWidget {
  const BookingOptions({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate button size based on screen width and height
    final buttonHeight = MediaQuery.of(context).size.height * 1 / 10;
    final buttonWidth = MediaQuery.of(context).size.width * 3 / 5;

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
              const SizedBox(height: 90),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // New Booking Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () =>
                          _hotel_list(context), // Action for button
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero, // Removes default padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              16.0), // Match container's border radius
                        ),
                        elevation: 5, // Adds shadow for raised effect
                      ),
                      child: Container(
                        height: buttonHeight,
                        width: buttonWidth,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF2196F3), // Blue
                              Color(0xFF0D47A1), // Dark Blue
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(""), // Add space for alignment
                            const Text(
                              "New Booking",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.arrow_right_alt_outlined,
                                size: 25.0,
                                color:
                                    Color(0xFF0D47A1), // Dark Blue for the icon
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Booking History Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () =>
                          _booking_status(context), // Action for button
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero, // Removes default padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              16.0), // Match container's border radius
                        ),
                        elevation: 5, // Adds shadow for raised effect
                      ),
                      child: Container(
                        height: buttonHeight,
                        width: buttonWidth,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF2196F3), // Blue
                              Color(0xFF0D47A1), // Dark Blue
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(""), // Add space for alignment
                            const Text(
                              "Booking Status",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.arrow_right_alt_outlined,
                                size: 25.0,
                                color:
                                    Color(0xFF0D47A1), // Dark Blue for the icon
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _booking_status(BuildContext context) async {
    Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const BookingStatus()));
  }
}

// ignore: non_constant_identifier_names
_hotel_list(BuildContext context) async {
  Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const GuestHouseListScreen()));
}
