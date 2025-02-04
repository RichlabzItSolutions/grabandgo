class UserProfile {
  String? name;   // Nullable field
  String? mobile; // Nullable field
  int? gender;    // Nullable field

  UserProfile({
    this.name,
    this.mobile,
    this.gender,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String?,    // Handle possible null value
      mobile: json['mobile'] as String?, // Handle possible null value
      gender: json['gender'] as int?,    // Handle possible null value
    );
  }

  // You can also create a toJson method for serialization:
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile': mobile,
      'gender': gender,
    };
  }
}
