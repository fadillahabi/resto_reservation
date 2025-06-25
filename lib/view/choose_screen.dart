import 'package:flutter/material.dart';
import 'package:ppkd_flutter/constant/app_color.dart';

class ChooseScreen extends StatefulWidget {
  const ChooseScreen({super.key});
  static const String id = "/choose_screen";

  @override
  State<ChooseScreen> createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  final List<Map<String, dynamic>> profiles = [
    {"name": "Drashti", "color": Colors.blueGrey},
    {"name": "Bhavesh", "color": Colors.amber},
    {"name": "Aditi", "color": Colors.greenAccent},
    {"name": "Prit", "color": Colors.redAccent},
    {"name": "Kavya", "color": Colors.blue},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "PESAN MEJA",
          style: TextStyle(
            color: AppColor.textHeader,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 2,
            decoration: TextDecoration.underline,
            decorationColor: AppColor.textHeader,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
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
                      onTap: () {},
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: profile["color"],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.tag_faces,
                                  color: Colors.white,
                                  size: 50,
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
    );
  }
}
