class RequestUserData {
  final String  mobile;

  RequestUserData({required this.mobile});
  factory RequestUserData.fromJson(Map<String, dynamic> json) {
    return RequestUserData(
        mobile: json['mobile']
    );
  }
}