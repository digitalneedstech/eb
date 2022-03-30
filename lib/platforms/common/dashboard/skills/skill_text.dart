import 'package:flutter/material.dart';

class SkillText extends StatelessWidget {
  Function callback;
  SkillText({required this.callback});
  TextEditingController _skill = TextEditingController();
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(hintText: "Skills (Ex: SAP Ariba Procurement)"
          //helperText: "Use Comma to add multiple values"
          ),
      controller: _skill,
      textInputAction: TextInputAction.next,
      onChanged: (String val) {
        if (val.contains(",")) {
          callback(val.substring(0, val.length - 1));
          val == "";
        }
      },
    );
  }
}
