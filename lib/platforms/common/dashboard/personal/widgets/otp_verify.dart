import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/widgets/custom_text_field/custom_text_field.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/profile_event.dart';
import '../../bloc/profile_state.dart';

class OTPVerify extends StatefulWidget{
  final String mobile;
  final Function callback;
  OTPVerify({required this.mobile,required this.callback});
  OTPVerifyState createState()=>OTPVerifyState();
}

class OTPVerifyState extends State<OTPVerify>{
  TextEditingController _otp =TextEditingController();
  Widget build(BuildContext context){
    return BlocListener<ProfileBloc,ProfileState>(
      listener: (context,state){
        if(state is OTPVerifiedState){
          widget.callback(state.isAuthVerified ?true:false);
        }

      },
      child: AlertDialog(
        title: Center(child: Text("Enter OTP To Continue"),),
        content: Container(
          height: MediaQuery.of(context).size.height*0.4,
          child: Column(
            children: [
              Text("Please Enter the OTP Sent On Mobile Number ${widget.mobile}"),
              CustomTextField(
                controller: _otp,
                labelText: "Enter OTP",
                hintText: "Enter OTP Sent",

              ),
            ],
          ),
        ),
        actions: [
          BlocBuilder<ProfileBloc,ProfileState>(
            builder: (context,state){
            return RaisedButton(onPressed: state is OTPVerifyInProgressState ? null:(){
               BlocProvider.of<ProfileBloc>(context).add(MobileOTPVerify(mobile: widget.mobile,otp: _otp.text));
              },
              child: Center(child: Text("Submit & Verify"),),
            );
            },

          )
        ],
      ),
    );
  }
}