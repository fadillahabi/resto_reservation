// Define the MenuModel class to represent a single menu item.
class MenuModel {
  final int id;
  final String name;
  final String description;
  final String price; // Keeping as String to match the JSON "25000.00" format
  final String? imageUrl; // image_url can be null

  // Constructor for MenuModel.
  MenuModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
  });

  // Factory constructor to create a MenuModel instance from a JSON map.
  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      imageUrl: json['image_url'] as String?, // Can be null
    );
  }

  // Method to convert a MenuModel instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
    };
  }
}

// Define the MenuListResponse class to represent the full API response.
class MenuListResponse {
  final String message;
  final List<MenuModel> data;

  // Constructor for MenuListResponse.
  MenuListResponse({required this.message, required this.data});

  // Factory constructor to create a MenuListResponse instance from a JSON map.
  factory MenuListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    // Map each item in the list to a MenuModel using its fromJson constructor.
    List<MenuModel> menuList = list.map((i) => MenuModel.fromJson(i)).toList();

    return MenuListResponse(message: json['message'] as String, data: menuList);
  }

  // Method to convert a MenuListResponse instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((menu) => menu.toJson()).toList(),
    };
  }
}
