import 'package:mvvm_main_may/ui/screens/login/loginview.dart';
import 'package:mvvm_main_may/ui/screens/splash/splashview.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/api_services.dart';
import '../services/connectivity_service.dart';
import '../services/user_service.dart';
import '../ui/screens/home/homeview.dart';



@StackedApp(
  routes: [
    MaterialRoute(page: Splashview, initial: true),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: HomeView),
  ],
  dependencies: [
    LazySingleton(classType: ApiService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: ConnectivityService),
  ],
)
class AppSetUp {}
