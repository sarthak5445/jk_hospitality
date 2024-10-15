import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/submitform_model.dart';
import '../services/paymentinfo_service.dart';
import '../screens/booking_options.dart';
import '../models/paymentinfo_model.dart';

class EnteredDetailsScreen extends StatefulWidget {
  final ApiResponse apiResponse;

  const EnteredDetailsScreen({Key? key, required this.apiResponse})
      : super(key: key);

  @override
  _EnteredDetailsScreenState createState() => _EnteredDetailsScreenState();
}

class _EnteredDetailsScreenState extends State<EnteredDetailsScreen> {
  bool _isLoading = false;
  PaymentInfo? paymentInfo;
  bool _showPaymentInfo = false;

  @override
  Widget build(BuildContext context) {
    final bookingDetails = widget.apiResponse.bookingDetails;

    if (bookingDetails == null) {
      return const Center(child: Text("No booking details available."));
    }

    // Format the check-in and check-out dates
    String formattedCheckInDate = formatDate(bookingDetails.checkInDate);
    String formattedCheckOutDate = formatDate(bookingDetails.checkOutDate);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BookingOptions()),
          (Route<dynamic> route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Union Territory of Jammu and Kashmir'),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const BookingOptions()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heading Container
                  Container(
                    color: const Color.fromARGB(255, 4, 31, 62),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: const Center(
                      child: Text(
                        "Booking Details",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Grid view for displaying booking details
                  Expanded(
                    child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      children: [
                        buildResponsiveGridTile(
                            "Booking ID", bookingDetails.bookingId),
                        buildResponsiveGridTile(
                            "Guest House", bookingDetails.guestHouseName),
                        buildResponsiveGridTile("Name", bookingDetails.name),
                        buildResponsiveGridTile(
                            "Address", bookingDetails.address),
                        buildResponsiveGridTile(
                            "Phone No", bookingDetails.phoneNo),
                        buildResponsiveGridTile(
                            "Email ID", bookingDetails.emailId),
                        buildResponsiveGridTile(
                            "No. of Rooms", bookingDetails.noOfRooms),
                        buildResponsiveGridTile(
                            "Check-in Date", formattedCheckInDate),
                        buildResponsiveGridTile(
                            "Check-out Date", formattedCheckOutDate),
                        buildResponsiveGridTile(
                            "Booking Purpose", bookingDetails.bookingPurpose),
                        buildResponsiveGridTile("Government Servant",
                            bookingDetails.isGovtEmployee),
                        if (bookingDetails.isGovtEmployee == "Yes") ...[
                          buildResponsiveGridTile(
                              "Department", bookingDetails.department),
                          buildResponsiveGridTile(
                              "Designation", bookingDetails.designation),
                          buildResponsiveGridTile(
                              "ID Card No.", bookingDetails.idCardNo),
                          buildResponsiveGridTile(
                              "Gazetted Emp.", bookingDetails.isGazettedEmp),
                        ],
                      ],
                    ),
                  ),

                  // Elevated Button for Payment under grid view and above the note
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 2.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2196F3), Color(0xFF0D47A1)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: _showFloatingView,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "For Payment",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ),

                  // Note section under the button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "Sir/Madam, Your Booking Request with Booking-ID: ${bookingDetails.bookingId} "
                      "for Guest House ${bookingDetails.guestHouseName} has been submitted from "
                      "${formattedCheckInDate} to ${formattedCheckOutDate}. A confirmation will be sent to you "
                      "a day prior or on the same day of reservation.",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),

            // Show payment details layover
            if (_showPaymentInfo) _buildPaymentInfoLayover(context),
          ],
        ),
      ),
    );
  }

  // Show floating view with loading indicator
  void _showFloatingView() async {
    setState(() {
      _isLoading = true;
      _showPaymentInfo = true;
    });

    try {
      // Fetch payment info from API
      final response = await PaymentInfoService.fetchPaymentInfo(
          widget.apiResponse.bookingDetails!.bookingId);

      if (response != null) {
        setState(() {
          paymentInfo = PaymentInfo.fromJson(response['pd']);
          _isLoading = false;
        });
      } else {
        throw Exception("No payment info received.");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Show error in SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading payment info: $e"),
          backgroundColor: const Color.fromARGB(255, 104, 99, 98),
        ),
      );
    }
  }

  // Payment info layover view with a close button
  Widget _buildPaymentInfoLayover(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.9,
            child: Stack(
              children: [
                SingleChildScrollView(
                  // Wrap with SingleChildScrollView
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : paymentInfo != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                      "Payment To be Made in Following Account, only after the booking is confirmed.",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                      maxLines: 3,
                                    ),
                                    const SizedBox(height: 10),
                                    GridView(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        childAspectRatio: 4.5,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                      ),
                                      physics:
                                          const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                                      shrinkWrap:
                                          true, // Make GridView take up only the needed space
                                      children: [
                                        buildResponsiveGridTile(
                                            "Account Holder Name",
                                            paymentInfo!.accountHolderName),
                                        buildResponsiveGridTile(
                                            "Account Number",
                                            paymentInfo!.accountNumber),
                                        buildResponsiveGridTile(
                                            "Bank Name", paymentInfo!.bankName),
                                        buildResponsiveGridTile(
                                            "Branch", paymentInfo!.branchName),
                                        buildResponsiveGridTile(
                                            "IFSC", paymentInfo!.ifsc),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Center(
                                      child: buildQRImage(paymentInfo!
                                          .qrCode), // Moved QR outside the grid
                                    ),
                                  ])
                            : const Center(
                                child: Text("No payment info available")),
                  ),
                ),
                // Close button to close the floating view
                Positioned(
                  right: 10,
                  top: 10,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _showPaymentInfo = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for grid tiles with responsive height
  Widget buildResponsiveGridTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Colors.lightBlue[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Flexible(
            child: Text(
              value.isNotEmpty ? value : "N/A",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for formatting the date
  String formatDate(String date) {
    if (date.isEmpty) {
      return "N/A";
    }

    try {
      DateTime parsedDate = DateTime.parse(date);
      return "${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}";
    } catch (e) {
      return "Invalid date format";
    }
  }

  // Helper method for QR Code display
  Widget buildQRImage(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return const Text("QR Code not available");
    }
    final decodedBytes = base64Decode(base64String);
    return Image.memory(
      decodedBytes,
      width: MediaQuery.of(context).size.width *
          0.6, // Adjusted for responsiveness
      height: MediaQuery.of(context).size.height *
          0.3, // Adjusted for responsiveness
      fit: BoxFit.contain,
    );
  }
}
