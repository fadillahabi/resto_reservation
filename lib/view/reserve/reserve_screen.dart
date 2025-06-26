import 'package:flutter/material.dart';
import 'package:ppkd_flutter/constant/app_color.dart';

class ReserveScreen extends StatefulWidget {
  const ReserveScreen({super.key});

  @override
  State<ReserveScreen> createState() => _ReserveScreenState();
}

class _ReserveScreenState extends State<ReserveScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController dateController = TextEditingController();
  final TextEditingController guestController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  bool isSubmitting = false;

  void submitReservation() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSubmitting = true;
      });

      // Simulasi delay submit
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isSubmitting = false;
        });

        // Dialog sukses
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("Reservasi Berhasil"),
                content: Text(
                  "Tanggal: ${dateController.text}\n"
                  "Jumlah Tamu: ${guestController.text}\n"
                  "Catatan: ${notesController.text}",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
        );
      });
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dateController.text = picked.toString().substring(
          0,
          16,
        ); // 'yyyy-MM-dd HH:mm'
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blackMain,
      appBar: AppBar(
        backgroundColor: AppColor.blackMain,
        title: const Text(
          "Pesan Meja",
          style: TextStyle(color: AppColor.textHeader),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: buildInputField("Tanggal Reservasi", dateController),
                ),
              ),
              const SizedBox(height: 12),
              buildInputField(
                "Jumlah Tamu",
                guestController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              buildInputField(
                "Catatan",
                notesController,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isSubmitting ? null : submitReservation,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child:
                    isSubmitting
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                        : const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: keyboardType == TextInputType.multiline ? 3 : 1,
      style: const TextStyle(color: Colors.white),
      validator:
          (value) =>
              value == null || value.isEmpty ? 'Tidak boleh kosong' : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
