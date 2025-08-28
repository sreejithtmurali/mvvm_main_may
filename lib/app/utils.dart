

import 'package:mvvm_main_may/services/api_services.dart';
import 'package:mvvm_main_may/services/connectivity_service.dart';
import 'package:mvvm_main_may/services/user_service.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';

NavigationService get navigationService => locator<NavigationService>();

ApiService get apiservice => locator<ApiService>();

ConnectivityService get connectivityService => locator<ConnectivityService>();