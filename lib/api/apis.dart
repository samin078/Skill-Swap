import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user.dart';



class APIs {
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  //for accessing firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  //for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //for storing self information
  static late Users me;

  //to return current user
  static User get user => auth.currentUser!;

  //for checking if user exists or not
  static Future<bool> userExists() async {
    return (await firestore.collection('user').doc(user.uid).get()).exists;
  }

  //for checking current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = Users.fromJson(user.data()!);
      } else {
          //await createUser().then((value) => getSelfInfo());

      }
    });
  }

  // static Future<void> createUser ({
  //   required String userId,
  //   required String pushToken,
  //   required String image,
  //   required String email,
  //   required String about,
  //   required String name,
  //   required bool isOnline,
  //   required String phoneNo,
  //   required String occupation,
  //   required String gender,
  //   required String dateOfBirth,
  // }) async {
  //   final time = DateTime.now().microsecondsSinceEpoch.toString();
  //   final chatUser = Users(
  //     id: userId,
  //     createdAt: time,
  //     pushToken: pushToken,
  //     image: image,
  //     email: email,
  //     about: about,
  //     lastActive: time,
  //     name: name,
  //     isOnline: isOnline,
  //     phoneNo: phoneNo,
  //     occupation: occupation,
  //     gender: gender,
  //     dateOfBirth: dateOfBirth,
  //   );
  //   return await firestore
  //       .collection('user')
  //       .doc(user.uid)
  //       .set(chatUser.toJson());
  // }

  //for getting all users from firebase database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // static Future<void> updateUserInfo() async {
  //   await firestore.collection('users').doc(user.uid).update({
  //     'name': me.name,
  //     'about': me.about,
  //   });
  // }

  //update profile picture of user
  // static Future<void> updateProfilePicture(File file) async {
  //   final ext = file.path.split('.').last;
  //   final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
  //   await ref
  //       .putFile(file, SettableMetadata(contentType: 'image/$ext'))
  //       .then((p0) {
  //     print("Data transferred: ${p0.bytesTransferred / 1000} kb");
  //   });
  //   me.image = await ref.getDownloadURL();
  //   await firestore.collection('users').doc(user.uid).update({
  //     'image': me.image,
  //   });
  // }

  //chatscreen related APIs

  //useful for getting conversation id
  // static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
  //     ? '${user.uid}_$id'
  //     : '${id}_${user.uid}';
  // // for getting all messages of a specific conversation from firestore database
  // static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
  //     ChatUser user) {
  //   return firestore
  //       .collection('chats/${getConversationID(user.id)}/messages/')
  //       .orderBy('sent', descending: true)
  //       .snapshots();
  // }

  //for sending message
  // static Future<void> sendMessage(ChatUser chatUser, String msg,Type type) async{
  //   //message sending time (also used as id)
  //   final time = DateTime.now().millisecondsSinceEpoch.toString();
  //   //message to send
  //   final Message message = Message(
  //       toId: chatUser.id,
  //       msg: msg,
  //       read: '',
  //       type: type,
  //       fromId: user.uid,
  //       sent: time);
  //   final ref = firestore
  //       .collection('chats/${getConversationID(chatUser.id)}/messages/');
  //   await ref.doc(time).set(message.toJson());
  // }

//chats(collection)-->conversation_id)(doc)-->messages(collection)-->message(doc)

}