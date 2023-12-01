import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/location/user_location.dart';
import 'package:skill_swap/profile_info/personal_information.dart';

import '../helpers/helper_functions.dart';
import '../screens/home_screen.dart';
import '../screens/new_home_screen.dart';
import '../utils/constants/colors.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = NHelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: darkMode ? NColors.black : Colors.white,
          indicatorColor: darkMode
              ? NColors.white.withOpacity(0.1)
              : NColors.black.withOpacity(0.1),
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'home'),
            NavigationDestination(
                icon: Icon(Icons.location_on_outlined), label: 'location'),
            NavigationDestination(
                icon: Icon(Icons.settings), label: 'settings'),
            NavigationDestination(
                icon: Icon(Icons.social_distance), label: 'connect'),
            NavigationDestination(
                icon: Icon(Icons.account_circle_rounded), label: 'profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    NewHomePage(),
    Location(),
    PersonalInfoForm(),
    Container(
      color: Colors.blue,
    ),
    PersonalInfoForm()
  ];
}
