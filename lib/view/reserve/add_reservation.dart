import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ppkd_flutter/constant/app_color.dart';
import 'package:ppkd_flutter/helper/shared_preference.dart';
import 'package:ppkd_flutter/api/endpoint.dart';

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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
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
    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    setState(() => isLoading = false);

    if (!mounted) return;

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reservasi berhasil ditambahkan.")),
      );
      Navigator.pop(context);
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _guestCountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Jumlah Tamu',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: AppColor.blackField,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _notesController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Catatan',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: AppColor.blackField,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  onPressed: _selectDateTime,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Kirim',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
