import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:validators/validators.dart' as validator;
import 'dart:io';
import 'dart:convert';
import 'package:jk_hospitality/models/roomtype_model.dart';
import 'package:jk_hospitality/services/roomtype_service.dart';
import 'package:jk_hospitality/models/bookingtype_model.dart';
import 'package:jk_hospitality/services/bookingtype_service.dart';
import 'package:jk_hospitality/models/boookingpurpose_model.dart';
import 'package:jk_hospitality/services/bookingpurpose_service.dart';
import '../services/submitform_service.dart';
import '../screens/entered_details.dart';

class GuesthouseForm extends StatefulWidget {
  final int guestHouseId;
  final String guestHouseName;

  const GuesthouseForm(
      {super.key, required this.guestHouseId, required this.guestHouseName});

  @override
  // ignore: library_private_types_in_public_api
  _GuesthouseFormState createState() => _GuesthouseFormState();
}

class _GuesthouseFormState extends State<GuesthouseForm> {
  String? _mobno = "";

  String? _roomType;
  int? _roomTypeId;
  List<RoomType> _roomTypes = [];

  String? _bookingType;
  int? _bookingTypeId;
  List<BookingType> _bookingTypes = [];

  String? _bookingPurpose;
  int? _bookingPurposeId;
  List<BookingPurpose> _bookingPurposes = [];

  void initState() {
    super.initState();
    // Use delayed navigation after splash screen
    _getmobno();
    _fetchRoomTypes();
    _fetchBookingTypes();
    _fetchBookingPurpose();
  }

  Future<void> _getmobno() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? mobno = prefs.getString('mob_no');

      //print("Is user logged in? $isLoggedIn");

      setState(() {
        _mobno = mobno;
      });
    } catch (e) {
      print("Error while checking login status: $e");
    }
  }

  Future<void> _fetchRoomTypes() async {
    try {
      List<RoomType> roomTypes =
          await RoomTypeService.fetchRoomTypes(widget.guestHouseId);
      setState(() {
        _roomTypes = roomTypes;
      });
    } catch (e) {
      print("Error fetching room types: $e");
    }
  }

  Future<void> _fetchBookingTypes() async {
    try {
      List<BookingType> bookingTypes =
          await BookingTypeService.fetchBookingTypes();
      setState(() {
        _bookingTypes = bookingTypes;
      });
    } catch (e) {
      print("Error fetching booking types: $e");
    }
  }

  Future<void> _fetchBookingPurpose() async {
    try {
      List<BookingPurpose> bookingPurposes =
          await BookingPurposeService.fetchBookingPurpose();
      setState(() {
        _bookingPurposes = bookingPurposes;
      });
    } catch (e) {
      print("Error fetching booking purposes: $e");
    }
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();

  bool _isGovtServant = false; // Default set to Yes
  bool _isGazettedOfficer = false; // Default set to No
  int _noOfRooms = 1;
  String? _uploadedFile_name;
  String? _uploadedFile_content;
  //comment for git

  Future<void> _pickFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.single.path!);
      final fileSize = await file.length();
      if (fileSize <= 2 * 1024 * 1024) {
        // check if the file size is less than or equal to 2MB
        setState(() {
          _uploadedFile_name = result.files.single.name;
          //_uploadedFile_content = base64Encode(await file.readAsBytes());
        });
        final fileBytes = await file.readAsBytes();
        _uploadedFile_content = base64Encode(fileBytes);
      } else {
        // Show message that file size should be less than 2MB
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The size of the PDF should be less than 2MB.'),
          ),
        );
      }
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  String getMaxRoomsText() {
    if (_roomTypeId != null) {
      if (_roomTypeId! % 2 != 0) {
        return '(max 15)';
      } else if (_roomTypeId! % 2 == 0) {
        return '(max 2)';
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    bool _isLoading = false;
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
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color.fromARGB(255, 4, 31, 62),
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenWidth * 0.03),
                child: Center(
                  child: Text(
                    widget.guestHouseName,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.048,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter your details',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Mobile No field
                    TextFormField(
                      controller: _mobileController..text = _mobno ?? '',
                      decoration:
                          const InputDecoration(labelText: 'Mobile No.'),
                      keyboardType: TextInputType.phone,
                      readOnly: true,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length != 10) {
                          return 'Please enter a valid mobile number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!validator.isEmail(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Address field
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Address'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Check-in date input
                    TextFormField(
                      controller: _checkInController,
                      decoration: const InputDecoration(
                        labelText: 'Check-in Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, _checkInController),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a check-in date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Check-out date input
                    TextFormField(
                      controller: _checkOutController,
                      decoration: const InputDecoration(
                        labelText: 'Check-out Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, _checkOutController),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a check-out date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          1.0, // Adjust the width as needed
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          value: _roomType,
                          hint: const Text('Select Type of Room'),
                          items: _roomTypes.map((roomType) {
                            return DropdownMenuItem(
                              value: roomType.roomType,
                              child: Text(
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03),
                                maxLines: 2,
                                roomType.roomType,
                                overflow: TextOverflow
                                    .ellipsis, // Ensure dropdown text is truncated
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _roomType = value;
                              _roomTypeId = _roomTypes
                                  .firstWhere((type) => type.roomType == value)
                                  .id;
                            });
                          },
                          decoration:
                              const InputDecoration(labelText: 'Room Type'),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a room type';
                            }
                            return null;
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return _roomTypes.map<Widget>((roomType) {
                              return Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.5),
                                child: Text(
                                  roomType.roomType,
                                  overflow: TextOverflow
                                      .ellipsis, // Ensure selected item text is truncated
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Number of Rooms input with dynamic suffix
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: _noOfRooms.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Number of Rooms',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the number of rooms';
                              }
                              int? number = int.tryParse(value);
                              if (_roomType == 'Room' &&
                                  (number == null ||
                                      number < 1 ||
                                      number > 15)) {
                                return 'Please enter a valid number (1-15)';
                              }
                              if (_roomType == 'Suite' &&
                                  (number == null ||
                                      number < 1 ||
                                      number > 2)) {
                                return 'Please enter a valid number (1-2)';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _noOfRooms = int.tryParse(value) ?? 1;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          getMaxRoomsText(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Are you a Govt. Servant (Dropdown)
                    DropdownButtonFormField<bool>(
                      value: _isGovtServant,
                      items: const [
                        DropdownMenuItem(value: true, child: Text('Yes')),
                        DropdownMenuItem(value: false, child: Text('No')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _isGovtServant = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Are you a Govt. Servant?',
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select an option';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // Additional fields visible only if Govt Servant is 'Yes'
                    if (_isGovtServant) ...[
                      TextFormField(
                        controller: _departmentController,
                        decoration:
                            const InputDecoration(labelText: 'Department'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your department';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      TextFormField(
                        controller: _designationController,
                        decoration:
                            const InputDecoration(labelText: 'Designation'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your designation';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // ID Card Number (Not Required)
                      TextFormField(
                        controller: _idCardController,
                        decoration:
                            const InputDecoration(labelText: 'ID Card No.'),
                      ),
                      const SizedBox(height: 10),

                      // Whether a Gazetted Officer (Dropdown)
                      DropdownButtonFormField<bool>(
                        value: _isGazettedOfficer,
                        items: const [
                          DropdownMenuItem(value: true, child: Text('Yes')),
                          DropdownMenuItem(value: false, child: Text('No')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _isGazettedOfficer = value!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Whether a Gazetted Officer?',
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),

                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          1.0, // Adjust the width as needed
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          value: _bookingType,
                          hint: const Text('Select Booking Type'),
                          items: _bookingTypes.map((bookingType) {
                            return DropdownMenuItem(
                              value: bookingType.bookingType,
                              child: Text(
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03),
                                bookingType.bookingType,
                                maxLines: 2,
                                overflow: TextOverflow
                                    .ellipsis, // Ensure dropdown text is truncated
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _bookingType = value;
                              _bookingTypeId = _bookingTypes
                                  .firstWhere(
                                      (type) => type.bookingType == value)
                                  .id;
                            });
                          },
                          decoration:
                              const InputDecoration(labelText: 'Booking Type'),
                          validator: (value) {
                            if (value == null) {
                              return 'Please Select Booking Type';
                            }
                            return null;
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return _bookingTypes.map<Widget>((bookingType) {
                              return Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.5),
                                child: Text(
                                  bookingType.bookingType,
                                  overflow: TextOverflow
                                      .ellipsis, // Ensure selected item text is truncated
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Booking Purpose dropdown
                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          1.0, // Adjust the width as needed
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          value: _bookingPurpose,
                          hint: const Text('Select Booking Purpose'),
                          items: _bookingPurposes.map((bookingPurpose) {
                            return DropdownMenuItem(
                              value: bookingPurpose.bookingPurpose,
                              child: Text(
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03),
                                bookingPurpose.bookingPurpose,
                                maxLines: 2,
                                overflow: TextOverflow
                                    .ellipsis, // Ensure dropdown text is truncated
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _bookingPurpose = value;
                              _bookingPurposeId = _bookingPurposes
                                  .firstWhere(
                                      (type) => type.bookingPurpose == value)
                                  .id;
                            });
                          },
                          decoration: const InputDecoration(
                              labelText: 'Booking Purpose'),
                          validator: (value) {
                            if (value == null) {
                              return 'Please Select Booking Purpose';
                            }
                            return null;
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return _bookingPurposes
                                .map<Widget>((bookingPurpose) {
                              return Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.5),
                                child: Text(
                                  bookingPurpose.bookingPurpose,
                                  overflow: TextOverflow
                                      .ellipsis, // Ensure selected item text is truncated
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Supporting document upload
                    if (_isGovtServant)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Upload Supporting Document:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: _pickFile,
                            child: Container(
                              width: screenWidth * 0.6, // Increased width
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  _uploadedFile_name == null
                                      ? 'Choose File'
                                      : 'File Selected: $_uploadedFile_name',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),

                    // Submit Button
                    SizedBox(
                      width: screenWidth * 0.6, // Increased width
                      child: ElevatedButton.icon(
                        onPressed: _isLoading // Disable button if loading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  // Check if the uploaded file is required
                                  if (_isGovtServant &&
                                      _uploadedFile_name == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Please upload the supporting document.'),
                                      ),
                                    );
                                    return;
                                  }

                                  // Check date validation
                                  if (DateTime.parse(_checkInController.text)
                                      .isAfter(DateTime.parse(
                                          _checkOutController.text))) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Check-in date should be before Check-out date.'),
                                      ),
                                    );
                                    return;
                                  }

                                  // Set loading state to true before starting the submission
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  try {
                                    int _guest_house_id = widget.guestHouseId;
                                    String _name = _nameController.text;
                                    String _address = _addressController.text;
                                    String _desig = _designationController.text;
                                    String _dept = _departmentController.text;
                                    String _id_card_no = _idCardController.text;
                                    String _is_govt_serv =
                                        _isGovtServant ? "Yes" : "No";
                                    String _is_gazetted =
                                        _isGazettedOfficer ? "Yes" : "No";
                                    String _phn_no = _mobno ?? "";
                                    String _email = _emailController.text;
                                    String _room_type_id =
                                        _roomTypeId.toString();
                                    DateTime _check_in =
                                        DateTime.parse(_checkInController.text);
                                    DateTime _check_out = DateTime.parse(
                                        _checkOutController.text);
                                    String _doc_name = _uploadedFile_name ?? "";
                                    String _doc_ext = "pdf";
                                    String _doc_content =
                                        _uploadedFile_content ?? "";
                                    String _booking_purpose =
                                        _bookingPurpose ?? "";
                                    String _booking_type_id =
                                        _bookingTypeId.toString();
                                    int _no_of_rooms = _noOfRooms;

                                    // Call the submit service
                                    final response = await SubmitFormService()
                                        .submitBookingForm(
                                      guestHouseId: _guest_house_id,
                                      name: _name,
                                      address: _address,
                                      designation: _desig,
                                      department: _dept,
                                      idCardNo: _id_card_no,
                                      isGovtEmployee: _is_govt_serv,
                                      isGazettedEmployee: _is_gazetted,
                                      phoneNo: _phn_no,
                                      emailId: _email,
                                      roomTypeId: _room_type_id,
                                      checkInDate: _check_in.toString(),
                                      checkOutDate: _check_out.toString(),
                                      docName: _doc_name,
                                      docExt: _doc_ext,
                                      docContent: _doc_content,
                                      bookingPurpose: _booking_purpose,
                                      bookingTypeId: _booking_type_id,
                                      noOfRooms: _no_of_rooms,
                                    );

                                    setState(() {
                                      _isLoading = false;
                                    });

                                    // Handle the response
                                    if (response.status == 'S') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EnteredDetailsScreen(
                                                  apiResponse: response),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Error: Failed to submit or check your internet"),
                                        ),
                                      );
                                    }
                                  } catch (error) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Error: Server Error or check your internet'),
                                      ),
                                    );
                                  }
                                }
                              },
                        icon: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0, // Smaller loading icon
                                ),
                              )
                            : const Icon(Icons.arrow_forward),
                        label: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
