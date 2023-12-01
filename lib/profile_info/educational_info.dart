import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/database/database_methods.dart';
import 'package:skill_swap/globals/navigation_menu.dart';
import '../helpers/helper_functions.dart';
import '../utils/constants/sizes.dart';

var loggedUserId = DatabaseMethods.userId;

class EducationInfoForm extends StatefulWidget {
  @override
  _EducationInfoFormState createState() => _EducationInfoFormState();
}

class _EducationInfoFormState extends State<EducationInfoForm> {
  final institutionController = TextEditingController();
  final degreeController = TextEditingController();
  final fieldOfStudyController = TextEditingController();
  final graduationYearController = TextEditingController();

  Future<void> saveEducationInfo() async {
    String institution = institutionController.text;
    String degree = degreeController.text;
    String fieldOfStudy = fieldOfStudyController.text;
    String graduationYear = graduationYearController.text;

    // Assuming the user's ID is available (e.g., from a logged-in user)
    String? userId = loggedUserId; // Replace with actual user ID

    // Reference to Firestore collection
    CollectionReference users =
        FirebaseFirestore.instance.collection('user_info');

    // Save data
    await users.doc(userId).set({
      'education': {
        'institution': institution,
        'degree': degree,
        'fieldOfStudy': fieldOfStudy,
        'graduationYear': graduationYear,
      },
    }, SetOptions(merge: true)); // Merge with existing data

    // Clear the text fields
    institutionController.clear();
    degreeController.clear();
    fieldOfStudyController.clear();
    graduationYearController.clear();
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
                  "Your Education Information",
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
                    // Institution Name
                    TextFormField(
                      controller: institutionController,
                      decoration: const InputDecoration(
                        labelText: "Instituition Name",
                        prefixIcon: Icon(Icons.book),
                      ),
                    ),
                    const SizedBox(
                      height: NSizes.spaceBtwInputFields,
                    ),
                    // Degree
                    TextFormField(
                      controller: degreeController,
                      decoration: const InputDecoration(
                        labelText: "Degree",
                        prefixIcon: Icon(Icons.book),
                      ),
                    ),
                    const SizedBox(
                      height: NSizes.spaceBtwInputFields,
                    ),
                    // Field of Study
                    TextFormField(
                      controller: fieldOfStudyController,
                      decoration: const InputDecoration(
                        labelText: "Field of Study",
                        prefixIcon: Icon(Icons.science),
                      ),
                    ),
                    const SizedBox(
                      height: NSizes.spaceBtwInputFields,
                    ),
                    // Graduation Year
                    TextFormField(
                      controller: graduationYearController,
                      decoration: const InputDecoration(
                        labelText: "Graduation Year",
                        prefixIcon: Icon(Icons.date_range),
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
                          saveEducationInfo();
                          Get.to(() => NavigationMenu());
                        },
                        child: const Text("Submit"),
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
