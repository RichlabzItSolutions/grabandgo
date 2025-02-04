class VerifyOtpModelRequest{
  String mobile;
  String otp;
  VerifyOtpModelRequest({required this.mobile,required this.otp});
  factory VerifyOtpModelRequest.fromJson(Map<String, dynamic> json) => VerifyOtpModelRequest(
    mobile: json['mobile'],
    otp: json['otp'],
  );


}