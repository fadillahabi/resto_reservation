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

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List jsonList = jsonDecode(response.body)['data'];
      return jsonList.map((e) => MenuModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data menu');
    }
  }

  // Edit Menu
  static Future<bool> updateMenu(MenuModel menu) async {
    final token = await PreferenceHandlerPM.getToken();
    final response = await http.put(
      Uri.parse('${Endpoint.baseUrlApi}/menus/${menu.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': menu.name,
        'description': menu.description,
        'price': menu.price,
      }),
    );

    return response.statusCode == 200;
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
