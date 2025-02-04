class HelpRequest {
  final int userId;
  final String subject;
  final String message;

  HelpRequest({
    required this.userId,
    required this.subject,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'subject': subject,
      'message': message,
    };
  }
}
