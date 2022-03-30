import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/confirm_notification/pages/company_confirm.dart';
import 'package:flutter_eb/platforms/common/home_nav/home_nav.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/widgets/registration.dart';
import 'package:flutter_eb/platforms/common/pickupcall/pages/pickup_layout.dart';
import 'package:flutter_eb/shared/assets/colors/colors.dart';
import 'package:flutter_eb/shared/constants/routes.dart';
import 'package:flutter_eb/shared/services/router/routers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () async {
      //Navigator.popAndPushNamed(context, Routes.LOGIN);
      FirebaseAuth _auth = FirebaseAuth.instance;
      User? user = _auth.currentUser;
      if (user == null) {
        /*Routers.router.navigateTo(
            context, "login");*/
        Navigator.pushNamed(context, kIsWeb ?Routers.HOME_WEB:Routers.LOGIN);
      } else {
        SharedPreferences.getInstance().then((value) {
          if (value.containsKey("user")) {
            BlocProvider.of<LoginBloc>(context)
                .loginRepository
                .getUserByUid(user.uid)
                .then((value) {
              BlocProvider.of<LoginBloc>(context).userDTOModel =
                  UserDTOModel.fromJson(
                      value.data() as Map<String, dynamic>, value.id);
              BlocProvider.of<LoginBloc>(context).userProfileType=BlocProvider.of<LoginBloc>(context).userDTOModel.personalDetails.type;
              if (BlocProvider.of<LoginBloc>(context)
                      .userDTOModel
                      .personalDetails
                      .type ==
                  "client") {
                if (kIsWeb) {
                  Navigator.pushNamed(context, Routers.LANDING_DASHBOARD);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeNav(index: 0)),
                  );
                }
              }
              if (kIsWeb) {
                Navigator.pushNamed(context, Routers.COMPANY_DASHBOARD);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeNav(index: 4)),
                );
              }
            });
          } else {
            Navigator.popAndPushNamed(context, kIsWeb ?Routers.HOME_WEB:Routers.LOGIN);
          }
        });
      }
    });
  }

  Widget build(BuildContext context) {
    //handleDynamicLinks(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image.asset("assets/images/logo.jpeg")],
        ),
      ),
    );
  }
}
