import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ppkd_flutter/api/reservation_api.dart';
import 'package:ppkd_flutter/api/user_api.dart';
import 'package:ppkd_flutter/helper/shared_preference.dart';
import 'package:ppkd_flutter/models/reservation_model.dart';
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
  Future<List<ReservationModel>>? _reservationsFuture;
  GoogleMapController? mapController;
  LatLng _currentPosition = LatLng(-6.200000, 106.816666);
  String _currentAddress = 'Alamat tidak ditemukan';
  Marker? _marker;

  @override
  void initState() {
    super.initState();
    _profileFuture = fetchProfile();
    _reservationsFuture = ReservationApi.fetchReservations();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _currentPosition = LatLng(position.latitude, position.longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentPosition.latitude,
      _currentPosition.longitude,
    );
    Placemark place = placemarks[0];

    setState(() {
      _marker = Marker(
        markerId: MarkerId("lokasi_saya"),
        position: _currentPosition,
        infoWindow: InfoWindow(
          title: 'Lokasi Anda',
          snippet: "${place.street}, ${place.locality}",
        ),
      );
    });

    _currentAddress =
        "${place.name}, ${place.street}, ${place.locality}, ${place.country}";

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentPosition, zoom: 16),
      ),
    );
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
                    Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _currentPosition,
                            zoom: 14,
                          ),
                          onMapCreated: (controller) {
                            mapController = controller;
                          },
                          markers: _marker != null ? {_marker!} : {},
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                        ),
                        Positioned(
                          top: 16,
                          left: 16,
                          right: 16,
                          child: Card(
                            color: Colors.white,
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                _currentAddress,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ],
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
    return FutureBuilder<List<ReservationModel>>(
      future: _reservationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        final hasData = snapshot.hasData && snapshot.data!.isNotEmpty;
        final reservations = snapshot.data ?? [];

        return _buildExpansionTile(
          title: "Histori Pesanan Meja",
          icon: Icons.event_seat,
          children:
              hasData
                  ? reservations.map((res) {
                    return ListTile(
                      leading: const Icon(Icons.chair, color: Colors.white),
                      title: Text(
                        "Tamu: ${res.guestCount}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "Tanggal: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(res.reservedAt))}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    );
                  }).toList()
                  : [
                    const ListTile(
                      title: Text(
                        "Belum ada histori reservasi.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
        );
      },
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
