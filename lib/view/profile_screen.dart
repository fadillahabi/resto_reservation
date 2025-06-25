import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String id = "/profile_screen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Member Info
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Abi",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                  Text("abi@gmail.com", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "PESAN MEJA CLUB",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "500 Poin",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "IDR 20.000.000 more to Gold member",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              ExpansionTile(
                title: Text("Histori pesanan meja"),
                children: [
                  ListTile(
                    leading: Icon(Icons.event_seat),
                    title: Text("data"),
                    subtitle: Text("data"),
                  ),
                  ListTile(
                    leading: Icon(Icons.event_seat),
                    title: Text("data"),
                    subtitle: Text("data"),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text("Histori pesanan makanan"),
                children: [
                  ListTile(
                    leading: Icon(Icons.event_seat),
                    title: Text("data"),
                    subtitle: Text("data"),
                  ),
                  ListTile(
                    leading: Icon(Icons.event_seat),
                    title: Text("data"),
                    subtitle: Text("data"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
