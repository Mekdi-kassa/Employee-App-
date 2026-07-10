import 'package:employee_app/core/constant/api_exception.dart';
import 'package:employee_app/core/constant/shared_prefs.dart';
import 'package:employee_app/features/login/data/login_service.dart';
import 'package:flutter/material.dart';


class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoggedIn = SharedPrefs.isLoggedIn();
  bool _isDarkMode = SharedPrefs.getDarkMode() ?? false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void initializeSystemTheme(bool isSystemDark) {
    final savedTheme = SharedPrefs.getDarkMode();
    if (savedTheme == null) {
      _isDarkMode = isSystemDark;
    }
  }

  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    await SharedPrefs.setDarkMode(value);
    notifyListeners();
  }

  Future<bool> login(String identity, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.requestLogin(identity, password);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _isLoggedIn = true;
        await SharedPrefs.setLoggedIn(true);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An internal system execution fault occurred.';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _errorMessage = null;
    await SharedPrefs.clearAuthData();
    notifyListeners();
  }
}

class AuthScope extends InheritedNotifier<AuthProvider> {
  const AuthScope({super.key, required AuthProvider auth, required super.child})
      : super(notifier: auth);

  static AuthProvider of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthScope>();
    assert(scope != null, 'AuthScope not found in widget tree.');
    return scope!.notifier!;
  }
}