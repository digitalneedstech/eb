import 'package:flutter/material.dart';
import 'package:flutter_eb/shared/widgets/custom_text_field/custom_text_field.dart';

class AddBankAccountPopUp extends StatefulWidget{
  AddBankAccountPopUpState createState()=>AddBankAccountPopUpState();
}
class AddBankAccountPopUpState extends State<AddBankAccountPopUp>{
  TextEditingController _accountHolderNameController=TextEditingController();
  TextEditingController _bankNameController=TextEditingController();
  TextEditingController _accountNumberController=TextEditingController();
  TextEditingController _ifscCodeController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("Add Bank Account"),),
      content: Container(height: MediaQuery.of(context).size.height*0.5,
      child: Column(
        children: [
          CustomTextField(controller: _accountHolderNameController,
          labelText: "Account Holder Name",),
          SizedBox(height: 10.0,),
          CustomTextField(controller: _bankNameController,
            labelText: "Account Holder Name",),
          SizedBox(height: 10.0,),
          CustomTextField(controller: _accountNumberController,
            labelText: "Account Number",),
          SizedBox(height: 10.0,),
          CustomTextField(controller: _ifscCodeController,
            labelText: "IFSC Code",),
          Divider(height: 2.0, color: Colors.grey,)
        ],
      ),),
      actions: [
        OutlineButton(
        onPressed: () {

    },
    child: Center(
    child: Text(
    " Cancel",
    style: TextStyle(fontSize: 16.0),
    ),
    ),
    color: Colors.blue,
    textColor: Colors.blue,
    borderSide: BorderSide(
    color: Colors.blue, //Color of the border
    style: BorderStyle.solid, //Style of the border
    width: 1, //width of the border
    )),
    RaisedButton(
    onPressed: (){},
    color: Colors.blue,
    child: Center(
    child: Text("Submit",style: TextStyle(color: Colors.white),),
    ),
    ),
    ],
    );
  }
}