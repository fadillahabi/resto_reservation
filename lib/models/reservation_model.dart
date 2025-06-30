class ReservationModel {
  final int id;
  final int userId;
  final String reservedAt;
  final int guestCount;
  final String notes;

  ReservationModel({
    required this.id,
    required this.userId,
    required this.reservedAt,
    required this.guestCount,
    required this.notes,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'],
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      reservedAt: json['reserved_at'] ?? '',
      guestCount: int.tryParse(json['guest_count'].toString()) ?? 0,
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'reserved_at': reservedAt,
      'guest_count': guestCount,
      'notes': notes,
    };
  }
}
