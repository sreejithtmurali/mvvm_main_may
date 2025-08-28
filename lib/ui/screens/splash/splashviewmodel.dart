import 'package:mvvm_main_may/app/app.router.dart';
import 'package:mvvm_main_may/app/utils.dart';

import 'package:stacked/stacked.dart';

class SplashViewModel extends BaseViewModel{
  init(){
    Future.delayed(Duration(seconds: 3),(){
      navigationService.navigateTo(Routes.loginView);
    });
  }
}