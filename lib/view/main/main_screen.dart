// ignore_for_file: use_key_in_widget_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ppkd_flutter/api/menu_api.dart';
import 'package:ppkd_flutter/api/user_api.dart';
import 'package:ppkd_flutter/constant/app_color.dart';
import 'package:ppkd_flutter/helper/shared_preference.dart';
import 'package:ppkd_flutter/models/menu_model.dart';
import 'package:ppkd_flutter/models/user_model.dart';
import 'package:ppkd_flutter/view/main/profile_screen.dart';
import 'package:ppkd_flutter/view/menu/menu_screen.dart';
import 'package:ppkd_flutter/view/reserve/add_reservation.dart';
import 'package:ppkd_flutter/view/reserve/reservation_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MainScreen extends StatefulWidget {
  static const String id = "/main_screen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final GlobalKey<_MainContentState> _mainContentKey =
      GlobalKey<_MainContentState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.blackMain, Colors.grey],
            begin: Alignment.center,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Builder(
            builder: (context) {
              if (_currentIndex == 0) {
                return MainContent(key: _mainContentKey);
              } else if (_currentIndex == 1) {
                return const ReservationScreen();
              } else {
                return const ProfileScreen();
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Reservasi"),
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
  int activeIndex = 0;
  Future<ProfileResponse?>? _profileFuture;
  Future<List<MenuModel>>? _menusFuture;

  final List<String> bannerImages = [
    "assets/images/restaurant4.jpg",
    "assets/images/restaurant5.jpg",
    "assets/images/food3.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _profileFuture = fetchProfile();
    _menusFuture = MenuApi.fetchMenus();
  }

  void refreshMenus() {
    setState(() {
      _menusFuture = MenuApi.fetchMenus();
    });
  }

  Future<ProfileResponse?> fetchProfile() async {
    final token = await PreferenceHandlerPM.getToken();
    if (token != null) {
      try {
        return await UserServicePM().getProfile(token);
      } catch (e) {
        debugPrint('Gagal memuat profile: \$e');
      }
    }
    return null;
  }

  Widget _fallbackImage() {
    return Container(
      color: Colors.grey[300],
      width: 100,
      height: 100,
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image, size: 32, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<ProfileResponse?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        final profile = snapshot.data;

        return ListView(
          children: [
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile?.name ?? '-',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          profile?.email ?? '-',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: bannerImages.length,
                  itemBuilder:
                      (context, index, _) => Image.asset(
                        bannerImages[index],
                        fit: BoxFit.cover,
                        width: screenWidth,
                      ),
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    viewportFraction: 1,
                    onPageChanged:
                        (index, reason) => setState(() => activeIndex = index),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 16,
                  child: AnimatedSmoothIndicator(
                    activeIndex: activeIndex,
                    count: bannerImages.length,
                    effect: const WormEffect(
                      activeDotColor: Colors.white,
                      dotColor: Colors.grey,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap:
                    () => Navigator.pushNamed(context, AddReservationPage.id),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade300, Colors.orange.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 24,
                        child: Icon(
                          Icons.event_seat,
                          color: Colors.orange,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Butuh Meja?",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Klik untuk pesan meja secara online",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Jelajahi Menu Favoritmu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed:
                        () => Navigator.pushNamed(context, MenuScreen.id),
                    child: const Text(
                      'Lainnya',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<MenuModel>>(
              future: _menusFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(
                    child: Text(
                      'Gagal memuat menu',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final menus = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: menus.length,
                  itemBuilder: (context, index) {
                    final menu = menus[index];
                    final imageUrl = menu.imageUrl ?? '';

                    return InkWell(
                      onTap:
                          () => Navigator.pushNamed(
                            context,
                            '/detail_menu',
                            arguments: menu,
                          ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              child:
                                  imageUrl.isNotEmpty
                                      ? Image.network(
                                        imageUrl,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (
                                          context,
                                          child,
                                          loadingProgress,
                                        ) {
                                          if (loadingProgress == null)
                                            return child;
                                          return const SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.orange),
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (_, __, ___) => _fallbackImage(),
                                      )
                                      : _fallbackImage(),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      menu.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      menu.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'id_ID',
                                        symbol: 'Rp ',
                                        decimalDigits: 0,
                                      ).format(menu.price),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
