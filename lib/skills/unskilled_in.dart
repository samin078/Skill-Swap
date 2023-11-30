import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skill_swap/skills/show_skills.dart';
import '../database/database_methods.dart';

var userId = DatabaseMethods.userId;

class UnskilledInScreen extends StatefulWidget {
  static String id = 'unskilled_in_screen';

  const UnskilledInScreen({Key? key}) : super(key: key);

  @override
  State<UnskilledInScreen> createState() => _UnskilledInScreenState();
}

class _UnskilledInScreenState extends State<UnskilledInScreen> {
  late Map<String, List<Map<String, dynamic>>> skillsByCategory;

  @override
  void initState() {
    super.initState();
    DatabaseMethods().getUId();
    skillsByCategory = {};
    loadSkillsFromFirestore();
  }

  Future<Map<String, Set<String>>> loadSelectedSkills() async {
    Map<String, Set<String>> selectedSkills = {};

    try {
      final userRef = FirebaseFirestore.instance.collection("user_info").doc(userId);
      final skilledInSnapshot = await userRef.collection("unskilled_in").get();

      for (var categoryDoc in skilledInSnapshot.docs) {
        final categoryName = categoryDoc.id;
        final subSkillsSnapshot = await categoryDoc.reference.collection("sub_skills").get();

        selectedSkills[categoryName] = Set.from(
          subSkillsSnapshot.docs.map((doc) => doc.data()["name"]),
        );
      }
    } catch (e) {
      print('Error loading selected skills: $e');
    }

    return selectedSkills;
  }


  Future<void> loadSkillsFromFirestore() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection("main_categories").get();
      Map<String, List<Map<String, dynamic>>> tempSkillsByCategory = {};

      // Load the user's previously selected skills
      Map<String, Set<String>> userSelectedSkills = await loadSelectedSkills();

      for (final doc in querySnapshot.docs) {
        String categoryId = doc.id;
        String categoryName = doc.data()["name"];

        final subSkillsSnapshot = await doc.reference.collection("sub_skills").get();
        final skillList = subSkillsSnapshot.docs
            .map((subDoc) {
          String skillName = subDoc.data()["name"];
          return {
            "name": skillName,
            "isChecked": userSelectedSkills[categoryName]?.contains(skillName) ?? false,
          };
        })
            .toList();

        tempSkillsByCategory[categoryName] = skillList;
      }

      setState(() {
        skillsByCategory = tempSkillsByCategory;
      });
    } catch (e) {
      print('Error loading skills: $e');
    }
  }



  Future<void> updateSelectedSkillsInFirestore() async {
    try {
      final userRef = FirebaseFirestore.instance.collection("user_info").doc(userId);

      // Iterate over each category and skill to update Firestore
      for (var category in skillsByCategory.keys) {
        for (var skill in skillsByCategory[category]!) {
          if (skill["isChecked"]) {
            await userRef.collection("unskilled_in").doc(category).set({
              'name': category,
            });
            await userRef.collection("unskilled_in").doc(category).collection("sub_skills").doc(skill["name"]).set({
              'name': skill["name"],
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
    List<String> categories = skillsByCategory.keys.toList();

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Interested In'),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabs: categories.map((category) => Tab(text: category)).toList(),
          ),
        ),
        body:TabBarView(
          children: categories.map((category) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Please Choose the ones you are interested in:",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    ...skillsByCategory[category]!.map((skill) {
                      return CheckboxListTile(
                        title: Text(skill["name"]),
                        value: skill["isChecked"],
                        onChanged: (bool? value) {
                          setState(() {
                            skill["isChecked"] = value ?? false;
                          });
                        },
                      );
                    }).toList(),
                    SizedBox(height: 20),
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
