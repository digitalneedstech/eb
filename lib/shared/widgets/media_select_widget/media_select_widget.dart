import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/shared/widgets/eb_outline_button_widget/eb_outline_button_widget.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';

class MediaSelectWidget extends StatefulWidget{
  Function callback;
  final String mediaText1,mediaText2;
  MediaSelectWidget({required this.callback,required this.mediaText1,required this.mediaText2});
  MediaSelectWidgetState createState()=>MediaSelectWidgetState();
}
class MediaSelectWidgetState extends State<MediaSelectWidget>{
  int _selectedMediaVal=0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height*0.2,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            RadioListTile(
              groupValue: _selectedMediaVal,
              value: 0,
              onChanged: (int? index){
                setState(() {
                  _selectedMediaVal=index!;
                });
              },
              title: Text(widget.mediaText1),
            ),
            RadioListTile(
              groupValue: _selectedMediaVal,
              value: 1,
              onChanged: (int? index){
                setState(() {
                  _selectedMediaVal=index!;
                });
              },
              title: Text(widget.mediaText2),
            )
          ],
        ),
      ),
      actions: [
        EbOutlineButtonWidget(callback: ()=>Navigator.pop(context),
        buttonText: "Cancel",),
        EbRaisedButtonWidget(callback: (){
          widget.callback(_selectedMediaVal);
        },
          buttonText: "Select",)
      ],
    );
  }
}