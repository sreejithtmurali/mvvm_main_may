import 'package:mvvm_main_may/constants/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../models/User.dart';
import 'homeviewmodel.dart';

class HomeView extends StatelessWidget {
 late User user;
   HomeView({required this.user});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      onDispose: (model) {},
      onViewModelReady: (model) {

      },
      viewModelBuilder: () {
        return HomeViewModel(user: user);
      },
      builder:
          (BuildContext context, HomeViewModel viewModel, Widget? child) {
            return Scaffold(
              appBar: AppBar(
                title: Text("welcome ${viewModel.user.name??"sir"}"),
                actions: [
                  IconButton(onPressed: (){
                    viewModel.logout();
                  }, icon: Icon(Icons.power_settings_new_sharp))
                ],
              ),

            );
          },
    );
  }
}
