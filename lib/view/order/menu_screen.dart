import 'package:flutter/material.dart';
import 'package:ppkd_flutter/api/menu_api.dart'; // Make sure this path is correct
import 'package:ppkd_flutter/constant/app_color.dart';
import 'package:ppkd_flutter/models/menu_model.dart'; // Import your MenuModel

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // Change the Future type to List<MenuModel> to match your model
  late Future<List<MenuModel>> _menuFuture;

  @override
  void initState() {
    super.initState();
    // Initialize _menuFuture by calling the fetchMenu method from MenuApiService
    _menuFuture = fetchMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pesan Makanan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.blackMain,
      ),
      // Update FutureBuilder to expect List<MenuModel>
      body: FutureBuilder<List<MenuModel>>(
        future: _menuFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Display an error message if fetching data fails
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada menu yang tersedia."));
          }

          final menus = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: menus.length,
            itemBuilder: (context, index) {
              final item = menus[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF1E1E1E,
                  ), // Dark background for menu item
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      child:
                          item.imageUrl != null && item.imageUrl!.isNotEmpty
                              ? Image.network(
                                item.imageUrl!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                // Add error handling for network images
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey,
                                      child: const Icon(
                                        Icons.broken_image,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                              )
                              : Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey, // Placeholder color
                                child: const Icon(
                                  Icons.fastfood,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  // Format price as currency
                                  "Rp ${item.price.replaceAll(".00", "")}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    // Action to add item to cart
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${item.name} ditambahkan ke keranjang!',
                                        ),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
