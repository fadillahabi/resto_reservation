import 'package:flutter/material.dart';
import 'package:ppkd_flutter/constant/app_color.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  bool isSubmitting = false;

  void submitMenu() {
    if (_formKey.currentState!.validate()) {
      setState(() => isSubmitting = true);

      // Simulasi submit ke server
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => isSubmitting = false);

        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("Menu Berhasil Ditambahkan"),
                content: Text(
                  "Nama: ${nameController.text}\n"
                  "Deskripsi: ${descController.text}\n"
                  "Harga: ${priceController.text}\n"
                  "Gambar: ${imageUrlController.text}",
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

  Widget buildTextInput(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blackMain,
      appBar: AppBar(
        backgroundColor: AppColor.blackMain,
        title: const Text(
          "Tambah Menu",
          style: TextStyle(color: AppColor.textHeader),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextInput("Nama Menu", nameController),
              const SizedBox(height: 12),
              buildTextInput("Deskripsi", descController, maxLines: 2),
              const SizedBox(height: 12),
              buildTextInput(
                "Harga",
                priceController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              buildTextInput(
                "URL Gambar",
                imageUrlController,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isSubmitting ? null : submitMenu,
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
}
