import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skill_swap/skills/show_skills.dart';
import '../database/database_methods.dart';


var userId = DatabaseMethods.userId;

class SkilledInScreen extends StatefulWidget {
  static String id = 'skilled_in_screen';

  const SkilledInScreen({Key? key}) : super(key: key);

  @override
  State<SkilledInScreen> createState() => _SkilledInScreenState();
}

class _SkilledInScreenState extends State<SkilledInScreen> {
  late List<String> skillCategories;
  late Map<String, List<Map<String, dynamic>>> skillsByCategory;

  List<Map<String, dynamic>> selectedCategories = [];



  @override
  void initState() {
    super.initState();
     // Make sure to set the userId properly
    DatabaseMethods().getUId();
    // Initialize skill categories and skillsByCategory
    skillCategories = [];
    skillsByCategory = {};

    // Load user's selected skills from Firestore
    //loadSelectedSkills();
    // Load skills from Firestore
    loadSkillsFromFirestore();
  }

  // Function to load user's selected skills from Firestore
  // Future<void> loadSelectedSkills() async {
  //   try {
  //     final userRef =
  //     FirebaseFirestore.instance.collection("user_info").doc(userId);
  //
  //     final selectedSkillsSnapshot =
  //     await userRef.collection("skilled_in").get();
  //
  //     selectedCategories = selectedSkillsSnapshot.docs.map((doc) {
  //       return {
  //         "name": doc["name"],
  //         "isChecked": doc["isChecked"],
  //       };
  //     }).toList();
  //
  //     // Set the isChecked property for the selected skills
  //     for (var category in skillCategories) {
  //       for (var skill in skillsByCategory[category]!) {
  //         final selectedSkill = selectedCategories.firstWhere(
  //               (selectedSkill) => selectedSkill["name"] == skill["name"],
  //           orElse: () => {"name": skill["name"], "isChecked": false},
  //         );
  //         skill["isChecked"] = selectedSkill["isChecked"];
  //       }
  //     }
  //
  //     setState(() {});
  //   } catch (e) {
  //     print('Error loading selected skills: $e');
  //   }
  // }

  // Load skills from Firestore
  Future<void> loadSkillsFromFirestore() async {
    try {
      final querySnapshot =
      await FirebaseFirestore.instance.collection("main_categories").get();

      skillsByCategory = {};

      for (final doc in querySnapshot.docs) {
        final categoryName = doc.id;
        final subSkillsSnapshot =
        await doc.reference.collection("sub_skills").get();

        final skillList = subSkillsSnapshot.docs
            .map((subDoc) => {
          "name": subDoc["name"],
          "isChecked": subDoc["isChecked"],
        })
            .toList();

        skillsByCategory[categoryName] = skillList;
      }

      // Set the skill categories
      skillCategories = skillsByCategory.keys.toList();

      setState(() {});
    } catch (e) {
      print('Error loading skills: $e');
    }
  }

  // Function to update user's selected skills in Firestore
  Future<void> updateSelectedSkillsInFirestore() async {
    try {
      final userRef = FirebaseFirestore.instance.collection("user_info").doc(userId);

      // Clear existing selected skills under the "categories" collection
      await userRef.collection("skilled_in").get().then(
            (snapshot) => snapshot.docs.forEach(
              (doc) => doc.reference.delete(),
        ),
      );

      // Add updated selected skills under the "categories" collection
      for (var category in skillCategories) {
        for (var skill in skillsByCategory[category]!) {
          if (skill["isChecked"]) {
            await userRef.collection("skilled_in").doc(category).collection("sub_skills").add({
              'name': skill["name"],
              'isChecked': skill["isChecked"],
            });
          }
        }
      }
      Fluttertoast.showToast(msg: 'Skills updated');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error updating skills: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: skillCategories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Skilled In'),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabs: skillCategories
                .map((category) => Tab(text: category))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: skillCategories.map((category) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Please Choose the ones you are skilled in:",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    Column(
                      children: skillsByCategory[category]!.map((skill) {
                        return CheckboxListTile(
                          activeColor: Colors.deepPurpleAccent,
                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          value: skill["isChecked"],
                          title: Text(skill["name"]),
                          onChanged: (val) {
                            setState(() {
                              skill["isChecked"] = val;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    Wrap(
                      children: skillsByCategory[category]!.map((skill) {
                        if (skill["isChecked"] == true) {
                          return Card(
                            elevation: 3,
                            color: Colors.deepPurpleAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    skill["name"],
                                    style:
                                    const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        skill["isChecked"] =
                                        !skill["isChecked"];
                                      });
                                    },
                                    child: const Icon(
                                      Icons.delete_forever_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Container();
                      }).toList(),
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Update user's selected skills in Firestore
                        await updateSelectedSkillsInFirestore();

                        // Navigate to the new screen passing the userId
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowSkills(),
                          ),
                        );
                      },
                      child: Text("Submit"),
                    ),

                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
