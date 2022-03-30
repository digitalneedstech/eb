import 'package:flutter/material.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import '../groups/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/home_nav/calls/calls.dart';
import 'package:flutter_eb/platforms/common/home_nav/home_landing/home_landing.dart';
import 'package:flutter_eb/platforms/common/home_nav/notifications/notifications_list.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/index.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomeNav extends StatefulWidget {
  int index;
  final bool isUser;
  HomeNav({this.index = 0,this.isUser=true});
  HomeNavState createState() => HomeNavState();
}

class HomeNavState extends State<HomeNav> {
  late SharedPreferences preferences;
  late PageController _pageController;
  bool userPageDragging = false;
  bool isUserRole=false;

  int curIndex = 0;

  void initState(){
    super.initState();
    setState(() {
      curIndex=widget.index;
      isUserRole=BlocProvider.of<LoginBloc>(context)
          .userDTOModel.personalDetails.type==Constants.CLIENT? true:false;
    });
  }
  Widget build(BuildContext context) {
    if(getUserDTOModelObject(context).personalDetails.type==Constants.CUSTOMER
    && BlocProvider.of<LoginBloc>(context).userProfileType==Constants.USER){
      isUserRole=true;
    }
    List<Widget> widgets = [
      HomeLandingPage(),
      CallsPage(),
      GroupsTab(),
      NotificationsListPage(),
      LandingDashboardPage(isUserRole: isUserRole)
    ];
    return Scaffold(
      body: widgets[curIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            curIndex = index;
          });
        },
        currentIndex: curIndex, // this will be set when a new tab is tapped
        items: [
          bottomItemOlder("Home", 0,
              Icons.home_outlined,false),
          bottomItemOlder("Calls", 1,
              Icons.call,true),
          bottomItemOlder("Groups", 2,
              Icons.group,true),
          bottomItemOlder("Notification", 3,
              Icons.notifications,true),
          bottomItemOlder("Dashboard", 4,
              Icons.dashboard,true),
        ],
      ),
    );
  }

  BottomNavigationBarItem bottomItemOlder(
      String title, int index, IconData icon,bool isText) {
    return !isText ?BottomNavigationBarItem(icon: Image.asset("assets/images/icon.png"),
      label: ""
    ):BottomNavigationBarItem(
        icon:
        Icon(icon, color: curIndex == index ? Colors.blue : Colors.black),
        label: title);
  }
}
