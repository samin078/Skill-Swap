import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../chat/chat_screen.dart';
import '../models/user.dart';



class ChatUserCard extends StatefulWidget {
  final Users user;
  const ChatUserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //Size mq = MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .04, vertical: 4),
      elevation: 1,
      //color: Colors.blue.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(user:widget.user)));
        },
        child: ListTile(
          leading: ClipRRect(
            borderRadius:BorderRadius.circular(MediaQuery.of(context).size.height * .6),
            child: CachedNetworkImage(
              height: MediaQuery.of(context).size.height * .055,
              width: MediaQuery.of(context).size.width * .055,
              imageUrl: widget.user.image!,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>const CircleAvatar(
                backgroundColor: Colors.lightGreen,
                radius: 40,
                child: Icon(
                  CupertinoIcons.person,
                  size: 30,
                ),
              ),
            ),
          ),

          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                color: Colors.greenAccent.shade400,
                borderRadius: BorderRadius.circular(10)
            ),

          ),
          // trailing: const Text(
          //   "12:00 pm",
          //   style: TextStyle(
          //     color: Colors.black54,
          //   ),
          // ),
          title: Text(widget.user.name),
          subtitle: Text(
            widget.user.about!,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}