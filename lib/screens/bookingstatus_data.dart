import 'package:flutter/material.dart';
import '../models/bookingstatus_model.dart';

class BookingStatusData extends StatelessWidget {
  final BookingStatusModel bookingStatus;

  const BookingStatusData({super.key, required this.bookingStatus});

  @override
  Widget build(BuildContext context) {
    String formattedCheckInDate = formatDate(bookingStatus.checkInDate);
    String formattedCheckOutDate = formatDate(bookingStatus.checkOutDate);
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Union Territory of Jammu and Kashmir'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color.fromARGB(255, 4, 31, 62), // Dark blue color
              width: double.infinity, // Make the container full width
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 16), // Increased vertical padding
              child: const Center(
                child: Text(
                  "Booking Status Details",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(
                          255, 255, 255, 255)), // White text color
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildDetailRow('Booking ID:', bookingStatus.bookingID),
                  _buildDetailRow('Status:', bookingStatus.bookingStatus),
                  _buildDetailRow('Guest Name:', bookingStatus.guestName),
                  _buildDetailRow('Contact No:', bookingStatus.guestContactNo),
                  _buildDetailRow('Guest House:', bookingStatus.guestHouse),
                  _buildDetailRow('Room Type:', bookingStatus.roomType),
                  _buildDetailRow('Booking Type:', bookingStatus.bookingType),
                  _buildDetailRow('Check-In Date:', formattedCheckInDate),
                  _buildDetailRow('Check-Out Date:', formattedCheckOutDate),
                  _buildDetailRow(
                      'Department (Govt. Emp.):', bookingStatus.department),
                  _buildDetailRow(
                      'Designation (Govt. Emp.):', bookingStatus.designation),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(8.0), // Rounded corners for the card
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 25, 66, 161)),
              ),
            ),
            Expanded(
              child: Text(
                value.isEmpty ? 'N/A' : value,
                style: const TextStyle(color: Colors.black),
                maxLines: 2,
              ),
            ), // Display 'N/A' for empty values
          ],
        ),
      ),
    );
  }

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
}
