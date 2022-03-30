import 'package:flutter/material.dart';

class EbRaisedButtonWidget extends StatelessWidget{
  final VoidCallback callback;
  final Color textColor,buttonColor;
  final String buttonText;
  final String disabledButtontext;
  EbRaisedButtonWidget({this.buttonText="",
    this.disabledButtontext="Processing",
    required this.callback,this.buttonColor=Colors.black,this.textColor=Colors.white});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(onPressed:callback,
    disabledTextColor: Colors.white,
    color: buttonColor,textColor: textColor,child: Center(child: Text(buttonText=="" ? disabledButtontext :buttonText),));
  }
}