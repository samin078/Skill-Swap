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
  late Map<String, List<Map<String, dynamic>>> skillsByCategory;
  late Map<String, List<Map<String, dynamic>>> interestedInSkills;

  @override
  void initState() {
    super.initState();
    DatabaseMethods().getUId();
    skillsByCategory = {};
    interestedInSkills = {};
    loadSkillsFromFirestore();
    //loadInterestedInSkills();
  }


  bool isSkillAlreadySelected(String skillName, Map<String, Set<String>> otherCategorySkills) {
    for (var categorySkills in otherCategorySkills.values) {
      if (categorySkills.contains(skillName)) {
        return true;
      }
    }
    return false;
  }



  Future<void> loadInterestedInSkills() async {
    Map<String, Set<String>> tempInterestedInSkills = {};

    try {
      final userRef = FirebaseFirestore.instance.collection("user_info").doc(userId);
      final interestedInSnapshot = await userRef.collection("unskilled_in").get();

      for (var categoryDoc in interestedInSnapshot.docs) {
        final categoryName = categoryDoc.id;
        final subSkillsSnapshot = await categoryDoc.reference.collection("sub_skills").get();

        tempInterestedInSkills[categoryName] = Set.from(
          subSkillsSnapshot.docs.map((doc) => doc.data()["name"]),
        );
      }

      setState(() {
        interestedInSkills = tempInterestedInSkills.cast<String, List<Map<String, dynamic>>>();
      });
    } catch (e) {
      print('Error loading interested in skills: $e');
    }
  }




  Future<Map<String, Set<String>>> loadSelectedSkills() async {
    Map<String, Set<String>> selectedSkills = {};

    try {
      final userRef = FirebaseFirestore.instance.collection("user_info").doc(userId);
      final skilledInSnapshot = await userRef.collection("skilled_in").get();

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
            await userRef.collection("skilled_in").doc(category).set({
              'name': category,
            });
            await userRef.collection("skilled_in").doc(category).collection("sub_skills").doc(skill["name"]).set({
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
          title: const Text('Skilled In'),
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
                      "Please Choose the ones you are skilled in:",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    ...skillsByCategory[category]!.map((skill) {
                      bool isInInterestedList = isSkillAlreadySelected(skill["name"], interestedInSkills.cast<String, Set<String>>());
                      print(isInInterestedList.toString());
                     // print(skill);
                      return CheckboxListTile(
                        title: Text(skill["name"]),
                        value: skill["isChecked"],
                        onChanged: (bool? value) {
                          
                          setState(() {
                            skill["isChecked"] = value ?? false;
                          });
                        },

                        activeColor: isInInterestedList ? Colors.red : null,  // Apply red color if in "Interested In" list
                        checkColor: isInInterestedList ? Colors.white : null, // Ensure the check mark is visible on red background
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
