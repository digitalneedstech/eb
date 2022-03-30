import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/scheduled_calls_bloc/scheduled_call_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/scheduled_calls_bloc/scheduled_call_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/scheduled_calls_bloc/scheduled_call_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/utils.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/filter/filter.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/search_associate/search_associate.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/sub_widgets/switch_widget/switch_widget.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/schedule_detail.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/scheduled_freelance_details.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/animate_list/animate_list.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../mixins/update_status_text_color.dart';

class ScheduledCallsMade extends StatelessWidget with UpdateStatusText {
  bool isFreelancer;
  ScheduledCallsMade({this.isFreelancer = false});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LandingDashboardBloc>(context).selectedFiter = 0;
    BlocProvider.of<ScheduledCallsDashboardBloc>(context).add(
        FetchScheduledCallsDashboardMadeEvent(
            userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId,
            userType: BlocProvider.of<LoginBloc>(context).userProfileType,
            associateName: BlocProvider.of<LandingDashboardBloc>(context)
                .associateNameController
                .text,
            fieldTypeToBeSearched: isFreelancer ? "Client" : "Freelancer",
            dateFilter:
                BlocProvider.of<LandingDashboardBloc>(context).selectedFiter));
    return Column(
      children: [
        Container(
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SearchAssociate(
                    fieldTypeToBeSearched:
                        isFreelancer ? "Client" : "Freelancer",
                    callback: () {
                      //TODO-Check this.

                      BlocProvider.of<ScheduledCallsDashboardBloc>(context).add(
                          FetchScheduledCallsDashboardMadeEvent(
                              userType: BlocProvider.of<LoginBloc>(context)
                                  .userDTOModel
                                  .personalDetails
                                  .type,
                              userId: BlocProvider.of<LoginBloc>(context)
                                  .userDTOModel
                                  .userId,
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilterPage(
                      callback: () {
                        BlocProvider.of<ScheduledCallsDashboardBloc>(context)
                            .add(FetchScheduledCallsDashboardMadeEvent(
                                userType: BlocProvider.of<LoginBloc>(context)
                                    .userDTOModel
                                    .personalDetails
                                    .type,
                                userId: BlocProvider.of<LoginBloc>(context)
                                    .userDTOModel
                                    .userId,
                                associateName:
                                    BlocProvider.of<LandingDashboardBloc>(
                                            context)
                                        .associateNameController
                                        .text,
                                fieldTypeToBeSearched:
                                    getSearchType(isFreelancer, context),
                                dateFilter:
                                    BlocProvider.of<LandingDashboardBloc>(
                                            context)
                                        .selectedFiter));
                      },
                    ),
                  ],
                ),
              ],
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Group"),
            EbSwitchWidget((val) {
              BlocProvider.of<ScheduledCallsDashboardBloc>(context).add(
                  FetchScheduledCallsDashboardMadeEvent(
                      userId: BlocProvider.of<LoginBloc>(context)
                          .userDTOModel
                          .userId,
                      userType:
                          BlocProvider.of<LoginBloc>(context).userProfileType,
                      associateName:
                          BlocProvider.of<LandingDashboardBloc>(context)
                              .associateNameController
                              .text,
                      fieldTypeToBeSearched:
                          isFreelancer ? "Client" : "Freelancer",
                      dateFilter: BlocProvider.of<LandingDashboardBloc>(context)
                          .selectedFiter,
                      callsType: "group"));
            })
          ],
        ),
        Expanded(
          child: BlocBuilder<ScheduledCallsDashboardBloc,
              ScheduledCallsDashboardState>(builder: (context, state) {
            if (state is ScheduledCallsDashboardMadeState) {
              if (state.requests.isEmpty)
                return NoDataFound();
              else {
                List<ScheduleRequest> calls = [];
                if (BlocProvider.of<LoginBloc>(context).userProfileType !=
                    Constants.CUSTOMER) {
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
                } else
                  calls = state.requests;
                if (calls.isEmpty) return NoDataFound();
                return AnimationLimiter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: calls.length,
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (context, int index) {
                      ScheduleRequest call = calls[index];

                      updateStatusText(call.status);
                      if (isFreelancer)
                        BlocProvider.of<ProfileBloc>(context)
                            .add(FetchUserProfileEvent(userId: call.userId));
                      DateTime date = DateTime.parse(call.callScheduled);
                      String time =
                          date.hour.toString() + "-" + date.minute.toString();
                      return AnimateList(
                        index: index,
                        widget: InkWell(
                          onTap: () {
                            if (kIsWeb) {
                              isFreelancer
                                  ? Navigator.pushNamed(
                                      context,
                                      "scheduleCallDetail/" +
                                          call.id +
                                          "/" +
                                          call.userId)
                                  : Navigator.pushNamed(
                                      context,
                                      "scheduleCall/" +
                                          call.id +
                                          "/" +
                                          call.freelancerId);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => isFreelancer
                                        ? ScheduledFreelanceCallDetailPage(
                                            scheduleId: call.id,
                                            userId: call.userId,
                                            freelancerId: call.freelancerId,
                                          )
                                        : ScheduledCallDetailPage(
                                            scheduleId: call.id,
                                            userId: call.freelancerId,
                                          )),
                              );
                            }
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
                                                call.freelancerName,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  (getUserDTOModelObject(context).userType ==
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            call.groupId == null ||
                                                    call.groupId == ""
                                                ? Icon(Icons.person)
                                                : Icon(Icons.person_add)
                                          ],
                                        )
                                      : Container(),
                                  (getUserDTOModelObject(context).userType ==
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
                                                call.freelancerName,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            call.groupId == null ||
                                                    call.groupId == ""
                                                ? Icon(Icons.person)
                                                : Icon(Icons.person_add)
                                          ],
                                        )
                                      : Container(),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text("Date & Time"),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                              date
                                                  .toIso8601String()
                                                  .split("T")[0]
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left))
                                    ],
                                  ),
                                  (getUserDTOModelObject(context).companyId ==
                                          "")
                                      ? Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text("Duration"),
                                            ),
                                            Expanded(
                                                flex: 3,
                                                child: Text(
                                                    call.duration.toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.left))
                                          ],
                                        )
                                      : Container(),
                                  (getUserDTOModelObject(context).companyId ==
                                          "")
                                      ? Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text("Rates /Hr"),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                  call.askedRate.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.left),
                                            )
                                          ],
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text("Status",
                                            style:
                                                TextStyle(color: Colors.blue)),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                                color: statusColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            child: Center(
                                              child: Text(
                                                status,
                                                style: TextStyle(
                                                    color: statusTextColor),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              )
                              /*child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text("Freelancer Name"),
                                      Text("Date & Time"),
                                      Text("Rates /Hr"),
                                      Text("Amount Debited"),

                                      Text(
                                        "Status",
                                        style: TextStyle(color: Colors.blue),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10.0,),
                                  Column(
                                    children: [
                                      isFreelancer ?BlocBuilder<ProfileBloc,ProfileState>
                                        (builder:(context,profileState){
                                        if(profileState is FetchUserProfileState) {
                                          return Text(profileState.userDTOModel.personalDetails.displayName,
                                            style: TextStyle(fontWeight: FontWeight.bold),);
                                        }
                                        else{
                                          return Text("Loading",
                                            style: TextStyle(fontWeight: FontWeight.bold),);
                                        }
                                      },):
                                      Text(call.freelancerName,style: TextStyle(fontWeight: FontWeight.bold),),
                                      Text(call.duration.toString(), style: TextStyle(
                                          fontWeight: FontWeight.bold), textAlign: TextAlign
                                          .left),
                                      Text(call.askedRate.toString(), style: TextStyle(
                                          fontWeight: FontWeight.bold), textAlign: TextAlign
                                          .left),
                                      Text(call.askedRate.toString(),
                                          textAlign: TextAlign.left),
                                      Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xFFFFEFC5),
                                            borderRadius: BorderRadius.circular(10.0)),
                                        child: Center(
                                          child: Text(
                                            call.status,
                                            style: TextStyle(color: Color(0xFFC18B09)),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),*/
                              ),
                        ),
                      );
                    },
                  ),
                );
              }
            } else
              return Center(child: Text("Loading"));
          }),
        ),
      ],
    );
  }
}
