import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText, hintText, helperText, erroMessage;
  final TextInputType inputType;
  final Icon icon;
  final bool isReadOnly, isObscure, isEnabled;
  final int maxLines;
  CustomTextField(
      {required this.controller,
        required this.labelText,
        this.hintText="Please enter value",
      this.helperText = "",
      this.erroMessage = "Please Enter value",
      this.inputType = TextInputType.text,
        this.maxLines=1,
      this.isReadOnly = false,
      this.isObscure = false,
      this.isEnabled = true,
        this.icon=const Icon(Icons.keyboard)});
  Widget build(BuildContext context) {

    return Column(
      children: [
        TextFormField(
          enabled: isEnabled,
          maxLines: maxLines,
          obscureText: isObscure,
          readOnly: isReadOnly,
          controller: controller,
          keyboardType: inputType,
          textCapitalization: TextCapitalization.none,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey.shade900),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red.shade200),
            ),
            labelText: labelText,
            hintText: hintText,
            helperText: helperText,
          )
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ],
    );
  }
}


class CustomTextFieldForSave extends StatelessWidget {
  final TextEditingController controller;
  final String labelText, hintText, helperText, erroMessage;
  final TextInputType inputType;
  final Icon icon;
  final bool isReadOnly, isObscure, isEnabled;
  final int maxLines;
  final Function onSavedCallback;
  final Function?  onChangeCallBack;
  CustomTextFieldForSave(this.onSavedCallback,
      {required this.controller,
        this.onChangeCallBack,
        required this.labelText,
        this.hintText="Please enter value",
        this.helperText = "",
        this.erroMessage = "Please Enter value",
        this.inputType = TextInputType.text,
        this.maxLines=1,
        this.isReadOnly = false,
        this.isObscure = false,
        this.isEnabled = true,
        this.icon=const Icon(Icons.keyboard)});
  Widget build(BuildContext context) {

    return Column(
      children: [
        TextFormField(
          enabled: isEnabled,
          maxLines: maxLines,
          obscureText: isObscure,
          readOnly: isReadOnly,
          controller: controller,
          keyboardType: inputType,
          textCapitalization: TextCapitalization.none,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey.shade900),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red.shade200),
            ),
            labelText: labelText,
            hintText: hintText,
            helperText: helperText,
          ),
          onSaved: (val)=>onSavedCallback(val),
          onChanged: (val)=>onChangeCallBack!(val),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ],
    );
  }
}




class CustomTextFieldForValidateAndSave extends StatelessWidget {
  final TextEditingController controller;
  final String labelText, hintText, helperText, erroMessage;
  final TextInputType inputType;
  final Icon icon;
  final bool isReadOnly, isObscure, isEnabled;
  final int maxLines;
  final Function onSavedCallback,onValidateCallback;
  final Function?  onChangeCallBack;
  CustomTextFieldForValidateAndSave(this.onSavedCallback,this.onValidateCallback,
      {required this.controller,
        this.onChangeCallBack,
        required this.labelText,
        this.hintText="Please enter value",
        this.helperText = "",
        this.erroMessage = "Please Enter value",
        this.inputType = TextInputType.text,
        this.maxLines=1,
        this.isReadOnly = false,
        this.isObscure = false,
        this.isEnabled = true,
        this.icon=const Icon(Icons.keyboard)});
  Widget build(BuildContext context) {

    return Column(
      children: [
        TextFormField(
          enabled: isEnabled,
          maxLines: maxLines,
          obscureText: isObscure,
          readOnly: isReadOnly,
          controller: controller,
          keyboardType: inputType,
          textCapitalization: TextCapitalization.none,
          decoration: InputDecoration(

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey.shade900),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red.shade200),
            ),
            labelText: labelText,
            hintText: hintText,
            helperText: helperText,
          ),
          onSaved: (val)=>onSavedCallback(val),
          validator: (val)=>onValidateCallback(val),
          onChanged: (val)=>onChangeCallBack!(val),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ],
    );
  }
}
