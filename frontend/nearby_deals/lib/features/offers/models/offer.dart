class Offer {
  final String id;
  final String sellerId;
  final String sellerName;
  final String title;
  final String description;
  final double price;
  final double discount;
  final DateTime startDate;
  final DateTime endDate;
  final Location location;
  final String category;
  final DateTime createdAt;
  final List<String> images;
  final double? distance;

  Offer({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.title,
    required this.description,
    required this.price,
    required this.discount,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.category,
    required this.createdAt,
    required this.images,
    this.distance,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['offer_id'].toString(),
      sellerId: json['seller_id'].toString(),
      sellerName: json['seller_name'] ?? '',
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      discount: json['discount']?.toDouble() ?? 0.0,
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      location: Location(
        latitude: json['latitude'].toDouble(),
        longitude: json['longitude'].toDouble(),
      ),
      category: json['category'],
      createdAt: DateTime.parse(json['created_at']),
      images: List<String>.from(json['images'] ?? []),
      distance: json['distance']?.toDouble(),
    );
  }

  double get discountedPrice => price - (price * (discount / 100));

  bool get isExpired => DateTime.now().isAfter(endDate);

  String get formattedDiscount => '${discount.toStringAsFixed(0)}% OFF';
}

class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };
}
