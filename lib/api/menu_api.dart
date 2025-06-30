import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ppkd_flutter/api/endpoint.dart';
import 'package:ppkd_flutter/helper/shared_preference.dart';
import 'package:ppkd_flutter/models/menu_model.dart';

class MenuApi {
  static Future<List<MenuModel>> fetchMenus() async {
    final token = await PreferenceHandlerPM.getToken();
    final response = await http.get(
      Uri.parse('${Endpoint.baseUrlApi}/menus'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      if (decoded['data'] is! List) throw Exception('Format JSON tidak sesuai');
      final List jsonList = decoded['data'];
      return jsonList.map((e) => MenuModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data menu');
    }
  }

  // Edit Menu
  static Future<bool> updateMenu(MenuModel menu) async {
    final token = await PreferenceHandlerPM.getToken();

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final body = {
      'name': menu.name,
      'description': menu.description,
      'price': menu.price,
    };

    // Kirim gambar hanya jika ada (dalam base64)
    if (menu.image.isNotEmpty) {
      body['image'] = menu.image;
    }

    final response = await http.put(
      Uri.parse('${Endpoint.baseUrlApi}/menus/${menu.id}'),
      headers: headers,
      body: jsonEncode(body),
    );

    print("Update response: ${response.statusCode}");
    print("Body: ${response.body}");

    return response.statusCode == 200 || response.statusCode == 201;
  }

  // Delete Menu
  static Future<bool> deleteMenu(int id) async {
    final token = await PreferenceHandlerPM.getToken();
    final response = await http.delete(
      Uri.parse('${Endpoint.baseUrlApi}/menus/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    return response.statusCode == 200;
  }
}
