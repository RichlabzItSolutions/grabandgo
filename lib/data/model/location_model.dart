
class Location {
  final int id;
  final String location;
  final String clientLocationId;
  final int status;
  final String createdOn;

  Location({
    required this.id,
    required this.location,
    required this.clientLocationId,
    required this.status,
    required this.createdOn,
  });

  // Factory method to create an instance from JSON
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      location: json['location'],
      clientLocationId: json['clientLocationId'],
      status: json['status'],
      createdOn: json['createdOn'],
    );
  }
}
