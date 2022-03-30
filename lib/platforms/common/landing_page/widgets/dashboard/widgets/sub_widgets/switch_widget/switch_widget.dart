import 'package:flutter/material.dart';

class EbSwitchWidget extends StatefulWidget{
  final Function callback;
  EbSwitchWidget(this.callback);
  EbSwitchWidgetState createState()=>EbSwitchWidgetState();
}
class EbSwitchWidgetState extends State<EbSwitchWidget>{
  bool value=false;
  @override
  Widget build(BuildContext context) {
    return Switch(value: value,
        onChanged: (val){
      setState(() {
        value=val;
        widget.callback(value);
      });
        });
  }
}