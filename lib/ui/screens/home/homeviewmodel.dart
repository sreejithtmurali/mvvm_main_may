import 'package:mvvm_main_may/app/app.router.dart';
import 'package:mvvm_main_may/app/utils.dart';

import 'package:stacked/stacked.dart';

import '../../../models/User.dart';

class HomeViewModel extends BaseViewModel{
  late User user;

  HomeViewModel({required this.user});

  Future<void> logout() async {
    await userservice.logout();
    navigationService.pushNamedAndRemoveUntil(Routes.loginView);
  }
}