import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../Globals/Widgets/text_widgets/section_heading.dart';
import '../Globals/Widgets/text_widgets/skill_card.dart';
import '../database/database_methods.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';


var loggedUserId = DatabaseMethods.userId;

class NewHomePage extends StatefulWidget {
  const NewHomePage({Key? key}) : super(key: key);

  @override
  _NewHomePageState createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {

  final String userName = "Samin"; // Replace with dynamic user name

@override
  void initState() {
    DatabaseMethods().getUId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> skills = [
      "Machine Learning",
      "Graphic Design",
      "Football",
      "Painting",
      // ... add more skills ...
    ];

    final List<String> demoImages = [
      "assets/icons/categories/sports.png",
      "assets/icons/categories/education.png",
      "assets/icons/categories/languages.png",
    ];
    final List<String> homeImages = [
      "assets/homeIcons/machine.png",
      "assets/homeIcons/graphic.png",
      "assets/homeIcons/football.png",
      "assets/homeIcons/paint.png",
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(NSizes.spaceBtwSections),
              ),
              // Image Slider
              CarouselSlider(
                items: demoImages.map((imagePath) {
                  return Container(
                    width: double.infinity,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain, // Fit the image inside the container without cropping
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true, // Auto play images
                  viewportFraction: 1.0, // Full width
                ),
              ),

              Padding(
                padding: EdgeInsets.all(NSizes.defaultSpace),
                child: Text(
                  "Good Day, $userName!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: NColors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: NSizes.defaultSpace),
                child: Text(
                  "Explore and share skills with others. Learn something new or help others grow!",
                  style: TextStyle(
                    fontSize: 16,
                    color: NColors.white,
                  ),
                ),
              ),
              SizedBox(height: NSizes.spaceBtwSections),
              Padding(
                padding: const EdgeInsets.all(NSizes.defaultSpace),
                child: const NSectionHeading(
                  title: 'Skills to Explore',
                  showActionButton: false,
                  textColor: NColors.grey,

                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: NSizes.defaultSpace),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: skills.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SkillCard2(skillName: skills[index],textSize: 15,imagePath: homeImages[index],),
                    );
                  },
                ),
              ),
              SizedBox(height: 20), // Add spacing between grid and button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle "GET STARTED" button click
                  },
                  child: Text("GET STARTED",style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(0,224, 150, 203),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),// Change the button's background color
                  ),
                ),
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}