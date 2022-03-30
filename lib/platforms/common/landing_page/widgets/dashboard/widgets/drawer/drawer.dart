import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/home_nav/home_nav.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/index.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/drawer/drawer_profile_icon/drawer_profile_icon.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_event.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/constants/routes.dart';
import 'package:flutter_eb/shared/services/router/routers.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/eb_circle_avatar/eb_circle_avatar.dart';
import 'package:flutter_eb/shared/widgets/eb_outline_button_widget/eb_outline_button_widget.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerItems extends StatelessWidget {
  Map<String, String> drawerListWithRoutes = {
    "My Account": Routers.SUB_DASHBOARD,
    "My Wallet": Routers.WALLET,
    "Dashboard": Routers.LANDING_DASHBOARD,
    "My Groups": Routers.GROUPS,
    "Affiliates": Routers.INVITE,
    "Post A Job": Routers.POST
  };

  Map<String, String> drawerListWithRoutesForUser = {
    "My Account": Routers.SUB_DASHBOARD,
    "My Wallet": Routers.WALLET,
    "Dashboard": Routers.LANDING_DASHBOARD,
    "My Groups": Routers.GROUPS,
    "Job Postings": Routers.JOB_LISTING,
    "Affiliates": Routers.INVITE,
    "Post A Job": Routers.POST,
    "Become A Freelancer": Routers.DASHBOARD
  };

  Map<String, String> drawerListWithRoutesForFreelancer = {
    "My Account": Routers.SUB_DASHBOARD,
    "My Wallet": Routers.WALLET,
    "Dashboard": Routers.LANDING_DASHBOARD,
    "My Groups": Routers.GROUPS,
    "Job Postings": Routers.JOB_LISTING,
    "Affiliates": Routers.INVITE,
    "Post A Job": Routers.POST
  };
  Column _getDrawerItems(BuildContext context, UserDTOModel user) {
    Map<String, String> mapToIterate = user.userType == Constants.ORAGNIZATION
        ? drawerListWithRoutes
        : drawerListWithRoutesForUser;
    if(user.userType != Constants.ORAGNIZATION && user.personalDetails.type=="client"){
      mapToIterate=drawerListWithRoutesForUser;
    }
    if(user.userType != Constants.ORAGNIZATION && user.personalDetails.type==Constants.VENDOR){
      mapToIterate=drawerListWithRoutesForFreelancer;
    }
    return Column(
        children: mapToIterate.entries.map((e) {
      return ListTile(
        title: Text(e.key),
        onTap: () {
          switch (e.key) {
            case "Become A Freelancer":
              UserDTOModel userDTOModel =
                  BlocProvider.of<LoginBloc>(context).userDTOModel;
              userDTOModel.personalDetails.type = Constants.VENDOR;
              BlocProvider.of<LoginBloc>(context)
                  .add(UpdateUserEvent(userDTOModel: userDTOModel));
              BlocProvider.of<LoginBloc>(context)
                  .loginRepository
                  .addorUpdateRecord(userDTOModel);
              Navigator.pushNamed(context, e.value);
              break;
            case "Dashboard":
              if(getUserDTOModelObject(context).personalDetails.type==Constants.CUSTOMER){
                BlocProvider.of<LoginBloc>(context).userProfileType=Constants.USER;
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeNav(index: 4,)));
              break;
            default:
              Navigator.pushNamed(context, e.value);
          }
        },
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 12.0,
        ),
      );
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    UserDTOModel model = BlocProvider.of<LoginBloc>(context).userDTOModel;
    Color availabilityColor = Colors.green;
    if (model.userAvailabilityStatus == "offline") {
      availabilityColor = Colors.grey;
    } else if (model.userAvailabilityStatus == "away") {
      availabilityColor = Colors.orange;
    }
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            //height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(color: Colors.white),
            child: Row(children: [
              SizedBox(
                height: 115,
                width: 115,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    EbCircleAvatarWidget(
                      profileImageUrl: model.personalDetails.profilePic,
                      radius: 20.0,
                    ),
                    Positioned(
                        bottom: 0, right: 20, child: DrawerProfileIconWidget()),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.personalDetails.displayName==Constants.UNNAMED ? model.personalDetails.email :model.personalDetails.displayName,
                        style: TextStyle(color: Colors.blue),
                      ),
                      InkWell(
                        onTap: () =>
                            Navigator.pushNamed(context, Routes.DASHBOARD),
                        child: Text("Edit Profile"),
                      )
                    ],
                  ),
                ),
              )
            ]),
          ),
          Divider(
            color: Colors.grey,
            height: 2.0,
          ),
          InkWell(
            onTap: () {
              UserDTOModel userDTOModel =
                  BlocProvider.of<LoginBloc>(context).userDTOModel;
              userDTOModel.userAvailabilityStatus = "available";
              BlocProvider.of<LoginBloc>(context)
                  .add(UpdateUserEvent(userDTOModel: userDTOModel));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: 20.0,
                    height: 20.0,
                    decoration: ShapeDecoration(
                        color: Colors.green, shape: CircleBorder()),
                  ),
                  Expanded(
                    child: Text("Available"),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                          "Are You sure, Do You want to make yourself offline?"),
                      actions: [
                        EbOutlineButtonWidget(
                          buttonText: "No",
                          callback: () => Navigator.pop(context),
                        ),
                        EbRaisedButtonWidget(
                          callback: () {
                            UserDTOModel userDTOModel =
                                BlocProvider.of<LoginBloc>(context)
                                    .userDTOModel;
                            userDTOModel.userAvailabilityStatus = "offline";
                            BlocProvider.of<LoginBloc>(context).add(
                                UpdateUserEvent(userDTOModel: userDTOModel));

                            Navigator.pop(context);
                          },
                          buttonText: "Yes",
                        )
                      ],
                    );
                  });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: 20.0,
                    height: 20.0,
                    decoration: ShapeDecoration(
                        color: Colors.grey, shape: CircleBorder()),
                  ),
                  Text("Offline"),
                  Icon(Icons.warning_amber_sharp),
                  Expanded(child: SizedBox())
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              UserDTOModel userDTOModel =
                  BlocProvider.of<LoginBloc>(context).userDTOModel;
              userDTOModel.userAvailabilityStatus = "away";
              BlocProvider.of<LoginBloc>(context)
                  .add(UpdateUserEvent(userDTOModel: userDTOModel));
              //BlocProvider.of<LoginBloc>(context).add(UpdateAvailabilityStatus(status: "away"));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: 20.0,
                    height: 20.0,
                    decoration: ShapeDecoration(
                        color: Colors.orange, shape: CircleBorder()),
                  ),
                  Text("Away"),
                  Icon(Icons.warning_amber_sharp),
                  Expanded(child: SizedBox())
                ],
              ),
            ),
          ),
          _getDrawerItems(context, model),
          Divider(
            color: Colors.grey,
            height: 2.0,
          ),
          ListTile(
            title: Text("Logout"),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Are You sure to Logout"),
                      actions: [
                        EbOutlineButtonWidget(
                          buttonText: "Cancel",
                          callback: () => Navigator.pop(context),
                        ),
                        EbRaisedButtonWidget(
                          callback: () {
                            FirebaseAuth.instance.signOut().then((value) {
                              SharedPreferences.getInstance()
                                  .then((preferences) {
                                    if(preferences.containsKey("isGoogleAuthenticated")){
                                      BlocProvider.of<LoginBloc>(context).loginRepository.googleSignOut();
                                    }
                                preferences.clear().then((isCleared) =>
                                    isCleared
                                        ? Navigator.pushNamedAndRemoveUntil(
                                            context, Routes.LOGIN, (r) => false)
                                        : null);
                              });
                            });
                          },
                          buttonText: "Ok",
                        )
                      ],
                    );
                  });
            },
            trailing: IconButton(
              onPressed: (){
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Are You sure to Logout"),
                        actions: [
                          EbOutlineButtonWidget(
                            buttonText: "Cancel",
                            callback: () => Navigator.pop(context),
                          ),
                          EbRaisedButtonWidget(
                            callback: () {
                              FirebaseAuth.instance.signOut().then((value) {
                                SharedPreferences.getInstance()
                                    .then((preferences) {
                                  if(preferences.containsKey("isGoogleAuthenticated")){
                                    BlocProvider.of<LoginBloc>(context).loginRepository.googleSignOut();
                                  }
                                  preferences.clear().then((isCleared) =>
                                  isCleared
                                      ? Navigator.pushNamedAndRemoveUntil(
                                      context, Routes.LOGIN, (r) => false)
                                      : null);
                                });
                              });
                            },
                            buttonText: "Ok",
                          )
                        ],
                      );
                    });
              },
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
