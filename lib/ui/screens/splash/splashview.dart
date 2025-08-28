import 'package:mvvm_main_may/constants/assets.gen.dart';
import 'package:mvvm_main_may/ui/screens/splash/splashviewmodel.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Splashview extends StatelessWidget {
  const Splashview({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      onDispose: (model) {},
      onViewModelReady: (model) {
         model.init();
      },
      viewModelBuilder: () {
        return SplashViewModel();
      },
      builder:
          (BuildContext context, SplashViewModel viewModel, Widget? child) {
            return Scaffold(
              body: Center(
                child: Assets.images.logo.image(
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
    );
  }
}
