import 'package:flutter/material.dart';

class ScreenSize {
  static late MediaQueryData data;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double width;
  static late double buttonheight;
  static late double height;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  static void init(BuildContext context) {
    data = MediaQuery.of(context);
    width = data.size.width;
    height = data.size.height;
    buttonheight=50;
    blockSizeHorizontal = width / 100;
    blockSizeVertical = height / 100;
    _safeAreaHorizontal = data.padding.left + data.padding.right;
    _safeAreaVertical = data.padding.top + data.padding.bottom;
    safeBlockHorizontal = (width - _safeAreaHorizontal) / 100;
    safeBlockVertical = (height - _safeAreaVertical) / 100;
  }
  //892 hight in figma file
 static double getheight(double itemheight){
     var persent=(itemheight/892)*100;
     var myheight=(height/100)*persent;
     return myheight;
  }
  //360 width in figma file
 static double getWidth(double itemWidth){
    var persent=(itemWidth/360)*100;
    var mywidth=(width/100)*persent;
    return mywidth;
  }
}
