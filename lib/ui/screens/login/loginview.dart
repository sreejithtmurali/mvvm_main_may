// loginview.dart - Updated with connectivity UI indicators
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:mvvm_main_may/constants/app_colors.dart';
import 'package:mvvm_main_may/constants/app_strings.dart';
import 'package:mvvm_main_may/constants/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_main_may/ui/tools/smart_dialog_config.dart';
import 'package:stacked/stacked.dart';

import 'loginviewModel.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      onViewModelReady: (viewModel) => viewModel.initialize(),
      builder: (BuildContext context, LoginViewModel viewModel, Widget? child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Connectivity Status Bar
                _buildConnectivityStatusBar(viewModel),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: viewModel.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.appName,
                            style: TextStyle(
                              color: Palette.heddingcolor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Assets.images.logo.image(height: 100, width: 100),
                          const SizedBox(height: 30),

                          /// Email Field
                          TextFormField(
                            controller: viewModel.emailController,
                            keyboardType: TextInputType.emailAddress,
                            enabled: !viewModel.isBusy,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter email";
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          /// Password Field
                          TextFormField(
                            controller: viewModel.passwordController,
                            obscureText: !viewModel.isPasswordVisible,
                            enabled: !viewModel.isBusy,
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(viewModel.isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: viewModel.togglePasswordVisibility,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter password";
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),

                          /// Login Button
                          ElevatedButton(
                            onPressed: viewModel.isBusy || !viewModel.isConnected
                                ? null
                                : () async {
                              if (viewModel.formKey.currentState!.validate()) {
                                try {
                                  bool status = await viewModel.login();
                                  if (status) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("✅ Login Success")),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("❌ ${e.toString()}")),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: !viewModel.isConnected
                                  ? Colors.grey
                                  : null,
                            ),
                            child: viewModel.isBusy
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : Text(!viewModel.isConnected
                                ? "No Internet Connection"
                                : "Login"),
                          ),

                          const SizedBox(height: 20),

                          // Connectivity Info Button
                          if (!viewModel.isConnected)
                            TextButton.icon(
                              onPressed: () async {
                                final connectivityType = await viewModel.getConnectivityType();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Connection Status: $connectivityType"),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.info_outline),
                              label: const Text("Check Connection"),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build connectivity status bar
  Widget _buildConnectivityStatusBar(LoginViewModel viewModel) {
    if (viewModel.isConnected) {
      // return Container(
      //   width: double.infinity,
      //   padding: const EdgeInsets.symmetric(vertical: 8),
      //   color: Colors.green,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: const [
      //       Icon(Icons.wifi, color: Colors.white, size: 16),
      //       SizedBox(width: 8),
      //       Text(
      //         "Connected",
      //         style: TextStyle(color: Colors.white, fontSize: 12),
      //       ),
      //     ],
      //   ),
      // );
      return Container();
    } else {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.wifi_off, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text(
              "No Internet Connection",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      );
    }
  }
}