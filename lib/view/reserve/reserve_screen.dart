import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ppkd_flutter/api/reservation_api.dart';
import 'package:ppkd_flutter/models/reservation_model.dart';
import 'package:ppkd_flutter/view/reserve/add_reservation.dart';
import 'package:ppkd_flutter/constant/app_color.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});
  static const String id = "/reservation_screen";

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  List<ReservationModel> _reservations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    try {
      final reservations = await ReservationApi.fetchReservations();

      // ✅ Tambahkan log di sini
      print("Jumlah reservasi: ${reservations.length}");
      for (var r in reservations) {
        print("${r.reservedAt} - ${r.guestCount} - ${r.notes}");
      }

      setState(() {
        _reservations = reservations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat reservasi: $e')));
    }
  }

  String formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blackMain,
      appBar: AppBar(
        title: const Text("Daftar Reservasi"),
        backgroundColor: AppColor.blackMain,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _reservations.isEmpty
              ? const Center(
                child: Text(
                  'Belum ada reservasi',
                  style: TextStyle(color: Colors.white70),
                ),
              )
              : RefreshIndicator(
                onRefresh: _fetchReservations,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _reservations.length,
                  itemBuilder: (context, index) {
                    final res = _reservations[index];
                    return Card(
                      color: AppColor.blackField,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatDateTime(res.reservedAt),
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Tamu: ${res.guestCount}",
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              res.notes,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            AddReservationPage.id,
          );
          if (result == true) _fetchReservations();
        },
        icon: const Icon(Icons.add),
        label: const Text("Reservasi Baru"),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
