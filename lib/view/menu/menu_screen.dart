import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ppkd_flutter/api/menu_api.dart';
import 'package:ppkd_flutter/constant/app_color.dart';
import 'package:ppkd_flutter/models/menu_model.dart';
import 'package:ppkd_flutter/view/menu/edit_menu.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  static const String id = "/menu_screen";

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<MenuModel> _menus = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMenus();
  }

  Future<void> _fetchMenus() async {
    try {
      final menus = await MenuApi.fetchMenus();
      setState(() {
        _menus = menus;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat menu: $e')));
    }
  }

  Widget _fallbackImage() {
    return Container(
      color: Colors.grey[300],
      width: 80,
      height: 80,
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image, size: 32, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blackMain,
      appBar: AppBar(
        title: const Text("Daftar Menu"),
        backgroundColor: AppColor.blackMain,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _fetchMenus,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _menus.length,
                  itemBuilder: (context, index) {
                    final menu = _menus[index];
                    final imageUrl = menu.imageUrl ?? '';
                    return Card(
                      color: AppColor.blackField,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditMenuPage(menu: menu),
                            ),
                          );
                          if (updated == true) _fetchMenus();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    imageUrl.isNotEmpty
                                        ? Image.network(
                                          imageUrl,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress == null)
                                              return child;
                                            return SizedBox(
                                              width: 80,
                                              height: 80,
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.orange),
                                                ),
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (_, __, ___) => _fallbackImage(),
                                        )
                                        : _fallbackImage(),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      menu.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      menu.description,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'id_ID',
                                        symbol: 'Rp ',
                                        decimalDigits: 0,
                                      ).format(menu.price),
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
