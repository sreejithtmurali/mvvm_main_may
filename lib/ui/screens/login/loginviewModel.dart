// loginviewModel.dart - Updated with connectivity monitoring
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mvvm_main_may/app/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:mvvm_main_may/models/User.dart';

class LoginViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool _isConnected = true;
  StreamSubscription<bool>? _connectivitySubscription;

  bool get isConnected => _isConnected;

  @override
  void onFutureError(error, Object? key) {
    super.onFutureError(error, key);
    // Handle connectivity errors specifically
    if (error.toString().contains("No Internet Connection")) {
      // You can show a different UI state for no connection
    }
  }

  /// Initialize connectivity monitoring when ViewModel is created
  void initialize() {
    _setupConnectivityListener();
  }

  /// Setup connectivity listener
  void _setupConnectivityListener() {
    _connectivitySubscription = connectivityService.connectionStream.listen(
          (isConnected) {
        _isConnected = isConnected;
        notifyListeners();

        if (!isConnected) {
          // You can show a snackbar or dialog here
          debugPrint("Connection lost!");
        } else {
          debugPrint("Connection restored!");
        }
      },
    );
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  /// Check connectivity status
  Future<bool> checkConnectivity() async {
    final isConnected = await connectivityService.checkConnectivity();
    _isConnected = isConnected;
    notifyListeners();
    return isConnected;
  }

  /// Get connectivity type
  Future<String> getConnectivityType() async {
    return await connectivityService.getConnectivityType();
  }

  /// Login method with connectivity check
  Future<bool> login() async {
    setBusy(true);

    try {
      // Check connectivity before proceeding
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        throw Exception("No Internet Connection. Please check your network settings.");
      }

      User user = await apiservice.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      setBusy(false);
      return true; //
    } catch (e) {
      setBusy(false);
      // Re-throw so View can catch ApiException and display message
      throw e;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}