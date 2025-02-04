class HelpCenter {
  final int id;
  final String email;
  final String mobile;
  final String address; // Make it non-nullable but provide a default value

  HelpCenter({
    required this.id,
    required this.email,
    required this.mobile,
    required this.address,
  });

  // Factory method to create an instance of HelpCenter from JSON
  factory HelpCenter.fromJson(Map<String, dynamic> json) {
    return HelpCenter(
      id: json['id'] ?? 0, // Ensure id is not null
      email: json['email'] ?? '', // Ensure email is not null
      mobile: json['mobile'] ?? '', // Ensure mobile is not null
      address: json['address'] ?? 'Not Available', // Provide a default value if null
    );
  }

  // Method to convert HelpCenter instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'mobile': mobile,
      'address': address, // No need for null check since it's now non-nullable
    };
  }
}
