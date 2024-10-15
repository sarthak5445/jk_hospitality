import 'package:flutter/material.dart';
import 'package:jk_hospitality/models/guesthouse_model.dart';
import 'package:jk_hospitality/services/guesthouselist_service.dart';
import 'package:jk_hospitality/screens/form.dart';

class GuestHouseListScreen extends StatefulWidget {
  const GuestHouseListScreen({Key? key}) : super(key: key);

  @override
  _GuestHouseListScreenState createState() => _GuestHouseListScreenState();
}

class _GuestHouseListScreenState extends State<GuestHouseListScreen> {
  late Future<List<GuestHouse>> _guestHouseList;

  @override
  void initState() {
    super.initState();
    _guestHouseList = GuesthouselistService.getGuestHousesList();
  }

  // Function to show Snackbar with a specific message
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Union Territory of Jammu and Kashmir'),
        ),
        //centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color.fromARGB(255, 4, 31, 62), // Dark blue color
              width: double.infinity, // Make the container full width
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 10), // Add vertical padding
              child: const Center(
                child: Text(
                  "Select a Guest House",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white), // White text color
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<GuestHouse>>(
                future: _guestHouseList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // If an error occurs, show a snackbar with the error message
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _showSnackbar(context,
                          'Error: Failed to Load. Check your connection or retry');
                    });
                    return const Center(
                        child: Text('Failed to load guest house data.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _showSnackbar(context, 'GuestHouse List is empty');
                    });
                    return const Center(
                        child: Text('No Guest Houses Available'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final guestHouse = snapshot.data![index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GuesthouseForm(
                                    guestHouseId: guestHouse.id,
                                    guestHouseName: guestHouse.guestHouseName),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: const Color.fromARGB(255, 63, 179, 232),
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Center(
                                child: Text(
                                  guestHouse.guestHouseName,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      // fontSize: 15,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      fontWeight: FontWeight.bold),
                                  maxLines:
                                      1, // Ensure the text fits in a single line
                                  overflow: TextOverflow
                                      .ellipsis, // Add ellipsis if the text is too long
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
