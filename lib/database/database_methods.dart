import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:firebase_auth/firebase_auth.dart';


final _firestore = FirebaseFirestore.instance;
late User loggedInUser;
final _auth = FirebaseAuth.instance;

class DatabaseMethods {
  static String? userId;
  Future addUserDetails(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("user_info")
        .doc(loggedInUser.uid)
        .set(userInfoMap);
  }

  Future<QuerySnapshot> getthisUserInfo(String name) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("First Name", isEqualTo: name)
        .get();
  }

  Future UpdateUserData(String age, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"Age": age});
  }

  Future DeleteUserData(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .delete();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser!;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.uid);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> getUserId() async {
    final user = await _auth.currentUser!;
    return user.uid;
  }

  Future<void> getUserId2() async {
    userId = await getUserId();
  }

  Future<String?> getUserEmail() async {
    final user = await _auth.currentUser!;
    return user.email;
  }

  void getUId() async {
    userId = await getUserId();
  }

  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('user_info')
          .doc(userId)
          .get();
      return userSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching user data: $e');
      return {};
    }
  }

  Future<List<Map<String, dynamic>>?> getSelectedCategories(
      String userId) async {
    try {
      final categoriesCollection = FirebaseFirestore.instance
          .collection("user_info")
          .doc(userId)
          .collection("categories");

      final categoriesSnapshot = await categoriesCollection.get();

      return categoriesSnapshot.docs
          .map((doc) => {
        'name': doc.get('name'),
        'isChecked': doc.get('isChecked'),
      })
          .toList();
    } catch (e) {
      print('Error fetching selected categories: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getSkilledCategories(
      String userId) async {
    try {
      final categoriesCollection = FirebaseFirestore.instance
          .collection("user_info")
          .doc(userId)
          .collection("skilled_in");

      final categoriesSnapshot = await categoriesCollection.get();

      return categoriesSnapshot.docs
          .map((doc) => {
        'name': doc.get('name'),
        'isChecked': doc.get('isChecked'),
      })
          .toList();
    } catch (e) {
      print('Error fetching selected categories: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getUnskilledCategories(
      String userId) async {
    try {
      final categoriesCollection = FirebaseFirestore.instance
          .collection("user_info")
          .doc(userId)
          .collection("unskilled_in");

      final categoriesSnapshot = await categoriesCollection.get();

      return categoriesSnapshot.docs
          .map((doc) => {
        'name': doc.get('name'),
        'isChecked': doc.get('isChecked'),
      })
          .toList();
    } catch (e) {
      print('Error fetching selected categories: $e');
      return null;
    }
  }



  // Function to add user's location to Firestore as a GeoPoint
  Future<void> addUserLocation(String userId, double latitude, double longitude) async {
    final userRef = FirebaseFirestore.instance.collection("user_info").doc(userId);
    await userRef.set({
      "location": GeoPoint(latitude, longitude),
    }, SetOptions(merge: true));
  }

// Function to retrieve user's location from Firestore
  Future<GeoPoint?> getUserLocation(String userId) async {
    final userRef = FirebaseFirestore.instance.collection("user_info").doc(userId);
    final userDoc = await userRef.get();

    // Check if the "location" field exists and is of type GeoPoint
    if (userDoc.exists && userDoc.data() != null && userDoc.data()!["location"] is GeoPoint) {
      final location = userDoc.data()!["location"] as GeoPoint;
      return location;
    } else {
      // Handle the case where the "location" field is not present or not of the expected type
      print("Error: Unable to fetch user location for user ID $userId");
      return null;
    }
  }



// Function to add user's location to Firestore as a Geohash
  Future<void> addUserGeoHash(String userId, double latitude, double longitude) async {
    final userRef = FirebaseFirestore.instance.collection("user_info").doc(userId);

    GeoHasher geoHasher = GeoHasher();
    // Calculate the geohash based on the latitude and longitude
    String geohash = geoHasher.encode(latitude, longitude, precision: 9); // Adjust precision as needed

    await userRef.set({
      "geohash": geohash,
    }, SetOptions(merge: true));
  }


  Future<String> getUserGeohash(String userId) async {
    final userRef = FirebaseFirestore.instance.collection("user_info").doc(userId);
    final userDoc = await userRef.get();
    return userDoc.data()!["geohash"] as String;
  }


  // Define a reference to the Firestore collection containing user information
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection("user_info");

  // Function to fetch all users from the Firestore database
  Future<List<DocumentSnapshot>> fetchAllUsers() async {
    try {
      // Query the Firestore collection to get all user documents
      QuerySnapshot querySnapshot = await userCollection.get();

      // Return the list of user documents
      return querySnapshot.docs;
    } catch (e) {
      // Handle any errors that may occur during the database query
      print("Error fetching users: $e");
      return [];
    }
  }




}
