class RoomType {
  final int id;
  final String roomType;

  RoomType({required this.id, required this.roomType});

  factory RoomType.fromJson(Map<String, dynamic> json) {
    return RoomType(
      id: json['ID'],
      roomType: json['RoomType'],
    );
  }
}
