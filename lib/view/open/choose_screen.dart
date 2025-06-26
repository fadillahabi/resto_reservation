import 'package:flutter/material.dart';
import 'package:ppkd_flutter/constant/app_color.dart';
import 'package:ppkd_flutter/view/main/main_screen.dart';
import 'package:ppkd_flutter/view/order/menu_screen.dart';
import 'package:ppkd_flutter/view/reserve/reserve_screen.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart'; // Import the sliding_up_panel package

class ChooseScreen extends StatefulWidget {
  const ChooseScreen({super.key});
  static const String id = "/choose_screen";

  @override
  State<ChooseScreen> createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  final List<Map<String, dynamic>> profiles = [
    {"name": "Pesan Meja", "image": "assets/images/reserve_table.jpg"},
    {"name": "Pesan Makanan", "image": "assets/images/food.jpg"},
  ];

  // Panel controller to programmatically open/close the panel if needed
  final PanelController _panelController = PanelController();
  // Flag to ensure navigation only happens once during a single swipe action
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
            // decoration: TextDecoration.underline,
            decorationColor: AppColor.textHeader,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 72,
      ),
      // Use SlidingUpPanel as the body of the Scaffold
      body: SlidingUpPanel(
        controller: _panelController,
        // The main content of the screen, which remains visible behind the panel
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
                                builder: (_) => const ReserveScreen(),
                              ),
                            );
                          } else if (profile["name"] == "Pesan Makanan") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MenuScreen(),
                              ),
                            );
                          } else {
                            // Fallback navigation for other profiles
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => Scaffold(
                                      appBar: AppBar(
                                        title: Text(profile['name']),
                                      ),
                                      body: Center(
                                        child: Text(
                                          "Ini halaman ${profile['name']}",
                                        ),
                                      ),
                                    ),
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
        // The draggable panel that slides up from the bottom
        panel: Container(
          decoration: const BoxDecoration(
            color: Colors.black, // Dark background for the panel
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Visual indicator for dragging
                Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 40.0),
                Text(
                  "Geser ke atas untuk ke Beranda", // Text indicating swipe action
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        // Configure panel behavior and appearance
        minHeight: 80.0, // Initial height of the draggable panel when collapsed
        maxHeight:
            MediaQuery.of(context).size.height *
            0.4, // Max height the panel can slide up to
        parallaxEnabled: true, // Enables parallax effect on the body
        parallaxOffset: .5, // Controls the intensity of the parallax effect
        collapsed: Container(
          // Content displayed when the panel is fully collapsed
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
                Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 40.0),
                Text(
                  "Geser ke atas untuk ke Beranda",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        borderRadius: const BorderRadius.only(
          // Apply rounded corners to the panel
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        // Callback for when the panel is sliding
        onPanelSlide: (position) {
          // Define a threshold (e.g., 80% of max height) to trigger navigation
          double navigationThreshold = 0.8;
          if (position >= navigationThreshold && !_hasNavigated) {
            setState(() {
              _hasNavigated = true; // Set flag to prevent multiple navigations
            });
            // Navigate to MainScreen when the panel slides past the threshold
            Navigator.pushReplacementNamed(context, MainScreen.id);
          }
        },
      ),
    );
  }
}
