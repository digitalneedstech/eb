import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
/*class SuccessAlertBox extends StatelessWidget{
  String message;
  Function cancelCallback,confirmCallback;
  SuccessAlertBox({this.message,this.confirmCallback,this.cancelCallback});
@override
  Widget build(BuildContext context) {
    return _showAlertBox(context);
  }*/

showAlertBox(String message,Function cancelCallback,Function confirmCallback,
    BuildContext context) {
  CoolAlert.show(
      context: context,
      type: CoolAlertType.success,

      text: message,
      barrierDismissible: true,
      onCancelBtnTap: (){
        Navigator.of(context, rootNavigator: true).pop();
      },
      onConfirmBtnTap: (){
        Navigator.of(context, rootNavigator: true).pop();
      }
  );

}