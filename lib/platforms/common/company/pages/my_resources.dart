import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_bloc.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_event.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_state.dart';
import 'package:flutter_eb/platforms/common/company/model/resource_model.dart';
import 'package:flutter_eb/platforms/common/company/widgets/add_resource_popup.dart';
import 'package:flutter_eb/platforms/common/company/widgets/update_hours_popup.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/search_associate/search_associate.dart';
import 'package:flutter_eb/shared/widgets/animate_list/animate_list.dart';
import 'package:flutter_eb/shared/widgets/eb_circle_avatar/eb_circle_avatar.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
class ResourcesPage extends StatelessWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    UserDTOModel userDTOModel =
        BlocProvider.of<LoginBloc>(context).userDTOModel;
    BlocProvider.of<CompanyBloc>(context)
        .add(FetchResourcesEvent(companyId: userDTOModel.userId));
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("My Resources"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              //height: MediaQuery.of(context).size.height*0.6,
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "List Of Resources",
                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                      ),
                      RaisedButton(
                        onPressed: () async {
                          bool isResourceAdded = await showDialog(
                              context: context,
                              builder: (context) {
                                return AddResourcesPopup(
                                  callback: (bool isResourceAdded) {
                                    Navigator.pop(context, isResourceAdded);
                                  },
                                );
                              });
                          if(_scaffoldKey.currentState!=null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(isResourceAdded
                                  ? "Resources are Added"
                                  : "Resources Could not be added"),
                              backgroundColor:
                              isResourceAdded ? Colors.green : Colors.red,
                            ));
                          }
                        },
                        child: Center(
                          child: Text("Add Resources"),
                        ),
                        color: Colors.blue,
                        textColor: Colors.white,
                      )
                    ],
                  ),
                  SearchAssociate(
                      fieldTypeToBeSearched: "Freelancer", callback: () {
                    BlocProvider.of<CompanyBloc>(context)
                        .add(FetchResourcesEvent(companyId: userDTOModel.userId,freelancerSearchText:
                    BlocProvider.of<LandingDashboardBloc>(context)
                        .associateNameController.text));
                  }),
                  BlocBuilder<CompanyBloc, CompanyState>(
                      builder: (context, state) {
                        if (state is FetchResourcesState) {
                          if (state.resources.isEmpty) {
                            return NoDataFound();
                          } else {

                            List<dynamic> users =
                            List.from(state.resources.keys.toList());
                            return AnimationLimiter(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: users.length,
                                  itemBuilder: (context, int index) {
                                    dynamic resourceModel = users[index];
                                    CompanyResource resource =
                                    state.resources[resourceModel]!;
                                    return AnimateList(
                                      index: index,
                                      widget:
                                      ListTile(
                                          leading: resourceModel is UserDTOModel ?
                                          EbCircleAvatarWidget(profileImageUrl: resourceModel.personalDetails.profilePic,)
                                              :EbCircleAvatarWidget(),
                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                resourceModel is UserDTOModel ?
                                                (resourceModel.personalDetails
                                                    .displayName ==
                                                    ""
                                                    ? Constants.UNNAMED
                                                    : resourceModel
                                                    .personalDetails.displayName):resourceModel,
                                                style: TextStyle(color: Colors.blue,fontSize: 12.0),
                                              ),
                                            ],
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Text(
                                                resourceModel is UserDTOModel ?(resourceModel.profileOverview
                                                    .profileTitle ==
                                                    ""
                                                    ? Constants.UNNAMED
                                                    : resourceModel
                                                    .profileOverview.profileTitle):"",
                                                style: TextStyle(color: Colors.grey,fontSize: 12.0),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Container(
                                                width: 10.0,
                                                height: 10.0,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: resourceModel is UserDTOModel ?(resourceModel.isVerified
                                                        ? Colors.green
                                                        : Colors.grey):Colors.grey),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(
                                                resourceModel is UserDTOModel ?(resourceModel.isVerified
                                                    ? "Active"
                                                    : "Pending"):"Pending",
                                                style: TextStyle(color: Colors.grey),
                                              )
                                            ],
                                          ),
                                          trailing:resourceModel is UserDTOModel ? PopupMenuButton<String>(

                                            onSelected: (val) async {
                                              switch (val) {
                                                case "Make Active":
                                                  UserDTOModel model=resourceModel;

                                                  ScaffoldMessenger.of(
                                                      context).showSnackBar(
                                                      SnackBar(
                                                          content:
                                                          Text(
                                                              "Make User Active")
                                                      ));
                                                  model.isVerified=true;
                                                  await BlocProvider.of<LoginBloc>(context).loginRepository.updateUser(model);
                                                  ScaffoldMessenger.of(
                                                      context).showSnackBar(
                                                      SnackBar(
                                                        content:
                                                        Text(
                                                            "Details Are Updated"),
                                                        backgroundColor: Colors
                                                            .green,
                                                      ));
                                                  BlocProvider.of<CompanyBloc>(context)
                                                      .add(FetchResourcesEvent(companyId: userDTOModel.userId));
                                                  break;
                                                case "Make Inactive":
                                                  UserDTOModel model=resourceModel;

                                                  ScaffoldMessenger.of(
                                                      context).showSnackBar(
                                                      SnackBar(
                                                          content:
                                                          Text(
                                                              "Making User InActive")
                                                      ));
                                                  model.isVerified=false;
                                                  await BlocProvider.of<LoginBloc>(context)
                                                      .loginRepository
                                                      .updateUser(model);
                                                  ScaffoldMessenger.of(
                                                      context).hideCurrentSnackBar();
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content:
                                                        Text(
                                                            "Details Are Updated"),
                                                        backgroundColor: Colors
                                                            .green,
                                                      ));
                                                  BlocProvider.of<CompanyBloc>(context)
                                                      .add(FetchResourcesEvent(companyId: userDTOModel.userId));
                                                  break;
                                                case "Hours":
                                                  bool isUpdated = await showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return UpdateHoursPopup(
                                                        resource: resourceModel,
                                                        callBack: (
                                                            bool isUpdated) {
                                                          Navigator.pop(
                                                              context,
                                                              isUpdated);
                                                        },
                                                      );
                                                    },
                                                    barrierDismissible: true,
                                                  );
                                                  if (isUpdated) {
                                                    ScaffoldMessenger.of(
                                                        context).showSnackBar(
                                                        SnackBar(
                                                          content:
                                                          Text(
                                                              "Details Are Updated"),
                                                          backgroundColor: Colors
                                                              .green,
                                                        ));
                                                    BlocProvider.of<CompanyBloc>(context)
                                                        .add(FetchResourcesEvent(companyId: userDTOModel.userId));
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                        context).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              "There was an error. Details Are Not Updated"),
                                                          backgroundColor: Colors
                                                              .red,
                                                        ));
                                                  }
                                              }
                                            },
                                            itemBuilder: (BuildContext context) {
                                              return {'Hours', resourceModel.isVerified ?"Make Inactive":"Make Active"}
                                                  .map((String choice) {
                                                return PopupMenuItem<String>(
                                                  value: choice,
                                                  child: Text(choice),
                                                );
                                              }).toList();
                                            },
                                          ):SizedBox(width: 0,height: 0,)),
                                    );
                                  }),
                            );
                          }
                        } else {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text("Loading")],
                            ),
                          );
                        }
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
