import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../database/database_methods.dart';

var cUserId = DatabaseMethods.userId;

class MatchedScreen extends StatefulWidget {
  final String selectedOption;
  final double sliderValue;

  const MatchedScreen(
      {Key? key, required this.selectedOption, required this.sliderValue})
      : super(key: key);

  @override
  State<MatchedScreen> createState() => _MatchedScreenState();
}

class _MatchedScreenState extends State<MatchedScreen> {
  Map<String, dynamic> nearbyUsers = {};
  List<Map<String, dynamic>> sortedNearbyUsers = [];

  List<String> currentUserSkilledCategories = [];

  Map<String, List<String>> nearbyUserUnskilledCategories = {};
  Map<String, List<String>> nearbyUsersTeachCategories = {};
  Map<String, List<String>> nearbyUserSkilledCategories = {};
  Map<String, List<String>> nearbyUsersLearnCategories = {};
  Map<String, List<String>> nearbyUsersPracticeCategories = {};


  String mode = "exchange";
  double range = 500.0;

  @override
  void initState() {
    super.initState();
   // DatabaseMethods().getUId();
    mode = widget.selectedOption.toLowerCase();
    range = widget.sliderValue.toDouble();
    fetchNearbyUsers();
  }

  Future<Map<String, List<String>>> getUserSkills(
      String userId, String collectionName) async {
    Map<String, List<String>> userSkills = {};
    try {
      final userRef =
          FirebaseFirestore.instance.collection("user_info").doc(userId);
      final skillsSnapshot = await userRef.collection(collectionName).get();

      for (var categorySnap in skillsSnapshot.docs) {
        final categoryName = categorySnap.id;
        final subSkillsSnapshot =
            await categorySnap.reference.collection("sub_skills").get();

        List<String> skills = subSkillsSnapshot.docs
            .map((subSkillDoc) => subSkillDoc.data()["name"] as String)
            .toList();

        userSkills[categoryName] = skills;
      }
    } catch (e) {
      print('Error loading $collectionName skills for user $userId: $e');
    }
    return userSkills;
  }

  Future<Map<String, List<String>>> getUserSkilledCategories(
      String userId) async {
    return await getUserSkills(userId, 'skilled_in');
  }

  Future<Map<String, List<String>>> getUserUnskilledCategories(
      String userId) async {
    return await getUserSkills(userId, 'unskilled_in');
  }

  Future<void> fetchNearbyUsers() async {
    //print(mode);
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection("user_info");
    double searchRadius = range;

    double currentUserLatitude = 0.0;
    double currentUserLongitude = 0.0;

    final cLocation = await DatabaseMethods().getUserLocation(cUserId!);
    currentUserLatitude = cLocation!.latitude;
    currentUserLongitude = cLocation.longitude;

    Map<String, dynamic> nearbyUsersMap = {};
    List<Map<String, dynamic>> nearbyUsersList = [];
    List<Map<String, dynamic>> exchangeUsersList = [];

    Map<String, List<String>> currentUserSkilledCategories =
        await getUserSkilledCategories(cUserId!);
    Map<String, List<String>> currentUserUnskilledCategories =
        await getUserUnskilledCategories(cUserId!);

    // Query all users without any location constraints
    QuerySnapshot querySnapshot = await usersCollection.get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      final nuserId = doc.id;
      final location = await DatabaseMethods().getUserLocation(nuserId);

      print(nuserId);
      if (location != null && cUserId != nuserId) {
        double userLatitude = location.latitude;
        double userLongitude = location.longitude;
        print(currentUserLatitude);
        print(currentUserLongitude);
        print(userLatitude);
        print(userLongitude);

        // Calculate the distance between the current user and the found user
        double distance = Geolocator.distanceBetween(
          currentUserLatitude,
          currentUserLongitude,
          userLatitude,
          userLongitude,
        );
        print(distance);

        // If the distance is within the specified radius and the matched list is not empty, add the user to the map
        if (distance <= searchRadius) {
          nearbyUsersList.add({
            'userId': nuserId,
            'latitude': userLatitude,
            'longitude': userLongitude,
            'distance': distance,
          });

          Map<String, List<String>> nearbyUserSkilledCategories =
              await getUserSkilledCategories(nuserId);
          Map<String, List<String>> nearbyUserUnskilledCategories =
              await getUserUnskilledCategories(nuserId);

          List<String> commonTeachCategories =
              []; // Categories where current user can teach
          List<String> commonLearnCategories =
              []; // Categories where current user can learn
          List<String> commonPracticeCategories = [];


          if (mode == "exchange") {
            // Iterate over current user's skilled categories and check against nearby user's unskilled categories
            currentUserSkilledCategories.forEach((category, skills) {
              if (nearbyUserUnskilledCategories.containsKey(category)) {
                // Find common skills in the category
                var commonSkills = skills
                    .where((skill) => nearbyUserUnskilledCategories[category]!
                        .contains(skill))
                    .toList();
                if (commonSkills.isNotEmpty) {
                  print(commonSkills);
                  commonTeachCategories.addAll(commonSkills);
                }
              }
            });

            // Iterate over current user's unskilled categories and check against nearby user's skilled categories
            currentUserUnskilledCategories.forEach((category, skills) {
              if (nearbyUserSkilledCategories.containsKey(category)) {
                // Find common skills in the category
                var commonSkills = skills
                    .where((skill) =>
                        nearbyUserSkilledCategories[category]!.contains(skill))
                    .toList();
                print(commonSkills);
                if (commonSkills.isNotEmpty) {
                  commonLearnCategories.addAll(commonSkills);
                }
              }
            });

            if (commonTeachCategories.isNotEmpty &&
                commonLearnCategories.isNotEmpty) {
              exchangeUsersList.add({
                'userId': nuserId,
                'distance': distance,
                'teachCategories': commonTeachCategories,
                'learnCategories': commonLearnCategories,
                'practiceCategories': commonPracticeCategories,
              });
            }
          } else if (mode == "learn") {
            // Iterate over current user's unskilled categories and check against nearby user's skilled categories
            currentUserUnskilledCategories.forEach((category, skills) {
              if (nearbyUserSkilledCategories.containsKey(category)) {
                // Find common skills in the category
                var commonSkills = skills
                    .where((skill) =>
                        nearbyUserSkilledCategories[category]!.contains(skill))
                    .toList();
                print(commonSkills);
                if (commonSkills.isNotEmpty) {
                  commonLearnCategories.addAll(commonSkills);
                }
              }
            });

            if (commonLearnCategories.isNotEmpty) {
              exchangeUsersList.add({
                'userId': nuserId,
                'distance': distance,
                'teachCategories': commonTeachCategories,
                'learnCategories': commonLearnCategories,
                'practiceCategories': commonPracticeCategories,
              });
            }
          } else if (mode == "teach") {
            // Iterate over current user's skilled categories and check against nearby user's unskilled categories
            currentUserSkilledCategories.forEach((category, skills) {
              if (nearbyUserUnskilledCategories.containsKey(category)) {
                // Find common skills in the category
                var commonSkills = skills
                    .where((skill) => nearbyUserUnskilledCategories[category]!
                        .contains(skill))
                    .toList();
                if (commonSkills.isNotEmpty) {
                  print(commonSkills);
                  commonTeachCategories.addAll(commonSkills);
                }
              }
            });

            if (commonTeachCategories.isNotEmpty) {
              exchangeUsersList.add({
                'userId': nuserId,
                'distance': distance,
                'teachCategories': commonTeachCategories,
                'learnCategories': commonLearnCategories,
                'practiceCategories': commonPracticeCategories,
              });
            }
          }else if (mode == "practice") {
            // Iterate over current user's skilled categories and check against nearby user's unskilled categories
            currentUserUnskilledCategories.forEach((category, skills) {
              if (nearbyUserUnskilledCategories.containsKey(category)) {
                // Find common skills in the category
                var commonSkills = skills
                    .where((skill) => nearbyUserUnskilledCategories[category]!
                    .contains(skill))
                    .toList();
                if (commonSkills.isNotEmpty) {
                  print(commonSkills);
                  commonPracticeCategories.addAll(commonSkills);
                }
              }
            });

            if (commonPracticeCategories.isNotEmpty) {
              exchangeUsersList.add({
                'userId': nuserId,
                'distance': distance,
                'teachCategories': commonTeachCategories,
                'learnCategories': commonLearnCategories,
                'practiceCategories': commonPracticeCategories,

              });
            }
          }

          // Update the UI with nearby user data
          setState(() {
            nearbyUserUnskilledCategories[nuserId] =
                nearbyUserUnskilledCategories[nuserId] ?? [];
            print(nearbyUserUnskilledCategories);
            nearbyUsersTeachCategories[nuserId] = commonTeachCategories;
            nearbyUserSkilledCategories[nuserId] =
                nearbyUserSkilledCategories[nuserId] ?? [];
            nearbyUsersLearnCategories[nuserId] = commonLearnCategories;
            nearbyUsersPracticeCategories[nuserId] = commonPracticeCategories;

          });
        }
      }

      // Sort the list by distance
      nearbyUsersList.sort((a, b) => a['distance'].compareTo(b['distance']));
      exchangeUsersList.sort((a, b) => a['distance'].compareTo(b['distance']));
    }
    setState(() {
      // sortedNearbyUsers = nearbyUsersList;
      sortedNearbyUsers = exchangeUsersList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Users'),
      ),
      body: ListView.builder(
        itemCount: sortedNearbyUsers.length,
        itemBuilder: (context, index) {
          String userId = sortedNearbyUsers[index]['userId'];
          double distance = sortedNearbyUsers[index]['distance'];
          List<String> teachCategories =
          sortedNearbyUsers[index]['teachCategories'];
          List<String> learnCategories =
          sortedNearbyUsers[index]['learnCategories'];
          List<String> practiceCategories =
          sortedNearbyUsers[index]['practiceCategories'];

          return ListTile(
            title: Text('User ID: $userId'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Distance: ${distance.toStringAsFixed(2)} meters'),
                Text('Can Teach: ${teachCategories.join(', ')}'),
                Text('Can Learn: ${learnCategories.join(', ')}'),
                Text('Can Practice: ${practiceCategories.join(', ')}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
