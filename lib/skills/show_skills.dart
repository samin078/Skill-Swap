import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../database/database_methods.dart';

var userId = DatabaseMethods.userId;

class ShowSkills extends StatefulWidget {
  @override
  _ShowSkillsState createState() => _ShowSkillsState();
}

class _ShowSkillsState extends State<ShowSkills> {
  late Map<String, List<String>> skilledSkills;
  late Map<String, List<String>> unskilledSkills;

  @override
  void initState() {
    super.initState();
    skilledSkills = {};
    unskilledSkills = {};
    loadUserSkills();
  }

  Future<void> loadUserSkills() async {
    await loadSkills('skilled_in', skilledSkills);
    await loadSkills('unskilled_in', unskilledSkills);
    setState(() {});
  }

  Future<void> loadSkills(String collectionName, Map<String, List<String>> skillMap) async {
    try {
      final userRef = FirebaseFirestore.instance.collection("user_info").doc(userId);
      final skillsSnapshot = await userRef.collection(collectionName).get();

      for (var categorySnap in skillsSnapshot.docs) {
        final categoryName = categorySnap.id;
        final subSkillsSnapshot = await categorySnap.reference.collection("sub_skills").get();

        List<String> skills = subSkillsSnapshot.docs
            .map((subSkillDoc) => subSkillDoc.data()["name"] as String)
            .toList();

        skillMap[categoryName] = skills;
      }
    } catch (e) {
      print('Error loading $collectionName skills: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Skills'),
      ),
      body: skilledSkills.isEmpty && unskilledSkills.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          buildSkillSection('Skilled', skilledSkills),
          buildSkillSection('Unskilled', unskilledSkills),
        ],
      ),
    );
  }

  Widget buildSkillSection(String title, Map<String, List<String>> skills) {
    return ExpansionTile(
      title: Text(title),
      children: skills.keys.map((category) {
        return ExpansionTile(
          title: Text(category),
          children: skills[category]!
              .map((skill) => ListTile(title: Text(skill)))
              .toList(),
        );
      }).toList(),
    );
  }
}
