import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/scheduled_calls_bloc/scheduled_call_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/scheduled_calls_bloc/scheduled_call_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/scheduled_calls_bloc/scheduled_call_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/mixins/update_status_text_color.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/filter/filter.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/search_associate/search_associate.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/schedule_detail.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/scheduled_freelance_details.dart';
import 'package:flutter_eb/shared/widgets/animate_list/animate_list.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
class FreelanceAsAScheduledCallsMade extends StatelessWidget with UpdateStatusText {
  bool isFreelancer;
  FreelanceAsAScheduledCallsMade({this.isFreelancer = false});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ScheduledCallsDashboardBloc>(context).add(
        FetchScheduledCallsDashboardMadeEvent(
            userType: BlocProvider.of<LoginBloc>(context)
                .userDTOModel.userType,
            userId: BlocProvider.of<LoginBloc>(context)
                .userDTOModel.userId,
            associateName: BlocProvider.of<LandingDashboardBloc>(context)
                .associateNameController
                .text,
            fieldTypeToBeSearched: isFreelancer ? "Client" : "Freelancer",
            dateFilter:
            3));
    return SingleChildScrollView(
      child: Column(
        children: [
          SearchAssociate(
            fieldTypeToBeSearched: isFreelancer ? "Client" : "Freelancer",
            callback: () {
              BlocProvider.of<ScheduledCallsDashboardBloc>(context).add(
                  FetchScheduledCallsDashboardMadeEvent(
                      userType: BlocProvider.of<LoginBloc>(context)
                          .userDTOModel.userType,
                      userId: BlocProvider.of<LoginBloc>(context)
                          .userDTOModel.userId,
                      associateName:
                      BlocProvider.of<LandingDashboardBloc>(context)
                          .associateNameController
                          .text,
                      fieldTypeToBeSearched:
                      isFreelancer ? "Client" : "Freelancer",
                      dateFilter: BlocProvider.of<LandingDashboardBloc>(context)
                          .selectedFiter));
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilterPage(
                callback: () {
                  BlocProvider.of<ScheduledCallsDashboardBloc>(context).add(
                      FetchScheduledCallsDashboardMadeEvent(
                          userType: BlocProvider.of<LoginBloc>(context)
                              .userDTOModel.userType,
                          userId: BlocProvider.of<LoginBloc>(context)
                              .userDTOModel.userId,
                          associateName:
                          BlocProvider.of<LandingDashboardBloc>(context)
                              .associateNameController
                              .text,
                          fieldTypeToBeSearched:
                          isFreelancer ? "Client" : "Freelancer",
                          dateFilter:
                          BlocProvider.of<LandingDashboardBloc>(context)
                              .selectedFiter));
                },
              ),
            ],
          ),
          BlocBuilder<ScheduledCallsDashboardBloc,
              ScheduledCallsDashboardState>(builder: (context, state) {
            if (state is ScheduledCallsDashboardMadeState) {
              if (state.requests.isEmpty)
                return NoDataFound();
              else {
                List<ScheduleRequest> calls = isFreelancer
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
                if (calls.isEmpty) return NoDataFound();
                return AnimationLimiter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: calls.length,
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (context, int index) {
                      ScheduleRequest call = state.requests[index];

                      updateStatusText(call.status);
                      if (isFreelancer)
                        BlocProvider.of<ProfileBloc>(context)
                            .add(FetchUserProfileEvent(userId: call.userId));
                      DateTime date=DateTime.parse(call.callScheduled);
                      String time=date.hour.toString()+"-"+date.minute.toString();
                      return AnimateList(
                        index: index,
                        widget: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => isFreelancer
                                      ? ScheduledFreelanceCallDetailPage(
                                      scheduleId: call.id,userId: call.userId,)
                                      : ScheduledCallDetailPage(
                                    scheduleId: call.id,userId: call.freelancerId,
                                  )),
                            );
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
                             Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text("Client Name"),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          call.userName ?? Constants.UNNAMED,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text("Date & Time"),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Text(date.toIso8601String().split("T")[0].toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text("Status",
                                            style: TextStyle(color: Colors.blue)),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                                color: statusColor,
                                                borderRadius:
                                                BorderRadius.circular(10.0)),
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
        ],
      ),
    );
  }
}
