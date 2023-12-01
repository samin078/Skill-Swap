import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:skill_swap/profile/profile_menu.dart';
import 'package:skill_swap/profile_info/personal_information.dart';
import '../../globals/Widgets/login_widgets/divider.dart';
import '../../globals/Widgets/login_widgets/social_buttons.dart';
import '../../globals/navigation_menu.dart';
import '../../helpers/helper_functions.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool acceptTerms = false;
  bool _obscurePassword = true;
  final _auth = FirebaseAuth.instance;


  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers when not in use
    firstNameController.dispose();
    lastNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void createAccount() async{
    // Accessing values from the controllers
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String userName = userNameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (newUser != null) {
        // Save additional user information in Firestore
        await FirebaseFirestore.instance.collection("user_info").doc(newUser.user!.uid).set({
          'first_name': firstName,
          'last_name': lastName,
          'user_name': userName,
          'email': email,
          // Add any other fields you need
        });

        Get.to(() =>
            PersonalInfoForm()); // Navigate to the next screen after successful signup
        Fluttertoast.showToast(msg: "Account created successfully!");
      }
    }
    catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: 'Some Error Occured',
      );
    }
    // Show a toast or print values for demonstration
    Fluttertoast.showToast(
      msg: "First Name: $firstName, Last Name: $lastName, Username: $userName, Email: $email, Password: $password, Confirm Password: $confirmPassword",
    );
    // Add your logic here for creating an account
  }

  @override
  Widget build(BuildContext context) {
    final dark = NHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(NSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///title
              Center(
                  child: Text(
                    "Let's Create Your Account",
                    style: Theme.of(context).textTheme.headlineMedium,
                  )),
              const SizedBox(
                height: NSizes.spaceBtwSections,
              ),

              ///Form
              Form(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: firstNameController,
                            expands: false,
                            decoration: const InputDecoration(
                                labelText: "First Name",
                                prefixIcon: Icon(Icons.person)),
                          ),
                        ),
                        const SizedBox(
                          width: NSizes.spaceBtwInputFields,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: lastNameController,
                            expands: false,
                            decoration: const InputDecoration(
                                labelText: "Last Name",
                                prefixIcon: Icon(Icons.person)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: NSizes.spaceBtwInputFields,
                    ),

                    ///username

                    TextFormField(
                      controller: userNameController,
                      expands: false,
                      decoration: const InputDecoration(
                          labelText: "User name",
                          prefixIcon: Icon(Icons.person_2_rounded)),
                    ),
                    const SizedBox(
                      height: NSizes.spaceBtwInputFields,
                    ),

                    ///email
                    TextFormField(
                      controller: emailController,
                      expands: false,
                      decoration: const InputDecoration(
                          labelText: "Email", prefixIcon: Icon(Icons.email)),
                    ),
                    const SizedBox(
                      height: NSizes.spaceBtwInputFields,
                    ),

                    ///password
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
                      height: NSizes.spaceBtwInputFields,
                    ),

                    /// confirm password
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: _obscurePassword, // Use _obscurePassword here
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        labelText: "Confirm Password",
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
                    const SizedBox(height: NSizes.defaultSpace,),
                    ///terms and conditions
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: acceptTerms,
                            onChanged: (value) {
                              setState(() {
                                acceptTerms = value ?? false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: NSizes.spaceBtwItems),
                        Flexible(
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                  text: 'I agree to the ',
                                  style: Theme.of(context).textTheme.bodySmall),
                              TextSpan(
                                text: 'Privacy Policy ',
                                style: Theme.of(context).textTheme.bodyMedium!.apply(color: dark ? NColors.white : NColors.primary),),
                              TextSpan(
                                  text: ' and ',
                                  style: Theme.of(context).textTheme.bodySmall),
                              TextSpan(
                                text: 'Terms of Use',
                                style: Theme.of(context).textTheme.bodyMedium!.apply(color: dark ? NColors.white : NColors.primary),),
                            ]),

                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: NSizes.spaceBtwSections,),
                    ///signup button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (){
                          //createAccount();
                          if (confirmPasswordController.text == passwordController.text) {
                            // Add logic to handle signup
                            if (acceptTerms) {
                              createAccount();
                            } else {
                              Fluttertoast.showToast(msg: "Please check terms and conditions");
                            }
                          } else {
                            Fluttertoast.showToast(msg: "Passwords Don't Match");
                          }
                        },
                        child: Text("Create Account"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: NSizes.defaultSpace,),
              ///divider
              NFormDivider(dark: dark, dividerText: 'Sign Up With'),
              const SizedBox(height: NSizes.sm,),
              const NSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}