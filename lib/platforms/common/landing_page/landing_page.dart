import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/model/item.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/assets/colors/colors.dart';
import 'package:flutter_eb/shared/constants/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  LandingPageState createState()=>LandingPageState();
}
class LandingPageState extends State<LandingPage>{
  List<Item> userTypes=[Item("User", "user"),Item("Freelancer", "freelancer")];
  late Item selectedUser;
  late SharedPreferences _preferences;
  void initState(){
    super.initState();
    selectedUser=userTypes[0];
    _initializePreferences();
  }

  _initializePreferences()async{
    _preferences=await SharedPreferences.getInstance();
  }

  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<Item>(
                hint:  Text("Select item"),
                value: selectedUser,
                onChanged: (Item? Value) {
                  setState(() {
                    selectedUser = Value!;
                  });
                },
                items: userTypes.map((Item user) {
                  return  DropdownMenuItem<Item>(
                    value: user,
                    child: Row(
                      children: <Widget>[
                        Text(
                          user.userType,
                          style:  TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              RaisedButton(onPressed: (){
                BlocProvider.of<LoginBloc>(context).userType=selectedUser.userValue;

                  if(selectedUser.userValue=="user")
                  Navigator.pushNamed(context, Routes.LISTING_PAGE);
                  else
                    Navigator.pushNamed(context, Routes.LISTING_PAGE);


              },child: Center(child: Text("Submit",style: TextStyle(color: Colors.white),)),color: themeColor)
            ],
          ),
        ),
      ),
    );
  }
}