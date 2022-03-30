import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/home_nav/home_nav.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_event.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_state.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/services/router/routers.dart';
import 'package:flutter_eb/shared/widgets/button_with_animation/button_with_animation.dart';
import 'package:flutter_eb/shared/widgets/custom_text_field/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  String senderId;
  String typeOfDeeplink;
  String emailId;
  RegistrationPage({this.emailId="",this.senderId="",this.typeOfDeeplink=""});
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late TextEditingController _emailController;
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();

  late LoginBloc _loginBloc;

  late SharedPreferences _preferences;

  int selectedType=1;
  void initState() {
    super.initState();
    _initializePreferences();
    _emailController = new TextEditingController(text: widget.emailId);
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  _initializePreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, loginState) {
          if (loginState is LoadingState) {
            _scaffoldKey.currentState!.removeCurrentSnackBar();
            _scaffoldKey.currentState!
                .showSnackBar(new SnackBar(content: Text("Saving...")));
          } else if (loginState is RegisteredState) {
            _preferences.setString("user", jsonEncode(loginState.userModel));
            _preferences.setString("userType", "user");
            _scaffoldKey.currentState!.removeCurrentSnackBar();
            _scaffoldKey.currentState!.showSnackBar(
                new SnackBar(content: Text("Registerd Successfully...")));
            _scaffoldKey.currentState!.showSnackBar(
                new SnackBar(content: Text("Navigating to Home...")));
            if(loginState.userModel.personalDetails.type=="client") {
              kIsWeb ? Navigator.pushReplacementNamed(context, Routers.LANDING_PAGE)
                  :Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>
                    HomeNav(index: 0)),
              );
            }
            else{
              kIsWeb ? Navigator.pushReplacementNamed(context, Routers.LANDING_DASHBOARD)
                  :Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>
                    HomeNav(index: 4)),
              );
            }
          } else if (loginState is ExceptionState) {
            _scaffoldKey.currentState!.removeCurrentSnackBar();
            _scaffoldKey.currentState!.showSnackBar(new SnackBar(
              content: Text(loginState.message),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Logo",
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      CustomTextFieldForValidateAndSave(
                         (val) {},
                        (val) {
                          return _emailController.text.isEmpty
                              ? "Please Enter value"
                              : null;
                        },
                          controller: _emailController,
                          isEnabled: widget.emailId=="" ? true:false,
                          labelText: "Email",
                          hintText: "Please Enter Email Address",
                          ),
                      CustomTextFieldForValidateAndSave(
                        (val) {},
                        (val) {
                          if (_passwordController.text.isEmpty)
                            return "Please Enter value";
                          else {
                            if (_passwordController.text !=
                                _confirmPasswordController.text)
                              return "Password and Confirm Password should match";
                          }
                          return null;
                        },
                          isObscure: true,
                          controller: _passwordController,
                          labelText: "Password",
                          hintText: "Please Enter Password",
                          ),
                      CustomTextFieldForValidateAndSave(
                        (val) {},
                        (val) {
                          if (_confirmPasswordController.text.isEmpty)
                            return "Please Enter value";
                          else {
                            if (_passwordController.text !=
                                _confirmPasswordController.text)
                              return "Password and Confirm Password should match";
                          }
                          return null;
                        },
                        isObscure: true,

                        controller: _confirmPasswordController,
                        labelText: "Confirm Password",
                        hintText: "Please Enter Confirm Password",

                      ),
                      Container(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: RadioListTile(toggleable:widget.typeOfDeeplink=="" ? false:true ,value: 1, groupValue: selectedType, onChanged: (val){
                              setState(() {
                                selectedType=1;
                              });
                            },title: Text(Constants.INDIVIDUAL,style: TextStyle(fontSize: 14.0),),)),
                            Expanded(
                              child: RadioListTile(toggleable:widget.typeOfDeeplink=="" ? false:true,
                                value: 0, groupValue: selectedType, onChanged: (val){
                                setState(() {
                                  selectedType=0;
                                });
                              },title: Text(Constants.ORAGNIZATION,style: TextStyle(fontSize: 12.0),),),
                            ),

                          ],
                        ),
                      ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: RichText(
                        text: TextSpan(
                            text: "By registering yourself, you are accepting our ",
                            style: TextStyle(
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Terms & Conditions ",
                                  style: TextStyle(color: Colors.blue)),
                              TextSpan(
                                  text: "and",
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: " Privacy Policy.",
                                  style: TextStyle(color: Colors.blue))
                            ]))),
                      Align(
                          alignment: Alignment.center,
                          child: BlocBuilder<LoginBloc, LoginState>(
                              builder: (context, loginState) {
                            return ButtonWithAnimationWidget(
                                buttonText: "Continue",
                                isLoadingButtonOnPhoneScreenEnabled:
                                    loginState is LoadingState ? true : false,
                                callback: () {
                                  _loginBloc.add(RegistrationStartedEvent(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      senderId: widget.senderId,
                                      typeOfDeepLink: widget.typeOfDeeplink,
                                      confirmPassword:
                                          _confirmPasswordController.text,selectedType: selectedType==0 ?Constants.ORAGNIZATION:Constants.INDIVIDUAL));
                                });
                          })),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
