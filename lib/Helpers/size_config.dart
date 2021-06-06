import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double width;
  static double height;
  static Size screenSize;
  static Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.maybeOf(context);
    width = _mediaQueryData.size.width;
    height = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    screenSize=_mediaQueryData.size;

  }
  // Get the proportionate height as per screen size
  double getProportionateScreenHeight(double inputHeight) {
    double screenHeight = screenSize.height;
    // 812 is the layout height that designer use
    return (inputHeight / 812.0) * screenHeight;
  }

// Get the proportionate height as per screen size
  double getProportionateScreenWidth(double inputWidth) {
    double screenWidth = screenSize.width;
    // 375 is the layout width that designer use
    return (inputWidth / 375.0) * screenWidth;
  }
}