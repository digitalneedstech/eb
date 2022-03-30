import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/calls_bloc/calls_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/calls_bloc/calls_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/calls_bloc/calls_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/utils.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/filter/filter.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/schedule_call/schedule_call.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/search_associate/search_associate.dart';
import 'package:flutter_eb/shared/widgets/animate_list/animate_list.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CallsMade extends StatelessWidget {
  bool isFreelancer;
  CallsMade({this.isFreelancer = false});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LandingDashboardBloc>(context)
        .selectedFiter=0;
    BlocProvider.of<CallsDashboardBloc>(context).add(FetchCallsMadeEvent(
        userId: BlocProvider.of<LoginBloc>(context)
            .userDTOModel
            .userId,
        userType: BlocProvider.of<LoginBloc>(context)
            .userProfileType,
        associateName: BlocProvider.of<LandingDashboardBloc>(context)
            .associateNameController
            .text,
        fieldTypeToBeSearched: isFreelancer ? "Client" : "Freelancer",
        dateFilter:
        BlocProvider.of<LandingDashboardBloc>(context)
            .selectedFiter));
    return RefreshConfiguration(
      footerTriggerDistance: 15,
      dragSpeedRatio: 0.91,
      headerBuilder: () => MaterialClassicHeader(),
      footerBuilder: () => ClassicFooter(),
      enableLoadingWhenNoData: false,
      enableRefreshVibrate: false,
      enableLoadMoreVibrate: false,
      shouldFooterFollowWhenNotFull: (state) {
        // If you want load more with noMoreData state ,may be you should return false
        return false;
      },
      child: Column(

        children: [
          Container(
              margin: EdgeInsets.all(10),
              child:Row(
                children: [
                  Expanded(
                    flex:3,
                    child: SearchAssociate(
                      fieldTypeToBeSearched: isFreelancer ? "Client" : "Freelancer",
                      callback: () {
                        BlocProvider.of<CallsDashboardBloc>(context).add(
                            FetchCallsMadeEvent(
                                userType: BlocProvider.of<LoginBloc>(context)
                                    .userDTOModel.personalDetails.type,
                                userId: BlocProvider.of<LoginBloc>(context)
                                    .userDTOModel.userId,
                                associateName:
                                BlocProvider.of<LandingDashboardBloc>(context)
                                    .associateNameController
                                    .text,
                                fieldTypeToBeSearched:
                                getSearchType(isFreelancer, context),
                                dateFilter: BlocProvider.of<LandingDashboardBloc>(context)
                                    .selectedFiter));
                      },
                    ),
                  ),
                  FilterPage(
                    callback: () {
                      BlocProvider.of<CallsDashboardBloc>(context).add(
                          FetchCallsMadeEvent(
                              userType: BlocProvider.of<LoginBloc>(context)
                                  .userDTOModel.personalDetails.type,
                              userId: BlocProvider.of<LoginBloc>(context)
                                  .userDTOModel.userId,
                              associateName:
                              BlocProvider.of<LandingDashboardBloc>(context)
                                  .associateNameController
                                  .text,
                              fieldTypeToBeSearched:
                              getSearchType(isFreelancer, context),
                              dateFilter:
                              BlocProvider.of<LandingDashboardBloc>(context)
                                  .selectedFiter));
                    },
                  ),
                ],
              )),
          Expanded(
            child: BlocBuilder<CallsDashboardBloc, CallsDashboardState>(
              builder: (context, state) {
                if (state is CallsMadeState) {
                  if (state.requests.isEmpty) return NoDataFound();
                  List<CallModel> calls=[];
                  if(BlocProvider.of<LoginBloc>(context).userProfileType!=Constants.CUSTOMER) {
                    calls = isFreelancer
                        ? List.from(state.requests
                        .where((e) =>
                    e.userId !=
                        BlocProvider.of<LoginBloc>(context)
                            .userDTOModel
                            .userId)
                        .toList())
                        : List.from(state.requests
                        .where((e) =>
                    e.userId ==
                        BlocProvider.of<LoginBloc>(context)
                            .userDTOModel
                            .userId)
                        .toList());
                  }
                  else
                    calls=state.requests;
                  if (calls.isEmpty) return NoDataFound();
                  return AnimationLimiter(child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: calls.length,
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (context, int index) {
                      CallModel call = calls[index];
                      if (isFreelancer)
                        BlocProvider.of<ProfileBloc>(context)
                            .add(FetchUserProfileEvent(userId: call.userId));
                      return AnimateList(
                        index: index,
                        widget: InkWell(
                          onTap: () {

                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5.0,
                                        spreadRadius: 2.0)
                                  ]),
                              margin: const EdgeInsets.all(10.0),
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  getUserDTOModelObject(context).userType ==
                                          Constants.ORAGNIZATION
                                      ? Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text("Resource Name"),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          call.receiverName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  )
                                      : Container(),
                                  (getUserDTOModelObject(context)
                                          .userType ==
                                          Constants.ORAGNIZATION) ||
                                      (getUserDTOModelObject(context)
                                          .userType ==
                                          Constants.INDIVIDUAL &&
                                          isFreelancer)
                                      ? Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text("Client Name"),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          call.userName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      call.groupId==""
                                          ? Icon(Icons.person):Icon(Icons.person_add)
                                    ],
                                  )
                                      : Container(),
                                      (getUserDTOModelObject(context)
                                          .userType ==
                                          Constants.INDIVIDUAL &&
                                          !isFreelancer)
                                      ? Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text("Freelancer Name"),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          call.receiverName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      call.groupId==""
                                          ? Icon(Icons.person):Icon(Icons.person_add)
                                    ],
                                  )
                                      : Container(),
                                  (getUserDTOModelObject(context)
                                      .companyId =="")?Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text("Duration"),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Text(call.duration.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left))
                                    ],
                                  ):Container(),
                                  (getUserDTOModelObject(context)
                                      .companyId =="") ?Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text("Rates /Hr"),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(call.acceptedPrice.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left),
                                      )
                                    ],
                                  ):Container(),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text("Amount Debited"),
                                      ),
                                      Expanded(
                                        child: Text(call.finalRate==0.0?"Calculating":
                                        call.finalRate.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  (getUserDTOModelObject(context)
                                      .userType ==
                                      Constants.INDIVIDUAL &&
                                      !isFreelancer) ?Row(
                                    children: [
                                      Expanded(
                                        child: RaisedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ScheduleCall(callModel:call,buttonTitle: "Call Now",)),
                                            );
                                          },
                                          color: Colors.blue,
                                          child: Center(
                                            child: Text(
                                              "Call Again",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Container(
                                              child: Center(
                                                  child: Text("Review",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: Colors.blue))))),
                                    ],
                                  ):Container(),
                                ],
                              )),
                        ),
                      );
                    },
                  ));
                } else
                  return Center(
                    child: Text("Loading"),
                  );
              },
            ),
          ),
        ],
      ),
    );
  }
}
