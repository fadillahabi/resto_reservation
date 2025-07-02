import 'dart:convert';

import 'package:animate_do/animate_do.dart'; // <-- animasi ringan
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:ppkd_flutter/api/endpoint.dart';
import 'package:ppkd_flutter/constant/app_color.dart';
import 'package:ppkd_flutter/helper/shared_preference.dart';

class AddMenu extends StatefulWidget {
  const AddMenu({super.key});
  static const String id = "/add_menu";

  @override
  State<AddMenu> createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  String? base64Image;
  bool isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        base64Image =
            'data:image/${image.path.split('.').last};base64,${base64Encode(bytes)}';
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || base64Image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua field termasuk gambar.")),
      );
      return;
    }

    setState(() => isLoading = true);

    final token = await PreferenceHandlerPM.getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'name': nameController.text,
      'description': descController.text,
      'price': int.parse(priceController.text),
      'image': base64Image,
    });

    final res = await http.post(
      Uri.parse('${Endpoint.baseUrlApi}/menus'),
      headers: headers,
      body: body,
    );

    setState(() => isLoading = false);

    if (res.statusCode == 200 || res.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Menu berhasil ditambahkan.")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: ${res.statusCode}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blackMain,
      appBar: AppBar(
        title: const Text('Tambah Menu'),
        backgroundColor: AppColor.blackMain,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FadeInUp(
        // <-- animasi elegan
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
                border: Border.all(color: Colors.white24, width: 1),
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
                    'Form Tambah Menu',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildField(
                    controller: nameController,
                    label: 'Nama Menu',
                    icon: Icons.fastfood,
                  ),
                  const SizedBox(height: 15),
                  _buildField(
                    controller: descController,
                    label: 'Deskripsi',
                    icon: Icons.description,
                  ),
                  const SizedBox(height: 15),
                  _buildField(
                    controller: priceController,
                    label: 'Harga',
                    keyboardType: TextInputType.number,
                    icon: Icons.attach_money,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image_outlined),
                        label: const Text('Pilih Gambar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (base64Image != null)
                        const Icon(Icons.check_circle, color: Colors.green),
                    ],
                  ),
                  if (base64Image != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          base64Decode(base64Image!.split(',').last),
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : _submit,
                    icon: const Icon(Icons.save),
                    label:
                        isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              'Simpan Menu',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
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

  Widget _buildField({
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
        fillColor: AppColor.blackMain,
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
