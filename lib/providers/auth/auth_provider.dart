import 'package:carmarketapp/models/api/user/user_model.dart';
import 'package:carmarketapp/reprositories/auth/auth_repository.dart';
import 'package:flutter/material.dart';

import '../../Cache/auth_storage.dart';
import '../../core/errors/failure.dart';
import '../../core/helpers/api_helpers/api_response.dart';
import '../../models/api/auth/auth_response_model.dart';

class AuthProvider extends ChangeNotifier {
  late AuthRepository _authRepository;
  late AuthStorage _authStorage;
  late ApiResponse<AuthResponseModel> _login = ApiResponse.initial('initial');
  late ApiResponse<String> _forgetPass = ApiResponse.initial('initial');
  late ApiResponse<String> _resetPasswordResponse = ApiResponse.initial('initial');
  late ApiResponse<String> _verifyOtp = ApiResponse.initial('initial');
  late ApiResponse<UserModel> _register = ApiResponse.initial('initial');
  bool isLoading=false;
  ApiResponse<AuthResponseModel> get login => _login;
  String _email='';
  String get email=> _email;
  ApiResponse<String> get verifyOtpResponse=> _verifyOtp;
  ApiResponse<UserModel> get register => _register;
  ApiResponse<String> get forgetPassResponse=> _forgetPass;
  ApiResponse<String> get resetPasswordResponse=> _resetPasswordResponse;
  String get username {
    return _login.data?.user.username ??
        _authStorage.getName ??
        '';
  }

  AuthProvider() {
    _authRepository = AuthRepository();
    _authStorage = AuthStorage();
  }

  saveEmail({required String email}){
    _email=email;
    notifyListeners();
  }


  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    _login = ApiResponse.loading('Loading');
    notifyListeners();

    try {
      final AuthResponseModel? response = await _authRepository.login(
        email: email,
        password: password,
      );

      _login = ApiResponse.completed(response);
      _authStorage.saveAuth(response);
    } catch (e) {
      _login = ApiResponse.error(handleException(e));
    }

    notifyListeners();
  }
  void loadUserFromStorage() {
    final token = _authStorage.getToken();
    if (token.isEmpty) return;

    _login = ApiResponse.completed(
      AuthResponseModel(
        token: token,
        user: UserModel(
          username: _authStorage.getName,
          email: _authStorage.getEmail,
          isSeller: _authStorage.getRole(),
        ),
      ),
    );

    notifyListeners();
  }


  void updateUsername(String newName) {
    // حدّث التخزين
    _authStorage.setUserName(newName);

    // حدّث ال state الداخلي
    if (_login.data?.user != null) {
      _login.data?.user.username = newName;
    }

    notifyListeners();
  }

  Future<UserModel?> registerUser(
      {required String email,
      required String password,
      required bool isSeller,
      required String username,
      required String whatsapp}) async
  {
    _register = ApiResponse.loading('Loading');

    isLoading=true;

    notifyListeners();
    try {
      final response = await _authRepository.register(
        email: email,
        password: password,
        isSeller: isSeller,
        username: username,
        whatsapp: whatsapp,
      );

      _register = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      print("err $e");

      String message;

      if (e.toString().contains("name") ||
          e.toString().contains("username")) {
        message = "This username is already taken. Please try another one.";
      } else {
        message = handleException(e);
      }

      _register = ApiResponse.error(message);
      notifyListeners();
    }

    return null;}

    Future<UserModel?> forgetPassword(
      {required String email}) async
{
    _forgetPass = ApiResponse.loading('Loading');

    notifyListeners();
    // print(password+username+email+whatsapp);
    try {
      final response = await _authRepository.forgetPassword(
          email: email,
       );
      print(response);
      _forgetPass = ApiResponse.completed(response);
      isLoading=false;

      notifyListeners();
    } catch (e) {
      print("err $e");
      String message = handleException(e);
      _forgetPass = ApiResponse.error(message);


      notifyListeners();
    }
    return null;
  }
  Future<void> resetPassword(
      {required String password}) async
{
    _resetPasswordResponse = ApiResponse.loading('Loading');

    notifyListeners();
    // print(password+username+email+whatsapp);
    try {
      final response = await _authRepository.resetPassword(
          email: email,
          newPassword:password
       );
      print(response);
      _resetPasswordResponse = ApiResponse.completed(response);

      notifyListeners();
    } catch (e) {
      print("err $e");
      String message = handleException(e);
      _resetPasswordResponse = ApiResponse.error(message);
      isLoading=false;


      notifyListeners();
    }
  }


  Future<UserModel?> verifyOtp(
      {required String otp}) async
{
  _verifyOtp = ApiResponse.loading('Loading');
  isLoading=true;

  notifyListeners();
    // print(password+username+email+whatsapp);
    try {
      final response = await _authRepository.verifyOtp(
          email: email,
          otp: otp
       );
      print(response);
      _verifyOtp = ApiResponse.completed(response);

      notifyListeners();
    } catch (e) {
      print("err $e");
      String message = handleException(e);
      _verifyOtp = ApiResponse.error(message);

      notifyListeners();
    }
    return null;
  }



  String handleException(dynamic e) {
    print(e.runtimeType);
    if (e is ServerFailure) {
      return e.message;
    } else if (e is OfflineFailure) {
      return "No Internet Connection , please try again !";
    } else {
      return "Unexpected Error , please try again !";
    }
  }
}
