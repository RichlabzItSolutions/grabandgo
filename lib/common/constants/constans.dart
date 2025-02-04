class AppConstants {
  // Define the base URL here
  static const String baseUrl = "https://richlabzit.com/ecom/api/";

  // Function to capitalize the first letter of a string and keep the rest lowercase
  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    String firstLetter = text[0].toUpperCase();
    String remainingLetters = text.substring(1).toLowerCase();
    return firstLetter + remainingLetters;
  }
}
