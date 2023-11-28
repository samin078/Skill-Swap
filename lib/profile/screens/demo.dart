import 'package:flutter/material.dart';
import 'package:skill_swap/components/chat_user_card.dart';
import '../../api/apis.dart';
import '../../models/user.dart';

class Demo extends StatefulWidget {
  static String id = 'demo_screen';
  const Demo({Key? key}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  List<Users> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatUser"),
      ),
      body: StreamBuilder(
        stream: APIs.firestore.collection('user').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.waiting:
            case ConnectionState.none:
            return const Center(child: CircularProgressIndicator());

            //if some or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:

              final data = snapshot.data?.docs;
              list=data?.map((e) => Users.fromJson(e.data())).toList() ?? [];

              if(list.isNotEmpty) {
                return ListView.builder(
                    itemCount: list.length,
                    padding: EdgeInsets.only(top:10),
                    physics: const  BouncingScrollPhysics(),
                    itemBuilder: (context,index){
                      return ChatUserCard(
                        user: list[index],
                      );
                    }
                );
              }
              else {
                return Text("No connection Found!");
              }

          }


              // final data = snapshot.data?.docs;
              // list=data?.map((e) => User.fromJson(e.data())).toList() ?? [];
              // if(list.isNotEmpty){
              //   return ListView.builder(
              //       itemCount: _isSearching? searchList.length:list.length,
              //       padding: EdgeInsets.only(top: mq.height * 0.01),
              //       physics: BouncingScrollPhysics(),
              //       itemBuilder: (context, index) {
              //         return ChatUserCard(user:_isSearching? searchList[index]:list[index],);
              //         //return Text("State: ${list[index]}");
              //       });
              // }
              // else{
              //   return const Center(
              //     child: Text("No connection found!!", style: TextStyle(
              //       fontSize: 20,
              //     ),),
              //   );
              // }
        },
      ),
    );
  }
}
