import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../auth/screen/signup_screen.dart';
import '../../../profile_info/personal_information.dart';
import '../../../utils/constants/sizes.dart';
import '../../navigation_menu.dart';




class NLoginForm extends StatefulWidget {
  @override
  _NLoginFormState createState() => _NLoginFormState();
}

class _NLoginFormState extends State<NLoginForm> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showSpinner = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: NSizes.spaceBtwSections,
          ),
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Email",
                ),
              ),
              const SizedBox(
                height: NSizes.spaceBtwInputFields,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: _obscurePassword, // Use _obscurePassword here
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Change the icon based on password visibility
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword; // Toggle password visibility
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: NSizes.spaceBtwInputFields / 2,
              ),

              ///remember me and forget password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //remember me
                  Row(
                    children: [
                      Checkbox(value: true, onChanged: (value) {}),
                      const Text("Remember me"),
                    ],
                  ),

                  TextButton(
                    onPressed: () {},
                    child: const Text("Forgot Password"),
                  ),
                ],
              ),
              //forget pass

              const SizedBox(
                height: NSizes.spaceBtwSections,
              ),
              //sign in button
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    //onPressed: () => Get.to(()=> const NavigationMenu()),
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: emailController.text, password: passwordController.text);
                        if (user != null) {
                          //Navigator.pushNamed(context, HomeScreen.id);
                          Get.to(() => NavigationMenu());
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        Fluttertoast.showToast(
                          msg: "$e",
                        );
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    },
                    child: Text("SIGN IN"),
                  )),
              const SizedBox(
                height: NSizes.spaceBtwItems,
              ),
              //create account
              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.to(() => SignUpScreen());
                    },
                    child: Text("CREATE ACCOUNT"),
                  ),
              ),
              const SizedBox(
                height: NSizes.spaceBtwSections,
              ),
            ],
          ),
        ),
    );
  }
}
