import 'package:flutter/material.dart';
import 'package:skill_swap/skills/skilled_in.dart';
import 'package:skill_swap/skills/unskilled_in.dart';



class SkillMode extends StatefulWidget {
  static String id = 'skill_mode';
  const SkillMode({Key? key}) : super(key: key);

  @override
  State<SkillMode> createState() => _SkillModeState();
}

class _SkillModeState extends State<SkillMode> {
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
              Navigator.pushNamed(context, SkilledInScreen.id);
            },
            child: Text(
              "Skilled In",
            ),
          ),
          MaterialButton(
            onPressed: (){
              Navigator.pushNamed(context, UnskilledInScreen.id);
            },
            child: Text(
              "Interested In",
            ),
          ),
        ],
      ),
    );
  }
}
