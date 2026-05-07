class Review {
  final int id;
  final int doctorId;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final String? doctorName;

  Review({
    required this.id,
    required this.doctorId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.doctorName,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      doctorId: json['doctor_id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
      doctorName: json['doctor_name'],
    );
  }
}