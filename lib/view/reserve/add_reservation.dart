import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ppkd_flutter/api/endpoint.dart';
import 'package:ppkd_flutter/constant/app_color.dart';
import 'package:ppkd_flutter/helper/shared_preference.dart';

class AddReservationPage extends StatefulWidget {
  const AddReservationPage({super.key});
  static const String id = "/add_reservation";

  @override
  State<AddReservationPage> createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _guestCountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? _selectedDateTime;
  bool isLoading = false;

  Future<void> _selectDateTime() async {
    final DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 15, minute: 0),
      );

      if (pickedTime != null) {
        if (pickedTime.hour < 15 || pickedTime.hour >= 22) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Reservasi hanya dapat dilakukan antara pukul 15:00 - 22:00",
              ),
            ),
          );
          return;
        }

        final selected = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _selectedDateTime = selected;
        });
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data reservasi.")),
      );
      return;
    }

    setState(() => isLoading = true);

    final token = await PreferenceHandlerPM.getToken();
    final userId = await PreferenceHandlerPM.getUserId();

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "reserved_at": DateFormat(
        "yyyy-MM-dd HH:mm:ss",
      ).format(_selectedDateTime!),
      "guest_count": int.parse(_guestCountController.text),
      "notes": _notesController.text,
      "user_id": userId,
    });

    final response = await http.post(
      Uri.parse(Endpoint.reservation),
      headers: headers,
      body: body,
    );

    setState(() => isLoading = false);
    if (!mounted) return;

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reservasi berhasil ditambahkan.")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: ${response.statusCode}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blackMain,
      appBar: AppBar(
        title: const Text('Reservasi Meja'),
        backgroundColor: AppColor.blackMain,
        foregroundColor: Colors.white,
      ),
      body: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Form Reservasi',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    controller: _guestCountController,
                    label: 'Jumlah Tamu',
                    icon: Icons.people,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: _notesController,
                    label: 'Catatan',
                    icon: Icons.note_alt,
                  ),
                  const SizedBox(height: 15),
                  ListTile(
                    tileColor: AppColor.blackField,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Text(
                      _selectedDateTime != null
                          ? DateFormat(
                            'yyyy-MM-dd HH:mm',
                          ).format(_selectedDateTime!)
                          : "Pilih Tanggal & Jam",
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      onPressed: _selectDateTime,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : _submit,
                    icon: const Icon(Icons.send),
                    label:
                        isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              'Kirim Reservasi',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon:
            icon != null ? Icon(icon, color: Colors.orangeAccent) : null,
        filled: true,
        fillColor: AppColor.blackField,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator:
          (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
    );
  }
}
