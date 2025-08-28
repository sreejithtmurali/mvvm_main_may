import 'package:mvvm_main_may/app/app.router.dart';
import 'package:mvvm_main_may/app/utils.dart';

import 'package:stacked/stacked.dart';

import '../../../models/User.dart';

class SplashViewModel extends BaseViewModel{
  init(){
    Future.delayed(Duration(seconds: 3));
    navigate();
  }

  Future<void> navigate() async {
    if(await userservice.isLoggedIn())
    {
     User ?user =await userservice.getUser();
     notifyListeners();
     navigationService.pushNamedAndRemoveUntil(Routes.homeView,arguments: HomeViewArguments(user: user!));
    }
    else{
      navigationService.pushNamedAndRemoveUntil(Routes.loginView);
    }
  }
}