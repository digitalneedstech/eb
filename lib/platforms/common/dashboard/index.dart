import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/experience/widgets/experience_widget.dart';
import 'package:flutter_eb/platforms/common/dashboard/featured/widgets/featured_details_widget.dart';
import 'package:flutter_eb/platforms/common/dashboard/languages/widgets/language_widget.dart';
import 'package:flutter_eb/platforms/common/dashboard/licenses/widgets/license_widget.dart';
import 'package:flutter_eb/platforms/common/dashboard/personal/widgets/personal_details_widget/personal_details_widget.dart';
import 'package:flutter_eb/platforms/common/dashboard/profile_overview/widgets/profile_overview_widget.dart';
import 'package:flutter_eb/platforms/common/dashboard/rates/widgets/rate_widget.dart';
import 'package:flutter_eb/platforms/common/dashboard/skills/widgets/skill_widget.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/services/router/routers.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:flutter_eb/shared/widgets/eb_web_app_bar/eb_web_appbar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DashboardPage extends StatefulWidget {
  DashboardPageState createState()=>DashboardPageState();
}
class DashboardPageState extends State<DashboardPage> {
  GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  int activeSelection=0;
  Map<int,Widget> widgetsMap={
    0:PersonalDetailsWidget(),1:ProfileOverviewWidget(),
    2:FeaturedDetailsWidget(),3:LicensesWidget(),
    4:SkillsWidget(),5:RateWidget(),
    6:ExperienceWidget(),7:LanguagesWidget()
  };
  Widget build(BuildContext context) {

    UserDTOModel userDTOModel =
        BlocProvider.of<LoginBloc>(context).userDTOModel;
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: getScreenWidth(context)>800 ?PreferredSize(
            preferredSize: Size.fromHeight(50.0), // here the desired height
            child: EbWebAppBarWidget()
        ):AppBar(
          title: Text("Create Profile"),
          centerTitle: false,
          //automaticallyImplyLeading: false,
          actions: [
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                  SharedPreferences.getInstance().then((value) {
                    value.clear().then((isCleared) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routers.LOGIN, (r) => false);
                    });
                  });
                })
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: getScreenWidth(context)>800? Center(child: Container(

            width: MediaQuery.of(context).size.width*0.6,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      width: MediaQuery.of(context).size.width*0.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListTile(title: Text("Personal Details"),onTap: (){
                            setState(() {
                              activeSelection=0;
                            });
                          },tileColor: activeSelection==0 ?Colors.grey:Colors.white,),
                          userDTOModel.personalDetails.type == Constants.VENDOR?
                          ListTile(title: Text("Profile Overview"),onTap: (){
                            setState(() {
                              activeSelection=1;
                            });
                          },tileColor: activeSelection==1 ?Colors.grey:Colors.white):Container(),
                          userDTOModel.personalDetails.type == Constants.VENDOR?
                          ListTile(title: Text("Featured"),onTap: (){
                            setState(() {
                              activeSelection=2;
                            });
                          },tileColor: activeSelection==2 ?Colors.grey:Colors.white):Container(),
                          userDTOModel.personalDetails.type == Constants.VENDOR?
                          ListTile(title: Text("Licenses & Certification"),onTap: (){
                            setState(() {
                              activeSelection=3;
                            });
                          },tileColor: activeSelection==3 ?Colors.grey:Colors.white):Container(),
                          userDTOModel.personalDetails.type == Constants.VENDOR?
                          ListTile(title: Text("Skills"),onTap: (){
                            setState(() {
                              activeSelection=4;
                            });
                          },tileColor: activeSelection==4 ?Colors.grey:Colors.white):Container(),
                          userDTOModel.personalDetails.type == Constants.VENDOR &&
                              userDTOModel.companyId == "" ?
                          ListTile(title: Text("Hourly Rates"),onTap: (){
                            setState(() {
                              activeSelection=5;
                            });
                          },tileColor: activeSelection==5 ?Colors.grey:Colors.white):Container(),
                          userDTOModel.personalDetails.type == Constants.VENDOR ?
                          ListTile(title: Text("Add Experience"),onTap: (){
                            setState(() {
                              activeSelection=6;
                            });
                          },tileColor: activeSelection==6 ?Colors.grey:Colors.white):Container(),
                          userDTOModel.personalDetails.type == Constants.VENDOR ?
                          ListTile(title: Text("Languages"),onTap: (){
                            setState(() {
                              activeSelection=7;
                            });
                          },tileColor: activeSelection==7 ?Colors.grey:Colors.white):Container(),
                        ],
                      ),
                    ),
                    SizedBox(width: 20.0,),
                    Container(
                        padding: const EdgeInsets.all(20.0),
                        color: Colors.white,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.35,
                        child: widgetsMap[activeSelection],
                      )

                  ],
                )

              ],
            ),
          ),):AnimationLimiter(
            child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
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
                          isStackingEnabled: false,
                          title: "Personal Details",
                          routeUrl: Routers.PERSONAL),
                      userDTOModel.personalDetails.type == Constants.VENDOR
                          ? ProfileListTiles(
                              isStackingEnabled: false,
                              title: "Profile Overview",
                              routeUrl: Routers.PROFILE)
                          : Container(),
                      userDTOModel.personalDetails.type == Constants.VENDOR
                          ? ProfileListTiles(
                              title: "Featured",
                              isStackingEnabled: false,
                              routeUrl: Routers.FEATURED)
                          : Container(),
                      userDTOModel.personalDetails.type == Constants.VENDOR
                          ? ProfileListTiles(
                              isStackingEnabled: false,
                              title: "Licenses & Certification",
                              routeUrl: Routers.LICENSES)
                          : Container(),
                      userDTOModel.personalDetails.type == Constants.VENDOR
                          ? ProfileListTiles(
                              isStackingEnabled: false,
                              title: "Skills",
                              routeUrl: Routers.SKILLS)
                          : Container(),
                      userDTOModel.personalDetails.type == Constants.VENDOR &&
                              userDTOModel.companyId == ""
                          ? ProfileListTiles(
                              isStackingEnabled: false,
                              title: "Hourly Rates",
                              routeUrl: Routers.RATES)
                          : Container(),
                      userDTOModel.personalDetails.type == Constants.VENDOR
                          ? ProfileListTiles(
                              isStackingEnabled: false,
                              title: "Add Experience",
                              routeUrl: Routers.EDUCATION)
                          : Container(),
                      userDTOModel.personalDetails.type == Constants.VENDOR
                          ? ProfileListTiles(
                              isStackingEnabled: false,
                              title: "Languages",
                              routeUrl: Routers.LANGUAGES)
                          : Container(),
                    ],
                  ),
                )),
          ),
        ));
  }
}

class ProfileListTiles extends StatelessWidget {
  String title, routeUrl;
  bool isStackingEnabled;

  ProfileListTiles(
      {this.isStackingEnabled = true, required this.title, this.routeUrl = ""});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        isStackingEnabled
            ? Navigator.pushNamed(context, routeUrl)
            : Navigator.pushNamed(context, routeUrl);
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade500, width: 3.0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16.0)),
            IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: () {})
          ],
        ),
      ),
    );
  }
}

class ProfileListTilesWithRoute extends StatelessWidget {
  String title;
  bool isStackingEnabled,isLogicToBeExecuted;
  MaterialPageRoute route;
  Function execution;
  ProfileListTilesWithRoute(
      {this.isStackingEnabled = true,
      required this.title,
      required this.route,this.isLogicToBeExecuted=false,required this.execution});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(isLogicToBeExecuted)
          execution();
        if (isStackingEnabled) {
          Navigator.push(context, route);
        } else {
          Navigator.pop(context);
          Navigator.push(context, route);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade500, width: 3.0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16.0)),
            IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: () {})
          ],
        ),
      ),
    );
  }
}
