import 'package:flutter/material.dart';
import 'package:ppkd_flutter/api/user_api.dart';
import 'package:ppkd_flutter/constant/app_color.dart';
import 'package:ppkd_flutter/helper/shared_preference.dart';
import 'package:ppkd_flutter/models/user_model.dart';
import 'package:ppkd_flutter/view/login_register/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.onProfileUpdated});
  final VoidCallback? onProfileUpdated;
  static const String id = "/profile_screen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<ProfileResponse?>? _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = fetchProfile();
  }

  Future<ProfileResponse?> fetchProfile() async {
    final token = await PreferenceHandlerPM.getToken();
    if (token != null) {
      try {
        return await UserServicePM().getProfile(token);
      } catch (e) {
        debugPrint('Gagal memuat profile: $e');
      }
    }
    return null;
  }

  Future<void> _editProfileDialog(ProfileResponse profile) async {
    final nameController = TextEditingController(text: profile.name);
    final token = await PreferenceHandlerPM.getToken();

    if (token == null) return;

    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: AppColor.blackField,
            title: const Text(
              'Edit Profil',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Nama",
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    filled: true,
                    fillColor: AppColor.cardDark,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final updatedProfile = await UserServicePM().updateProfile(
                    token,
                    nameController.text,
                  );
                  if (!mounted) return;
                  if (updatedProfile != null) {
                    setState(() {
                      _profileFuture = Future.value(updatedProfile);
                    });
                    widget.onProfileUpdated?.call();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Nama berhasil diperbarui")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Nama gagal diperbarui")),
                    );
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blackMain,
      body: FutureBuilder<ProfileResponse?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                "Gagal memuat data.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final profile = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.blueGrey),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        profile.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                      onPressed: () => _editProfileDialog(profile),
                    ),
                  ],
                ),
                Text(profile.email, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 24),
                _buildHistorySection(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Keluar",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () async {
                          PreferenceHandlerPM.deleteLogin();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        icon: const Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
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
    );
  }

  Widget _buildHistorySection() {
    return Column(
      children: [
        Card(
          color: AppColor.blackField,
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            title: const Text(
              "Histori Pesanan Meja",
              style: TextStyle(color: Colors.white),
            ),
            leading: const Icon(Icons.event_seat, color: Colors.white),
            iconColor: Colors.white,
            collapsedIconColor: Colors.white54,
            children: const [
              ListTile(
                leading: Icon(Icons.chair, color: Colors.white),
                title: Text("data", style: TextStyle(color: Colors.white)),
                subtitle: Text("data", style: TextStyle(color: Colors.white70)),
              ),
              ListTile(
                leading: Icon(Icons.chair, color: Colors.white),
                title: Text("data", style: TextStyle(color: Colors.white)),
                subtitle: Text("data", style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
        Card(
          color: AppColor.blackField,
          elevation: 2,
          child: ExpansionTile(
            title: const Text(
              "Histori Pesanan Makanan",
              style: TextStyle(color: Colors.white),
            ),
            leading: const Icon(Icons.fastfood, color: Colors.white),
            iconColor: Colors.white,
            collapsedIconColor: Colors.white54,
            children: const [
              ListTile(
                leading: Icon(Icons.restaurant, color: Colors.white),
                title: Text("data", style: TextStyle(color: Colors.white)),
                subtitle: Text("data", style: TextStyle(color: Colors.white70)),
              ),
              ListTile(
                leading: Icon(Icons.restaurant, color: Colors.white),
                title: Text("data", style: TextStyle(color: Colors.white)),
                subtitle: Text("data", style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
