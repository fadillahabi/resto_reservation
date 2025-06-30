import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ppkd_flutter/api/menu_api.dart';
import 'package:ppkd_flutter/constant/app_color.dart';
import 'package:ppkd_flutter/models/menu_model.dart';

class EditMenuPage extends StatefulWidget {
  final MenuModel menu;

  const EditMenuPage({super.key, required this.menu});
  static const String id = "/edit_menu";

  @override
  State<EditMenuPage> createState() => _EditMenuPageState();
}

class _EditMenuPageState extends State<EditMenuPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  bool _isLoading = false;
  String base64Image = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.menu.name);
    _descriptionController = TextEditingController(
      text: widget.menu.description,
    );
    _priceController = TextEditingController(
      text: widget.menu.price.toString(),
    );
    base64Image = widget.menu.image ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      final bytes = await pickedImage.readAsBytes();
      setState(() {
        base64Image =
            'data:image/${pickedImage.path.split('.').last};base64,${base64Encode(bytes)}';
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final updatedMenu = MenuModel(
      id: widget.menu.id,
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,

      image: base64Image,
      imageUrl: widget.menu.imageUrl, // ✅ tambahkan ini
      createdAt: widget.menu.createdAt,
      updatedAt: DateTime.now(),
    );

    try {
      await MenuApi.updateMenu(updatedMenu);
      if (!mounted) return;
      Navigator.pop(context, true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Menu berhasil diperbarui')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan perubahan: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteMenu() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Konfirmasi Hapus'),
            content: const Text('Yakin ingin menghapus menu ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );

    if (confirm != true) return;
    setState(() => _isLoading = true);

    try {
      await MenuApi.deleteMenu(widget.menu.id);
      if (!mounted) return;
      Navigator.pop(context, true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Menu berhasil dihapus')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus menu: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blackMain,
      appBar: AppBar(
        title: const Text('Edit Menu'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: _deleteMenu),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(controller: _nameController, label: 'Nama Menu'),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _descriptionController,
                label: 'Deskripsi',
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _priceController,
                label: 'Harga',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image, color: Colors.white),
                    label: const Text('Ganti Gambar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.blackField,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (base64Image.isNotEmpty)
                    const Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
              if (base64Image.isNotEmpty) ...[
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    base64Decode(base64Image.split(',').last),
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
