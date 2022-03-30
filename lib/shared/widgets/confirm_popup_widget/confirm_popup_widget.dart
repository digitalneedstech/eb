import 'package:flutter/material.dart';
import 'package:flutter_eb/shared/widgets/eb_outline_button_widget/eb_outline_button_widget.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';

class ConfirmPopupWidget extends StatelessWidget{
  final Function callback;
  final String header,cancelButtonText,okButtonText;
  ConfirmPopupWidget({required this.header,required this.callback,required this.cancelButtonText,
    required this.okButtonText});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(header),
      actions: [
        EbOutlineButtonWidget(
          buttonText: "Cancel",
          callback: () => callback(false),
        ),
        EbRaisedButtonWidget(
          callback: () =>callback(true),
          buttonText: "Ok",
        )
      ],
    );
  }
}