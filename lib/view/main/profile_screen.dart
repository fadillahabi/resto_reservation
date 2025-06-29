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
        debugPrint('Gagal memuat profile: \$e');
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
            backgroundColor: Colors.grey[900],
            title: const Text(
              'Edit Profil',
              style: TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Nama",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
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
                  backgroundColor: Colors.tealAccent[700],
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D0D0D), Color(0xFF1A1A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<ProfileResponse?>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
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
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: media.width * 0.06,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: media.width * 0.16,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: media.width * 0.14,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            profile.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: media.width * 0.06,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () => _editProfileDialog(profile),
                        ),
                      ],
                    ),
                    Text(
                      profile.email,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 36),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Riwayat",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildHistorySection(),
                    const SizedBox(height: 36),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          PreferenceHandlerPM.deleteLogin();
                          if (!mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          "Keluar",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                          shadowColor: Colors.redAccent.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildExpansionTile(
          title: "Histori Pesanan Meja",
          icon: Icons.event_seat,
          children: const [
            ListTile(
              leading: Icon(Icons.chair, color: Colors.white),
              title: Text(
                "Pesanan Meja 1",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "Tanggal: 2025-06-28",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildExpansionTile(
          title: "Histori Pesanan Makanan",
          icon: Icons.fastfood,
          children: const [
            ListTile(
              leading: Icon(Icons.restaurant, color: Colors.white),
              title: Text("Makanan 1", style: TextStyle(color: Colors.white)),
              subtitle: Text(
                "Tanggal: 2025-06-27",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      color: Colors.grey[850],
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Icon(icon, color: Colors.tealAccent),
        iconColor: Colors.white,
        collapsedIconColor: Colors.white54,
        children: children,
      ),
    );
  }
}
