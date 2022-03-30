import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/confirm_notification/pages/company_confirm.dart';
import 'package:flutter_eb/platforms/common/home_nav/home_nav.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_event.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_state.dart';
import 'package:flutter_eb/platforms/common/login/widgets/registration.dart';
import 'package:flutter_eb/shared/constants/routes.dart';
import 'package:flutter_eb/shared/services/router/routers.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/button_with_animation/button_with_animation.dart';
import 'package:flutter_eb/shared/widgets/custom_text_field/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  late SharedPreferences _preferences;
  late LoginBloc _loginBloc;
  int selectedType=0;
  void initState() {
    super.initState();
    if(!kIsWeb)
      handleDynamicLinks();
    _initializePreferences();
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Wait...")));
        } else if (loginState is LoggedInState) {
          _preferences.setString("user", jsonEncode(loginState.userModel));
          _preferences.setString("userType", "user");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Navigating to Home...")));
          if(loginState.userModel.personalDetails.type=="client") {
            kIsWeb ? Navigator.pushReplacementNamed(context, Routers.LANDING_PAGE)
            :Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>
                  HomeNav(index: 0)),
            );
          }
          else{
            kIsWeb ? Navigator.pushReplacementNamed(context, Routers.LANDING_PAGE)
            :Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>
                  HomeNav(index: 4)),
            );
          }
        } else if (loginState is ExceptionState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(loginState.message),
            backgroundColor: Colors.red,
          ));
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Padding(
          padding: getScreenWidth(context)>600 ?EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height*0.1,
            horizontal: MediaQuery.of(context).size.width*0.3,
          ):EdgeInsets.all(20.0),
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
                  CustomTextField(
                      controller: _emailController,
                      labelText: "Email",
                      hintText: "Email",
                      ),
                  CustomTextField(
                      controller: _passwordController,
                      labelText: "Password",
                      isObscure: true,
                      hintText: "Password",
                      ),
                  Align(
                      alignment: Alignment.center,
                      child: BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, loginState) {
                        return ButtonWithAnimationWidget(
                            buttonText: "Sign In",

                            isLoadingButtonOnPhoneScreenEnabled:
                                loginState is LoadingState ? true : false,
                            callback: () {
                              _loginBloc.add(LoginStartedEvent(
                                  email: _emailController.text,
                                  password: _passwordController.text));
                            });
                      })),
                  SizedBox(
                    height: 10.0,
                  ),
                  InkWell(
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.REGISTRATION),
                    child: Text("Dont Have Account? Register"),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  InkWell(
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.FORGOT_PASSWORD),
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),

                  BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, loginState) {
                    return ButtonWithAnimationWidget(
                        buttonText: "Sign In With Google",
                        color: Color(0xFFD34B3E),
                        isLoadingButtonOnPhoneScreenEnabled:
                            loginState is GmailLoadingState ? true : false,
                        callback: () {
                          _loginBloc.add(GmailLoginEvent());
                        });
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future handleDynamicLinks() async {
    // 1. Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData? data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    if(data!=null)
      _handleDeepLink(data);

    // 3. Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.*//*
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
          // 3a. handle link that has been retrieved
          if(dynamicLink!=null)
            _handleDeepLink(dynamicLink);
        }, onError: (OnLinkErrorException e) async {
      print('Link Failed: ${e.message}');
    });
  }


  _handleDeepLink(PendingDynamicLinkData data)async {
    final Uri deepLink = data.link;
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');
      //https://hanatech.com/confirmInvitation?type=company&typeId=$companyId&userId=$userId
      // Check if we want to make a post
      var isConfirmNotification=deepLink.pathSegments.contains('confirmInvitation');
      if(isConfirmNotification){
        FirebaseAuth _auth = FirebaseAuth.instance;
        User? user = _auth.currentUser;
        if(user!=null){
          if(deepLink.queryParameters['type']=="company") {
            var id = deepLink.queryParameters['id'];
            var userId = deepLink.queryParameters['userId'];
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>
                  CompanyConfirmNotification(
                    companyId: id!=null ?id:"",
                    userId: userId!=null ? userId:"",
                  )),
            );
          }
        }
      }
      var isPost = deepLink.pathSegments.contains('invite');

      if (isPost) {
        // get the title of the post
        var senderId = deepLink.queryParameters['id'];
        var typeOfDeeplink=deepLink.queryParameters['type'];
        var email=deepLink.queryParameters['email'];

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegistrationPage(
            emailId:email!=null ? email:"",senderId: senderId!=null ?senderId:"",
            typeOfDeeplink: typeOfDeeplink!=null ?typeOfDeeplink:"",)),
        );

      }
      else{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegistrationPage()),
        );
      }
    }
  }
}
