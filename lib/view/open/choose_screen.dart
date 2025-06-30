import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:ppkd_flutter/constant/app_color.dart';
import 'package:ppkd_flutter/view/main/main_screen.dart';
import 'package:ppkd_flutter/view/menu/menu_screen.dart';
import 'package:ppkd_flutter/view/reserve/add_reservation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ChooseScreen extends StatefulWidget {
  const ChooseScreen({super.key});
  static const String id = "/choose_screen";

  @override
  State<ChooseScreen> createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  final List<Map<String, dynamic>> profiles = [
    {"name": "Pesan Meja", "image": "assets/images/reserve_table.jpg"},
    {"name": "Daftar Makanan", "image": "assets/images/food.jpg"},
  ];

  final PanelController _panelController = PanelController();
  bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "ALABI RESTO",
          style: TextStyle(
            color: AppColor.textHeader,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 72,
      ),
      body: SlidingUpPanel(
        controller: _panelController,
        body: Column(
          children: [
            const SizedBox(height: 24),
            const Text(
              "Rencana Selanjutnya?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children:
                    profiles.map((profile) {
                      return InkWell(
                        onTap: () {
                          if (profile["name"] == "Pesan Meja") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddReservationPage(),
                              ),
                            );
                          } else if (profile["name"] == "Daftar Makanan") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MenuScreen(),
                              ),
                            );
                          }
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: AssetImage(profile["image"]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              profile["name"],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
        panel: const _PanelContent(),
        collapsed: const _PanelContent(),
        minHeight: 80.0,
        maxHeight: MediaQuery.of(context).size.height * 0.4,
        parallaxEnabled: true,
        parallaxOffset: .5,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        onPanelSlide: (position) {
          double threshold = 0.8;
          if (position >= threshold && !_hasNavigated) {
            setState(() => _hasNavigated = true);
            Navigator.pushReplacementNamed(context, MainScreen.id);
          }
        },
      ),
    );
  }
}

class _PanelContent extends StatelessWidget {
  const _PanelContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _AnimatedArrow(),
            SizedBox(height: 8),
            Text(
              "Geser ke atas untuk ke Beranda",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedArrow extends StatelessWidget {
  const _AnimatedArrow();

  @override
  Widget build(BuildContext context) {
    return Bounce(
      infinite: true,
      from: 20,
      child: const Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white,
        size: 40.0,
      ),
    );
  }
}
