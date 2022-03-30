import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/drawer/drawer.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/tab_headers/tab_header_widget.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/tabs/comapny_freelance_tabs.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/tabs/tabs.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/services/router/routers.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingDashboardPage extends StatefulWidget {
  bool isUserRole;
  LandingDashboardPage({this.isUserRole=true});
  LandingDashboardPageState createState() => LandingDashboardPageState();
}

class LandingDashboardPageState extends State<LandingDashboardPage> {
  GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
  late SharedPreferences preferences;
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LandingDashboardBloc>(context)
        .add(RoleUpdationEvent(isUserRole: widget.isUserRole));
    UserDTOModel userDTOModel=BlocProvider.of<LoginBloc>(context).userDTOModel;
    return WillPopScope(
      onWillPop: ()async=>false,
      child: userDTOModel.companyId=="" ?DefaultTabController(
                  length: 5,
                  initialIndex: 0,
                  child: Scaffold(
                      drawer: DrawerItems(),
                      backgroundColor: Colors.grey.shade200,
                      appBar: new AppBar(
                        //automaticallyImplyLeading: false,
                        title: Text("Dashboard"),
                        actions: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              BlocProvider.of<LoginBloc>(context).userDTOModel.personalDetails.type==Constants.VENDOR? InkWell(
                                onTap: () {
                                  setState((){
                                    widget.isUserRole = !widget.isUserRole;
                                    //preferences.setString("role", widget.isUserRole==true ?"user":"freelancer");
                                  });
                                },
                                child: Text(
                                  widget.isUserRole ? "Freelancer" : "User",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ):Container(),
                              SizedBox(
                                width: 10.0,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, "search");
                                },
                                child: Text(
                                  "Search ",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          )
                        ],
                        bottom: TabBar(
                            indicatorColor: Colors.blue,
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.white,
                            isScrollable: true,
                            tabs: [
                              Tab(text: "Overview"),
                              Tab(text: widget.isUserRole
                                  ? (BlocProvider.of<LoginBloc>(context).userProfileType==Constants.CUSTOMER ?"Calls Received":"Calls Made")
                                  : "Calls Received"),
                              Tab(
                                  text: widget.isUserRole
                                      ? (BlocProvider.of<LoginBloc>(context).userProfileType==Constants.CUSTOMER ?"Schedule Calls Received":
                                  "Schedule Calls Made")
                                      : "Schedule Calls Received"),
                              Tab(text: widget.isUserRole
                                  ? (BlocProvider.of<LoginBloc>(context).userProfileType==Constants.CUSTOMER ?"Bids Received":
                              "Bids Made")
                                  : "Bids Received"),
                              Tab(
                                  text: widget.isUserRole
                                      ? (BlocProvider.of<LoginBloc>(context).userProfileType==Constants.CUSTOMER ?"Contract Bids Received":
                                  "Contract Bids Made")
                                      : "Contract Bids Received")
                            ])

                      ),
                      body: TabsWidget(isUserRole: widget.isUserRole,
                      callback: (bool isUpdated,String message){
                        _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(message),backgroundColor:
                          isUpdated? Colors.green:Colors.red,));
                      },))):
        DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Scaffold(
                drawer: DrawerItems(),
                backgroundColor: Colors.grey.shade200,
                appBar: new AppBar(

                  actions: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BlocProvider.of<LoginBloc>(context).userDTOModel.personalDetails.type==Constants.VENDOR? InkWell(
                          onTap: () {
                            setState(() {
                              widget.isUserRole = !widget.isUserRole;
                            });
                          },
                          child: Text(
                            widget.isUserRole ? "Freelancer" : "User",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ):Container(),
                        SizedBox(
                          width: 10.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, Routers.LISTING_SEARCH);
                          },
                          child: Text(
                            "Search ",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    )
                  ],
                  bottom: TabBar(
                      indicatorColor: Colors.blue,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.white,
                      isScrollable: true,
                      tabs: [
                        Tab(text: "Overview"),
                        Tab(text: widget.isUserRole
                            ? "Calls Made"
                            : "Calls Received"),
                        Tab(
                            text: widget.isUserRole
                                ? "Schedule Calls Made"
                                : "Schedule Calls Received"),

                      ]),
                ),
                body: CompanyFreelanceTabsWidget(isUserRole: widget.isUserRole,)))
    );
  }
}
