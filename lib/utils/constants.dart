import 'package:flutter/cupertino.dart';

class Paddings{
  static double single = 4.0;
  static double doubled = 8.0;

  static EdgeInsets all(int factor){
    return EdgeInsets.all(single * factor);
  }
}