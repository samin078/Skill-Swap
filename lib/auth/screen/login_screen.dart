import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:skill_swap/screens/home_screen.dart';
import '../../components/rounded_button.dart';
import '../../constants.dart';
import '../../globals/Widgets/login_widgets/divider.dart';
import '../../globals/Widgets/login_widgets/login_form.dart';
import '../../globals/Widgets/login_widgets/login_header.dart';
import '../../globals/Widgets/login_widgets/social_buttons.dart';
import '../../helpers/helper_functions.dart';
import '../../styles/spacing_styles.dart';
import '../../utils/constants/sizes.dart';



class LoginScreen extends StatefulWidget {

  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool showSpinner = false;



  @override
  Widget build(BuildContext context) {
    final dark = NHelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: NSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              //logo,title and subtitle
              NLoginHeader(dark: dark),
              //form
              NLoginForm(),
              ///divider
              NFormDivider(dark: dark, dividerText: "Or Sign In With",),
              const SizedBox(height: NSizes.sm,),
              ///footer
              const NSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
