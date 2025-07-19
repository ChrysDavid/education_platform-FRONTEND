class ApiEndpoints {
  static const String baseUrl = "https://chrys.pythonanywhere.com/api/accounts/";
  
  // Auth
  static const String login = "${baseUrl}login/";
  static const String refreshToken = "${baseUrl}refresh/";
  static const String logout = "${baseUrl}logout/";

  // Users
  static const String users = "${baseUrl}users/";
  static const String usersByType = "${baseUrl}users/type/";
  static String userDetail(int userId) => "${baseUrl}users/profile/$userId/";
  
  // Registration
  static const String register = "${baseUrl}register/";
  static const String registerStudent = "${baseUrl}register/student/";
  static const String registerPupil = "${baseUrl}register/pupil/"; 
  static const String registerTeacher = "${baseUrl}register/teacher/";
  static const String registerAdvisor = "${baseUrl}register/advisor/";
  
  // Profile
  static const String userProfile = "${baseUrl}profile/";
  static const String changePassword = "${baseUrl}profile/password/";
  static const String uploadProfilePicture = "${baseUrl}profile/picture/";
  
  // Specific profiles
  static const String studentProfile = "${baseUrl}profile/student/";
  static const String teacherProfile = "${baseUrl}profile/teacher/";
  static const String advisorProfile = "${baseUrl}profile/advisor/";
  
  // Verification
  static const String requestVerification = "${baseUrl}verification/request/";
  static const String verificationStatus = "${baseUrl}verification/status/";
  
  // Password Reset
  static const String passwordResetRequest = "${baseUrl}password/reset/";

  // Notification
  static const String notifications = "$baseUrl/notifications/";
}