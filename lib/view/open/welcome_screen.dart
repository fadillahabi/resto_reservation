import 'package:flutter/material.dart';
import 'package:ppkd_flutter/view/login_register/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static const String id = "/welcome_screen";

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> welcomePages = [
    {
      'image1': 'assets/images/food.jpg',
      'image2': 'assets/images/restaurant.jpg',
      'title': 'Rencanakan menu mingguan Anda',
      'desc':
          "Anda bisa memesan makanan mingguan, dan kami akan mengantarkannya langsung ke meja Anda.",
    },
    {
      'image1': 'assets/images/restaurant2.jpg',
      'image2': 'assets/images/infront.jpg',
      'title': 'Reservasi meja',
      'desc': "Lelah harus menunggu? Segera lakukan reservasi meja.",
    },
    {
      'image1': 'assets/images/restaurant3.jpg',
      'image2': 'assets/images/food2.jpg',
      'title': 'Coba hidangan baru',
      'desc': "Jelajahi berbagai masakan dan kejutkan indra perasa Anda.",
    },
  ];

  void _nextPage() {
    if (_currentPage < welcomePages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, LoginScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.width * 0.6; // responsif

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Carousel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: welcomePages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = welcomePages[index];
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar responsif dan bersilang
                        SizedBox(
                          height: size.height * 0.45,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 20,
                                right: -40,
                                child: Transform.rotate(
                                  angle: 0.5,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      page['image1'],
                                      width: imageSize,
                                      height: imageSize,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 100,
                                left: -40,
                                child: Transform.rotate(
                                  angle: -0.2,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Positioned(
                                        top: -20,
                                        child: Container(
                                          width: imageSize,
                                          height: imageSize,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white.withOpacity(
                                                  0.3,
                                                ),
                                                blurRadius: 1,
                                                spreadRadius: 2,
                                                offset: Offset(0, 0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.asset(
                                          page['image2'],
                                          width: imageSize,
                                          height: imageSize,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Teks
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                page['title'],
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                page['desc'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dot Indicator
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  welcomePages.length,
                  (dotIndex) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentPage == dotIndex ? 12 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color:
                          _currentPage == dotIndex
                              ? Colors.white
                              : Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),

            // Tombol Bawah (tetap)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _skip,
                    child: const Text(
                      'Lewati',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _currentPage == welcomePages.length - 1
                            ? Icons.check
                            : Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      onPressed: _nextPage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
