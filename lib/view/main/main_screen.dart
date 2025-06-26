import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ppkd_flutter/api/user_api.dart';
import 'package:ppkd_flutter/constant/app_color.dart';
import 'package:ppkd_flutter/helper/shared_preference.dart';
import 'package:ppkd_flutter/models/user_model.dart';
import 'package:ppkd_flutter/view/main/profile_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const String id = "/main_screen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [const MainContent(), const ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.blackMain, Colors.white],
            begin: Alignment.center,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class MainContent extends StatefulWidget {
  const MainContent({super.key});

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  ProfileResponse? _profileData;
  final bool _isLoading = false;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final token = await PreferenceHandlerPM.getToken();
    if (token != null) {
      try {
        final profile = await UserServicePM().getProfile(token);
        setState(() {
          _profileData = profile;
        });
      } catch (e) {
        print("Error fetching profile: $e");
      }
    }
  }

  final List<String> imagePaths = [
    "assets/images/restaurant4.jpg",
    "assets/images/restaurant5.jpg",
    "assets/images/food3.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AppBar manual
        Container(
          padding: const EdgeInsets.only(
            top: 60,
            left: 16,
            right: 16,
            bottom: 32,
          ),
          color: Colors.black,
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isLoading
                        ? "Hai, Loading..."
                        : "Hai, ${_profileData?.name ?? 'User'}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    _isLoading
                        ? "Loading..."
                        : _profileData?.email ?? "Email Not Available",
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),

        // CarouselSlider
        Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 250,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1,
                autoPlayInterval: const Duration(seconds: 3),
                onPageChanged: (index, reason) {
                  setState(() {
                    activeIndex = index;
                  });
                },
              ),
              items:
                  imagePaths.map((imagePath) {
                    return Builder(
                      builder: (BuildContext context) {
                        return CarouselImage(imagePath);
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 8),
            AnimatedSmoothIndicator(
              activeIndex: activeIndex,
              count: imagePaths.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.orange,
                dotColor: Colors.grey,
              ),
            ),
          ],
        ),
        // Body Content
      ],
    );
  }
}

// Carousel Image Widget
class CarouselImage extends StatelessWidget {
  final String assetPath;

  const CarouselImage(this.assetPath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: AssetImage(assetPath), fit: BoxFit.cover),
      ),
    );
  }
}

// Brand Card
class BrandCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const BrandCard(this.title, this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: AssetImage(imageUrl), fit: BoxFit.cover),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Reward Card
class RewardCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const RewardCard(this.title, this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: AssetImage(imageUrl), fit: BoxFit.cover),
      ),
    );
  }
}
