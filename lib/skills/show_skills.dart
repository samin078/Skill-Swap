import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/database_methods.dart';


var userId = DatabaseMethods.userId;


class ShowSkills extends StatefulWidget {
  static String id = 'skilled_in_screen';

  const ShowSkills({Key? key}) : super(key: key);

  @override
  State<ShowSkills> createState() => _ShowSkillsState();
}

class _ShowSkillsState extends State<ShowSkills> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Skills'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("user_info")
            .doc(userId)
            .collection("skilled_in")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          var skillsList = snapshot.data?.docs.map((doc) {
            return {
              "category": doc.id as String,
              "skills": doc.reference.collection("sub_skills").snapshots(),
            };
          }).toList();

          // Your UI logic to display the skills list
          return ListView.builder(
            itemCount: skillsList?.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(skillsList?[index]["category"] as String),
                subtitle: StreamBuilder(
                  stream: skillsList?[index]["skills"],
                  builder: (context, subSnapshot) {
                    if (subSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (subSnapshot.hasError) {
                      return Text('Error: ${subSnapshot.error}');
                    }

                    var subSkillsList = subSnapshot.data?.docs.map((subDoc) {
                      return subDoc["name"] as String;
                    }).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: subSkillsList
                          ?.map((subSkill) => Text(subSkill))
                          .toList(),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
