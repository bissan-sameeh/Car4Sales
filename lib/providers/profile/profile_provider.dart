import 'package:carmarketapp/Cache/auth_storage.dart';
import 'package:carmarketapp/core/helpers/api_helpers/api_response.dart';
import 'package:carmarketapp/models/api/user/user_model.dart';
import 'package:carmarketapp/reprositories/profile_repository/profile_repository.dart';
import 'package:flutter/material.dart';

import '../../../core/errors/failure.dart';
import '../../../core/errors/excpations.dart';

class ProfileProvider extends ChangeNotifier {
  late final ProfileRepository _profileRepository;
  late final AuthStorage auth;

  bool isLoading = false;

  ApiResponse<UserModel> _updateProfile =
  ApiResponse.initial("idle");

  ApiResponse<UserModel> get updateProfile => _updateProfile;

  ProfileProvider() {
    _profileRepository = ProfileRepository();
    auth = AuthStorage();
  }

  Future<void> updateUserProfile({
    String? name,
    String? whatsapp,
  }) async {
    isLoading = true;
    _updateProfile = ApiResponse.loading("Updating profile...");
    notifyListeners();

    try {
      final response = await _profileRepository.updateProfile(
        name: name,
        whatsapp: whatsapp,
      );

      _updateProfile = ApiResponse.completed(response);

      /// update local cache
      auth.setUserName(response.username ?? '');
      auth.setWhatsApp(response.whatsapp ?? '');

    } catch (error) {
      if (error is Failure) {
        _updateProfile =
            ApiResponse.error(mapFailureToMessage(error));
      } else {
        _updateProfile =
            ApiResponse.error("Something went wrong");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
