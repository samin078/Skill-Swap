import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../database/database_methods.dart';

late Size mq;

var userId = FirebaseAuth.instance.currentUser?.uid;

class UserProfile extends StatefulWidget {
  static String id = 'user_profile_screen';
  const UserProfile({Key? key}) : super(key: key);


  @override
  State<UserProfile> createState() => _UserProfileState();

}

class _UserProfileState extends State<UserProfile> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  File? _imageFile;
  String? _userImageUrl;

  Future<void> loadUserData() async {
    //await DatabaseMethods();
    try {
      // Replace 'user_info' with the actual collection name in Firestore
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('user_info').doc(userId).get();
      //print(userSnapshot.data()?['email']);

      if (userSnapshot.exists) {
        setState(() {
          // Update _userImageUrl with the user's image URL
          _userImageUrl = userSnapshot.data()?['image'];
          print(_userImageUrl);
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    DatabaseMethods().getUId();
    _initializeUserProfile();
  }

  void _initializeUserProfile() {
    DatabaseMethods().getUserId2().then((_) {
      Future.delayed(Duration(milliseconds: 200), () {
        loadUserData();
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile Screen"),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: mq.height * .07),
                Stack(
                  children: [
                    // Profile picture
                    _buildProfilePicture(),

                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: MaterialButton(
                        onPressed: () {
                          _showBottomSheet();
                        },
                        elevation: 1,
                        color: Colors.white,
                        shape: CircleBorder(),
                        child: Icon(Icons.edit, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: mq.height * .04),
                MaterialButton(
                    onPressed: (){},
                  child: Text(
                    "Update",
                  ),
                ),
                // Rest of your form fields
                // ...
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    // return CircleAvatar(
    //   radius: mq.height * 0.1,
    //   backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
    //   backgroundColor: Colors.lightGreen,
    //   child: _imageFile == null
    //       ? Icon(CupertinoIcons.person, color: Colors.white)
    //       : null,
    // );
    print(userId);
    return CircleAvatar(
      radius: mq.height * 0.1,
      //backgroundImage:  _userImageUrl != null ? NetworkImage(_userImageUrl!) : null,
      backgroundColor: Colors.lightGreen,
      child: _imageFile == null
          ? Icon(CupertinoIcons.person, color: Colors.white)
          : null,
    );

  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(
            top: mq.height * .03,
            bottom: mq.height * .05,
          ),
          children: [
            const Text(
              "Pick Profile Picture",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: mq.height * .02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    _pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  child: Image.asset("assets/add_image.jpeg"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: Size(mq.width * .3, mq.height * .15),
                    shape: CircleBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    _pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  child: Image.asset("assets/camera.jpeg"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: Size(mq.width * .3, mq.height * .15),
                    shape: CircleBorder(),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });

      // Upload the image to Firebase Storage
      _uploadImageToFirebaseStorage(image.path);
      //print("database error");
    }
  }

  Future<void> _uploadImageToFirebaseStorage(String filePath) async {
    try {
      final storage = FirebaseStorage.instance;

      // Check if userId is not null
      if (userId != null) {
        final String fileName = userId!; // Use a unique identifier for the filename
        final Reference storageReference = storage.ref().child('$filePath/$fileName.jpg');

        final UploadTask uploadTask = storageReference.putFile(File(filePath));

        await uploadTask.whenComplete(() async {
          // Get the download URL from Firebase Storage
          final String imageUrl = await storageReference.getDownloadURL();
          print('Image URL: $imageUrl');

          // Update the user's profile image URL in the database
          await updateUserProfileImage(userId!, imageUrl);

          // Update the local state or notify the UI if needed

          // Print a message or perform additional actions if needed
          print('Image uploaded and database updated successfully');
        });
      } else {
        print('Error: userId is null');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> updateUserProfileImage(String userId, String imageUrl) async {
    try {
      // Assuming you have a 'users' collection in Firestore
      final CollectionReference usersCollection = FirebaseFirestore.instance.collection('user_info');

      // Update the user's profile image URL
      await usersCollection.doc(userId).update({
        'image': imageUrl,
      });

      print('User profile image updated successfully');
    } catch (e) {
      print('Error updating user profile image: $e');
    }
  }

}
