import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/index.dart';
import 'package:flutter_eb/platforms/common/home_nav/home_nav.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/index.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/constants/routes.dart';
import 'package:flutter_eb/shared/services/router/routers.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/constants/routes.dart';

class SubDashboardPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: Text("Create Profile"),
          centerTitle: false,
          // automaticallyImplyLeading: false,
          actions: [
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                  SharedPreferences.getInstance().then((value) {
                    value.clear().then((isCleared) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.LOGIN, (r) => false);
                    });
                  });
                })
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: AnimationLimiter(
                child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 1000),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  duration: const Duration(milliseconds: 1000),
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  ProfileListTiles(
                      title: "My Profile", routeUrl: Routers.DASHBOARD),
                  BlocProvider.of<LoginBloc>(context).userDTOModel.userType ==
                          "organization"
                      ? ProfileListTiles(
                          title: "Company Profile",
                          routeUrl: Routers.MY_COMPANY_LINKS)
                      : Container(),
                  ProfileListTiles(
                      title: "My Wallet", routeUrl: Routers.WALLET),
                  getUserDTOModelObject(context).personalDetails.type!=Constants.CUSTOMER
                  ?
                  (kIsWeb
                      ? ProfileListTiles(
                          title: "Dashboard",
                          routeUrl: Routers.LANDING_DASHBOARD,
                        )
                      : ProfileListTilesWithRoute(
                    isLogicToBeExecuted: true,
                          execution: (){
                            if(getUserDTOModelObject(context).personalDetails.type==Constants.CUSTOMER){
                              BlocProvider.of<LoginBloc>(context).userProfileType=Constants.USER;
                            }
                          },
                          title: "Dashboard",
                          route: MaterialPageRoute(
                              builder: (context) => HomeNav(
                                    index: 4)),
                        )):Container(),
                  ProfileListTiles(title: "My Posts", routeUrl: Routers.POST),
                  ProfileListTiles(title: "My Chats", routeUrl: Routers.CHATS),
                  ProfileListTiles(
                      title: "Billing Address",
                      routeUrl: Routers.BILLING_ADDRESS),
                ],
              ),
            )),
          ),
        ));
  }
}
