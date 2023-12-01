import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:skill_swap/profile_info/educational_info.dart';

import '../database/database_methods.dart';
import '../helpers/helper_functions.dart';
import '../models/user.dart';
import '../utils/constants/sizes.dart';


var loggedUserId = DatabaseMethods.userId;

class PersonalInfoForm extends StatefulWidget {
  static String id = 'info_screen';
  const PersonalInfoForm({Key? key}) : super(key: key);

  @override
  _PersonalInfoFormState createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final List<String> _genderOptions = ['Male', 'Female', 'Others'];
  String? _selectedGender;
  DateTime? _selectedDate; // Variable to store the selected date
  String phoneNumber = '';
  String phoneIsoCode = '';
  File? _image;
  final picker = ImagePicker();

  TextEditingController _nidController = TextEditingController();
  TextEditingController _githubLinkController = TextEditingController();
  TextEditingController _linkedInLinkController = TextEditingController();
  TextEditingController _facebookLinkController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void onPhoneNumberChanged(PhoneNumber number) {
    setState(() {
      phoneNumber = number.phoneNumber ?? '';
      phoneIsoCode = number.isoCode ?? '';
    });
  }

  TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat.yMd()
            .format(picked); // Format the date and set it to the text field
      });
    }
  }

  void saveUserToDatabase() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print("No user logged in");
      return;
    }

    // Create an instance of Users with all the details
    Users user = Users(
      id: currentUser.uid,
      email: currentUser.email,
      phoneNo: phoneNumber, // From the phone number input
      gender: _selectedGender,
      dateOfBirth: _selectedDate != null ? DateFormat.yMd().format(_selectedDate!) : '',
      nidNo: _nidController.text,
      about: _aboutController.text,
      socialLink: SocialLink(
        github: _githubLinkController.text,
        linkedIn: _linkedInLinkController.text,
        facebook: _facebookLinkController.text,
      ),
      // Add other fields as required
    );

    // Convert the Users instance to JSON
    Map<String, dynamic> userData = user.toJson();

    try {
      // Save the data to Firestore
      await FirebaseFirestore.instance
          .collection('user_info')
          .doc(currentUser.uid)
          .set(userData, SetOptions(merge: true));

      print("User info saved successfully");
    } catch (e) {
      print("Error saving user info: $e");
    }
  }

  @override
  void initState() {
    DatabaseMethods().getUId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dark = NHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(NSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  "Tell Us More About Yourself",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(
                height: NSizes.spaceBtwSections,
              ),

              // Form
              Form(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage: _image != null ? FileImage(_image!) : null,
                        child: _image == null ? Icon(Icons.camera_alt, size: 50) : null,
                      ),
                    ),
                    const SizedBox(
                      height: NSizes.spaceBtwInputFields*2,
                    ),
                    /// Gender
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: const InputDecoration(
                        labelText: "Gender",
                        prefixIcon: Icon(Icons.transgender),
                      ),
                      items: _genderOptions.map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGender = newValue;
                        });
                      },
                    ),

                    const SizedBox(
                      height: NSizes.spaceBtwInputFields,
                    ),

                    ///Date of Birth
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        labelText: "Date of Birth",
                        prefixIcon: Icon(Icons.calendar_today), // Changed icon
                      ),
                      readOnly: true, // Make the text field read-only
                      onTap: () =>
                          _selectDate(context), // Open date picker on tap
                    ),
                    const SizedBox(
                      height: NSizes.spaceBtwInputFields,
                    ),

                    /// NID Card Number
                    TextFormField(
                      controller: _nidController,
                      decoration: const InputDecoration(
                        labelText: "NID Card Number",
                        prefixIcon: Icon(Icons.credit_card),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: NSizes.spaceBtwInputFields,
                    ),
                    // Phone Number
                    InternationalPhoneNumberInput(
                      onInputChanged: onPhoneNumberChanged,
                      maxLength: 11, // Set max length including country code
                      formatInput: false,
                      spaceBetweenSelectorAndTextField: 0,
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        setSelectorButtonAsPrefixIcon: true,
                        showFlags: false,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      initialValue: PhoneNumber(isoCode: 'BD'),
                      textFieldController: TextEditingController(),
                      keyboardType: TextInputType.phone,
                      inputBorder: const OutlineInputBorder(),

                    ),

                    const SizedBox(
                      height: NSizes.spaceBtwInputFields,
                    ),
                    // Github Link
                    TextFormField(
                      controller: _githubLinkController,
                      decoration: const InputDecoration(
                        labelText: "GitHub Link",
                        prefixIcon: Icon(Icons.code),
                      ),
                    ),
                    const SizedBox(
                      height: NSizes.spaceBtwInputFields,
                    ),
                    // LinkedIn Link
                    TextFormField(
                      controller: _linkedInLinkController,
                      decoration: const InputDecoration(
                        labelText: "LinkedIn Link",
                        prefixIcon: Icon(Icons.business),
                      ),
                    ),
                    const SizedBox(
                      height: NSizes.spaceBtwInputFields,
                    ),
                    // Facebook Link
                    TextFormField(
                      controller: _facebookLinkController,
                      decoration: const InputDecoration(
                        labelText: "Facebook Link",
                        prefixIcon: Icon(Icons.facebook),
                      ),
                    ),
                    const SizedBox(
                      height: NSizes.spaceBtwInputFields,
                    ),
                    // About Yourself
                    TextFormField(
                      controller: _aboutController,
                      maxLines: 5, // Allows for multi-line input
                      maxLength: 150, // Limits input to 150 characters
                      decoration: const InputDecoration(
                        labelText: "About Yourself",
                        alignLabelWithHint:
                            true, // Aligns label with the top for multiline text field
                        prefixIcon: Icon(Icons.person),
                        hintText: "Tell us something about yourself",
                      ),
                    ),
                    const SizedBox(
                      height: NSizes.spaceBtwSections,
                    ),
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Add your submission logic here
                          saveUserToDatabase();
                          Get.to(()=> EducationInfoForm());
                        },
                        child: const Text("Next"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: NSizes.defaultSpace,
              ),
            ],
          ),
        ),
      ),
    );
  }


}
