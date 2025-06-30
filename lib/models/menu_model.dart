class MenuModel {
  final int id;
  final String name;
  final String description;
  final double price; // ⬅️ Ubah jadi double
  final String image;
  final String imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MenuModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price, // ⬅️ double
    required this.image,
    required this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id:
          json['id'] is int
              ? json['id']
              : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price:
          double.tryParse(json['price'].toString()) ??
          0.0, // ⬅️ ubah jadi double
      image: json['image'] ?? '',
      imageUrl: json['image_url'] ?? '',
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
    );
  }
}
