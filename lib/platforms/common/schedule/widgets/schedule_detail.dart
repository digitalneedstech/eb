import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_event.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_state.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/date_time_row.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/rate_duration_row.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/schedule_popup.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/scheduled_freelancer_image/scheduled_freelancer_image.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/sub_widgets/chats/schedule_chat.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/sub_widgets/schedule_button/schedule_button.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_state.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
class ScheduledCallDetailPage extends StatelessWidget {
  final String scheduleId;
  final String userId;
  ScheduledCallDetailPage({required this.userId,required this.scheduleId});

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ScheduledBloc>(context).add(FetchScheduledCallInfoEvent(
        scheduledId: scheduleId,
        userId: userId == ""
            ? BlocProvider.of<LoginBloc>(context).userDTOModel.userId
            : userId));
    return BlocListener<ScheduledBloc, ScheduledState>(
      listener: (context, state) {
        if (state is LoadingScheduleState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Wait...")));
        } else if (state is CreatedScheduledState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Thanks. Call Details Have Been Updated"),
            backgroundColor: Colors.green,
          ));
          Future.delayed(Duration(seconds: 2), () {
            //Navigator.popAndPushNamed(context, Routes.BID_LIST);
          });
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: Text("Schedule Call Details"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                //height: MediaQuery.of(context).size.height*0.45,
                margin: const EdgeInsets.all(20.0),

                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                  // border: Border.all(color: Colors.grey.shade500,width: 1.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*BlocBuilder<ScheduledBloc, ScheduledState>(
                        builder: (context, state) {
                          if (state is ScheduledInfoState) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Scheduled Call:"),
                                InkWell(
                                  onTap: (){
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return SchedulePopUp(scheduleRequest: state.scheduleModel);
                                        },
                                        barrierDismissible: false);
                                  },
                                  child: Text("RESCHEDULE",style: TextStyle(color: Colors.blue),),
                                )
                              ],
                            );
                          } else if (state is LoadingScheduleState) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text("Loading")]);
                          }
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text("Error")]);
                        },
                      ),*/
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              BlocBuilder<ScheduledBloc, ScheduledState>(
                                  builder: (context, state) {
                                if (state is ScheduledInfoState) {
                                  return ScheduledFreelancerImageWidget(
                                      userId: state.scheduleModel.freelancerId);
                                } else if (state is LoadingScheduleState) {
                                  return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [Text("Loading")]);
                                }
                                return Container();
                              })
                            ]),
                        SizedBox(
                          width: 10.0,
                        ),
                        BlocBuilder<ScheduledBloc, ScheduledState>(
                          builder: (context, state) {
                            if (state is ScheduledInfoState) {
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.scheduleModel.freelancerName,
                                      style: TextStyle(
                                        color: Color(0xFF1787E0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    BlocBuilder<LoginBloc,LoginState>(
                                      builder: (context,state){
                                        if(state is GetUserByIdState){
                                          return Text(state.userDTOModel.profileOverview.profileTitle=="" ?Constants.UNTITLED:state.userDTOModel.profileOverview.profileTitle);
                                        }
                                        return Text("Loading");
                                      },
                                    )
                                  ]);
                            } else if (state is LoadingScheduleState) {
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [Text("Loading")]);
                            }
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text("Error")]);
                          },
                        )
                      ]),
                      SizedBox(
                        height: 20.0,
                      ),
                      BlocBuilder<ScheduledBloc, ScheduledState>(
                          builder: (context, state) {
                        if (state is ScheduledInfoState) {
                          return DateTimeRow(
                            scheduleRequest: state.scheduleModel,
                          );
                        } else if (state is LoadingScheduleState) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text("Loading")]);
                        }
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text("Error")]);
                      }),
                      BlocBuilder<ScheduledBloc, ScheduledState>(
                          builder: (context, state) {
                        if (state is ScheduledInfoState) {
                          return RateDurationRow(
                            scheduleRequest: state.scheduleModel,
                          );
                        } else if (state is LoadingScheduleState) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [Text("Loading")]);
                        }
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text("Error")]);
                      }),
                      Divider(
                        height: 2.0,
                        color: Colors.grey.shade500,
                      ),
                      BlocBuilder<ScheduledBloc, ScheduledState>(
                        builder: (context, state) {
                          if (state is ScheduledInfoState) {
                            ScheduleRequest request = state.scheduleModel;
                            if (request.status == "pending") {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            text: "Call Status: ",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0),
                                            children: <TextSpan>[
                                          TextSpan(
                                              text: " Waiting For Response",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.0))
                                        ]))
                                  ],
                                ),
                              );
                            } else if (request.status == "Accepted" ||
                                request.status == "accepted") {
                              DateTime dateTime = DateTime.parse(
                                  state.scheduleModel.callScheduled).add(Duration(
                                minutes: state.scheduleModel.duration
                              )).add(Duration(minutes: 15));
                              bool isCallNowButtonEnabled =
                                  dateTime.isAfter(DateTime.now());
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text("Call Status: "),
                                        Text(
                                          "Accepted ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                    ScheduleButton(
                                        scheduleRequest: state.scheduleModel,
                                        callback: isCallNowButtonEnabled
                                            ? () {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  content: Text(
                                                      "There was a server or permissions error recorded while scheduling or sending notification"),
                                                  backgroundColor: Colors.red,
                                                ));
                                              }
                                            : (){}),
                                  ],
                                ),
                              );
                            } else if (request.status == "Rejected" ||
                                request.status == "rejected") {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            text: "Call Status: ",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0),
                                            children: <TextSpan>[
                                          TextSpan(
                                              text: request.status,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.0))
                                        ]))
                                  ],
                                ),
                              );
                            }
                          }
                          return Center(
                            child: Text("Loading"),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              BlocBuilder<ScheduledBloc, ScheduledState>(
                  builder: (context, state) {
                if (state is ScheduledInfoState) {
                  return ScheduleChat(
                    scheduleRequest: state.scheduleModel,
                    chatUserId: state.scheduleModel.freelancerId,
                    isSchedulingChatByFreelancer: false,
                  );
                } else if (state is LoadingScheduleState) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text("Loading")]);
                }
                return Container();
              })
            ],
          ),
        ),
      ),
    );
  }
}
