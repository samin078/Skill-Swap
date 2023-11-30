import 'package:flutter/material.dart';
import 'package:skill_swap/profile/screens/user_profile_screen.dart';
import 'package:skill_swap/skills/select_skill_mode.dart';
import 'package:skill_swap/skills/skilled_in.dart';
import '../api/apis.dart';
import '../location/user_location.dart';
import '../profile/screens/demo.dart';


class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            onPressed: (){
             // Navigator.pushNamed(context, UserProfile.id);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => UserProfile()
                  )
              );
            },
            child: Text(
              "PROFILE",
            ),
          ),
          MaterialButton(
            onPressed: (){
              Navigator.pushNamed(context, SkillMode.id);
            },
            child: Text(
              "SKILLS",
            ),
          ),
          MaterialButton(
            onPressed: (){
              Navigator.pushNamed(context, Location.id);
            },
            child: Text(
              "SWAP",
            ),
          ),

          MaterialButton(
            onPressed: (){
              Navigator.pushNamed(context, Demo.id);
            },
            child: Text(
              "CHAT",
            ),
          ),
        ],
      ),
    );
  }
}
