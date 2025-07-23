class AppConstants {
  static const String appName = 'NearBy Deals';
  
  // API URLs
  static const String baseUrl = 'http://localhost:3000/api';
  static const String authUrl = '$baseUrl/auth';
  static const String offersUrl = '$baseUrl/offers';
  static const String usersUrl = '$baseUrl/users';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  
  // Asset Paths
  static const String logoPath = 'assets/images/logo.png';
  static const String placeholderPath = 'assets/images/placeholder.png';
  
  // Map
  static const double defaultZoom = 15.0;
  static const double defaultRadius = 5000; // 5km in meters
}
