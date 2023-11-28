import 'package:flutter/material.dart';

import '../models/user.dart';




class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  final Users user;
  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
 // late List<Message> _list = [];
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold();
    // return SafeArea(
    //   child: Scaffold(
    //     appBar: AppBar(
    //       automaticallyImplyLeading: false,
    //       flexibleSpace: _appBar(),
    //     ),
    //     backgroundColor: Color.fromARGB(255, 234, 248, 255),
    //     body: Column(
    //       children: [
    //         Expanded(
    //           child: StreamBuilder(
    //             stream: APIs.getAllMessages(widget.user),
    //             builder: (context, snapshot) {
    //               switch (snapshot.connectionState) {
    //                 case ConnectionState.waiting:
    //                 case ConnectionState.none:
    //                   return const SizedBox();
    //
    //               //if some or all data is loaded then show it
    //                 case ConnectionState.active:
    //                 case ConnectionState.done:
    //                 //
    //                   final data = snapshot.data?.docs;
    //                   //print('Data: ${jsonEncode(data![0].data())}');
    //                   _list=data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
    //
    //                   if (_list.isNotEmpty) {
    //                     return ListView.builder(
    //                         padding: EdgeInsets.only(top: mq.height * 0.01),
    //                         physics: BouncingScrollPhysics(),
    //                         itemCount: _list.length,
    //                         itemBuilder: (context, index) {
    //                           return MessageCard(
    //                             message: _list[index],
    //                           );
    //                         });
    //                   } else {
    //                     return const Center(
    //                       child: Text(
    //                         "Say Hii 👋🏼",
    //                         style: TextStyle(
    //                           fontSize: 20,
    //                         ),
    //                       ),
    //                     );
    //                   }
    //               }
    //             },
    //           ),
    //         ),
    //         _chatInput(),
    //       ],
    //     ),
    //   ),
    // );
  }

  // Widget _appBar() {
  //   return InkWell(
  //     onTap: () {},
  //     child: Row(
  //       children: [
  //         IconButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           icon: Icon(
  //             Icons.arrow_back,
  //             color: Colors.black54,
  //           ),
  //         ),
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(mq.height * .3),
  //           child: CachedNetworkImage(
  //             height: mq.height * .055,
  //             width: mq.width * .055,
  //             imageUrl: widget.user.image,
  //             placeholder: (context, url) => const CircularProgressIndicator(),
  //             errorWidget: (context, url, error) => const CircleAvatar(
  //               backgroundColor: Colors.lightGreen,
  //               child: Icon(
  //                 CupertinoIcons.person,
  //               ),
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           width: 11.0,
  //         ),
  //         Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               widget.user.name,
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 color: Colors.black87,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //             SizedBox(
  //               height: 2,
  //             ),
  //             Text(
  //               "Last Text not available",
  //               style: TextStyle(
  //                 fontSize: 13,
  //                 color: Colors.black54,
  //                 //fontWeight: FontWeight.w500,
  //               ),
  //             )
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Widget _chatInput() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //         vertical: mq.height * .01, horizontal: mq.width * .025),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Card(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(15),
  //             ),
  //             child: Row(
  //               children: [
  //                 //emoji button
  //                 IconButton(
  //                   onPressed: () {},
  //                   icon: const Icon(
  //                     Icons.emoji_emotions,
  //                     color: Colors.blueAccent,
  //                     size: 25,
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: TextField(
  //                     keyboardType: TextInputType.multiline,
  //                     controller: _textController,
  //                     maxLines: null,
  //                     decoration: InputDecoration(
  //                       hintText: "Type Something...",
  //                       hintStyle: TextStyle(
  //                         color: Colors.blueAccent,
  //                       ),
  //                       border: InputBorder.none,
  //                     ),
  //                   ),
  //                 ),
  //                 IconButton(
  //                   onPressed: () {},
  //                   icon: const Icon(
  //                     Icons.image,
  //                     color: Colors.blueAccent,
  //                     size: 26,
  //                   ),
  //                 ),
  //                 IconButton(
  //                   onPressed: () {},
  //                   icon: const Icon(
  //                     Icons.camera_alt_rounded,
  //                     color: Colors.blueAccent,
  //                     size: 26,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: mq.width * .02,
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //         //send message button
  //         MaterialButton(
  //           onPressed: () {
  //             if(_textController.text.isNotEmpty){
  //               APIs.sendMessage(widget.user, _textController.text,Type.text);
  //               _textController.text='';
  //             }
  //           },
  //           shape: CircleBorder(),
  //           child: Icon(
  //             Icons.send,
  //             color: Colors.white,
  //             size: 28,
  //           ),
  //           color: Colors.green,
  //           padding: EdgeInsets.only(top: 10.0, bottom: 10, right: 5, left: 10),
  //           minWidth: 0,
  //         )
  //       ],
  //     ),
  //   );
  // }
}
