class TheatreModel {
  final String id;
  final String name;
  final String city;
  final String location;
  final String email;
  final String status;
  final String? pincode;
  final String? landmark;
  final String? state;
  final String? street;
  final double? lat;
  final double? lng;
  final List<String> images; 

  TheatreModel({
    required this.id,
    required this.name,
    required this.city,
    required this.location,
    required this.email,
    required this.status,
    this.pincode,
    this.landmark,
    this.state,
    this.street,
    this.lat,
    this.lng,
    required this.images,
  });

  
  factory TheatreModel.fromMap(Map<String, dynamic> map, String id) {
    return TheatreModel(
      id: id,
      name: map['name'] ?? '',
      city: map['city'] ?? '',
      location: map['location'] ?? '',
      email: map['email'] ?? '',
      status: map['status'] ?? '',
      pincode: map['pincode'],
      landmark: map['landmark'],
      state: map['state'],
      street: map['street'],
      lat: (map['lat'] is num) ? map['lat'].toDouble() : null,
      lng: (map['lng'] is num) ? map['lng'].toDouble() : null,
      images: (map['images'] != null)
          ? List<String>.from(map['images'])
          : [], // ✅ safely parse
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'location': location,
      'email': email,
      'status': status,
      'pincode': pincode,
      'landmark': landmark,
      'state': state,
      'street': street,
      'lat': lat,
      'lng': lng,
      'images': images,
    };
  }

  
  TheatreModel copyWith({
    String? id,
    String? name,
    String? city,
    String? location,
    String? email,
    String? status,
    String? pincode,
    String? landmark,
    String? state,
    String? street,
    double? lat,
    double? lng,
    List<String>? images,
  }) {
    return TheatreModel(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      location: location ?? this.location,
      email: email ?? this.email,
      status: status ?? this.status,
      pincode: pincode ?? this.pincode,
      landmark: landmark ?? this.landmark,
      state: state ?? this.state,
      street: street ?? this.street,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      images: images ?? this.images,
    );
  }

  @override
  String toString() {
    return 'TheatreModel(id: $id, name: $name, city: $city, location: $location, email: $email, '
        'status: $status, images: $images, lat: $lat, lng: $lng, landmark: $landmark, street: $street, state: $state, pincode: $pincode)';
  }
}
