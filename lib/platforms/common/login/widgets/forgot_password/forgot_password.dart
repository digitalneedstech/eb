import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_event.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_state.dart';
import 'package:flutter_eb/shared/constants/routes.dart';
import 'package:flutter_eb/shared/widgets/button_with_animation/button_with_animation.dart';
import 'package:flutter_eb/shared/widgets/custom_text_field/custom_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _emailController = new TextEditingController();

  late LoginBloc _loginBloc;
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, loginState) {
          if (loginState is LoadingState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sending Mail...")));
          } else if (loginState is PasswordResetMailSentState) {

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mail Sent Successfully...")));
            Navigator.popAndPushNamed(
                context, Routes.FORGOT_PASSWORD_MAIL_SENT);
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
                      (val){},
                      (val) {
                        return _emailController.text.isEmpty
                            ? "Please Enter value"
                            : null;
                      },
                       controller: _emailController,
                        labelText: "Email",
                        hintText: "Please Enter Email Address",
                        ),
                    Align(
                        alignment: Alignment.center,
                        child: BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, loginState) {
                          return ButtonWithAnimationWidget(
                              buttonText: "Continue",
                              isLoadingButtonOnPhoneScreenEnabled:
                                  loginState is LoadingState ? true : false,
                              callback: () {
                                _loginBloc.add(ForgotPasswordEvent(
                                    email: _emailController.text));
                              });
                        })),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
