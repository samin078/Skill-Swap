import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/location/user_location.dart';
import 'package:skill_swap/profile/screens/demo.dart';
import 'package:skill_swap/profile/screens/user_profile_screen.dart';
import 'package:skill_swap/profile_info/personal_information.dart';
import 'package:skill_swap/screens/home_screen.dart';
import 'package:skill_swap/screens/splash_screen.dart';
import 'package:skill_swap/screens/welcome_screen.dart';
import 'package:skill_swap/skills/select_skill_mode.dart';
import 'package:skill_swap/skills/skilled_in.dart';
import 'package:skill_swap/skills/unskilled_in.dart';
import 'package:skill_swap/utils/theme/theme.dart';
import 'auth/screen/login_screen.dart';
import 'auth/screen/register_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreenPage.id,
      routes: {
        SplashScreenPage.id: (context) => SplashScreenPage(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        SkillMode.id: (context) => SkillMode(),
        SkilledInScreen.id: (context) => SkilledInScreen(),
        UnskilledInScreen.id: (context) => UnskilledInScreen(),
        //  UserProfile.id: (context) => UserProfile(,),
        Location.id: (context) => Location(),
        Demo.id: (context) => Demo(),
        // new screens
        PersonalInfoForm.id: (context) => PersonalInfoForm(),
      },
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: NAppTheme.lightTheme,
      darkTheme: NAppTheme.darkTheme,
      //home:SignUpScreen(),
      //home: PersonalInfoForm(),
      home:LoginScreen(),

    );
  }
}