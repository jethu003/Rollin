class TheatreEntity {
  final String name;
  final String city;
  final String state;
  final String street;
  final String landmark;
  final String location;
  final String pincode;
  final String email;
  final double lat;
  final double lng;
  final List<String> images;

  TheatreEntity({
    required this.name,
    required this.city,
    required this.state,
    required this.street,
    required this.landmark,
    required this.location,
    required this.pincode,
    required this.email,
    required this.lat,
    required this.lng,
    required this.images,
  });
}