class ReservationModel {
  final int id;
  final int userId;
  final int guestCount;
  final String reservedAt;
  final String notes;

  ReservationModel({
    required this.id,
    required this.userId,
    required this.guestCount,
    required this.reservedAt,
    required this.notes,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      guestCount: int.parse(json['guest_count'].toString()),
      reservedAt: json['reserved_at'],
      notes: json['notes'] ?? '',
    );
  }
}
