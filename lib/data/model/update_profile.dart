class UpdateProfile {
  int userId;
  String name;
  int gender;

  UpdateProfile({
    required this.userId,
    required this.name,
    required this.gender,
  });

  // From JSON constructor
  factory UpdateProfile.fromJson(Map<String, dynamic> json) {
    return UpdateProfile(
      userId: json['userId'] ?? 0,
      name: json['name'] ?? '',
      gender: json['gender'] ?? 1, // Default to 1 (Male) if no gender is provided
    );
  }

  // To JSON method for updating the profile
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'gender': gender,
    };
  }
}
