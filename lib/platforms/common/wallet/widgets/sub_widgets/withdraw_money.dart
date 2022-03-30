import 'package:flutter/material.dart';
import 'package:flutter_eb/shared/widgets/custom_text_field/custom_text_field.dart';

class WithdrawMoney extends StatefulWidget{
  WithdrawMoneyState createState()=>WithdrawMoneyState();
}
class WithdrawMoneyState extends State<WithdrawMoney>{

  TextEditingController _moneyController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("Add Money To Wallet"),),
      content: Container(
        height: MediaQuery.of(context).size.height*0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(icon: Icon(Icons.monetization_on_outlined),
              controller: _moneyController,
              labelText: "Enter Amount",
              inputType: TextInputType.number,

            ),
            SizedBox(height: 10.0,),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color(0xFF2980B9),
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: Center(child: Text("Amount will deposited to your default Bank Account",style: TextStyle(color: Colors.white),),),
            ),
            Divider(color: Colors.grey,height: 2.0,)
          ],
        ),
      ),
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