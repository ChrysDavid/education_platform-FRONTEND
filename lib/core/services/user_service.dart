// services/user_service.dart
import 'package:education_platform_frontend_flutter/core/constants/api_endpoints.dart';
import 'package:education_platform_frontend_flutter/core/models/user_model.dart';
import 'package:education_platform_frontend_flutter/core/services/api_service.dart';
import 'package:education_platform_frontend_flutter/core/services/auth_provider.dart';

class UserService {
  
  static Future<List<UserModel>> getUsersByType(
    String userType, {
    required AuthProvider authProvider,
  }) async {
    try {
      final token = await authProvider.getValidToken();
      if (token == null) throw Exception('Non authentifié');
      
      final url = '${ApiEndpoints.usersByType}$userType/';
      final response = await ApiService.get(url: url, token: token);
      
      final results = response['results'] as List;
      return results.map((userJson) => UserModel.fromJson(userJson)).toList();
    } catch (e) {
      print('Erreur dans getUsersByType: $e');
      throw Exception('Échec du chargement des utilisateurs: ${e.toString()}');
    }
  }

  static Future<UserModel> getUserDetails(int userId) async {
    try {
      final response = await ApiService.get(
        url: ApiEndpoints.userDetail(userId),
      );
      
      if (response == null) throw Exception('Réponse vide du serveur');
      
      return UserModel.fromJson(response);
    } catch (e) {
      print(e);
      throw Exception('Failed to load user details: ${e.toString()}');
    }
  }
}