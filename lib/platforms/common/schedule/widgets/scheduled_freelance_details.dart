
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_event.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_state.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_update_request_model.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/date_time_row.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/scheduled_freelancer_image/scheduled_freelancer_image.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/sub_widgets/call_now_button/call_now_button.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/sub_widgets/chats/schedule_chat.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_state.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
class ScheduledFreelanceCallDetailPage extends StatelessWidget{
  final String scheduleId;
  final String userId;
  final String? freelancerId;
  ScheduledFreelanceCallDetailPage({required this.userId,
    this.freelancerId,required this.scheduleId});

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ScheduledBloc>(context)
        .add(FetchScheduledCallInfoEvent(scheduledId: scheduleId,
        userId:freelancerId!=null ? freelancerId!:getUserDTOModelObject(context).userId));
    BlocProvider.of<ProfileBloc>(context)
        .add(FetchUserProfileEvent(userId: userId));
    return BlocListener<ScheduledBloc,ScheduledState>(
      listener: (context,state){
        if (state is LoadingScheduleState) {

          ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text("Please Wait...")));
        } else if (state is UpdatedScheduledState) {
          if(state.isUpdated)
            ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
            content: Text("Thanks. Call Details Have Been Updated"),backgroundColor: Colors.green,));
          else
            ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
              content: Text("There was a server error"),backgroundColor: Colors.red,));
          BlocProvider.of<ScheduledBloc>(context)
              .add(FetchScheduledCallInfoEvent(scheduledId: scheduleId,userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId));
          BlocProvider.of<ProfileBloc>(context)
              .add(FetchUserProfileEvent(userId: userId));

        }
        /*else if (state is GetAgoraCallModelState) {
          _scaffoldKey.currentState.removeCurrentSnackBar();
          if (state.callModel!=null)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VideoCall(callModel: state.callModel,role: ClientRole.Audience)),
            );
          else
            _scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: Text("There was a server error"),
              backgroundColor: Colors.red,
            ));
        }
*/
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
                  padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Scheduled Call:"),
                      SizedBox(height: 20.0,),
                      Row(
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  BlocBuilder<ScheduledBloc, ScheduledState>(
                                      builder: (context, state) {
                                        if (state is ScheduledInfoState) {
                                          return ScheduledFreelancerImageWidget(
                                              userId: state.scheduleModel.userId);
                                        } else if (state is LoadingScheduleState) {
                                          return Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [Text("Loading")]);
                                        }
                                        return Container();
                                      })
                                ]),
                            SizedBox(width: 10.0,),
                            BlocBuilder<ScheduledBloc,ScheduledState>(
                              builder: (context,state){
                                if(state is ScheduledInfoState){
                                  return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(state.scheduleModel.userName,
                                          style: TextStyle(color: Color(0xFF1787E0),

                                        ),),
                                        SizedBox(height: 10.0,),
                                        BlocBuilder<LoginBloc,LoginState>(
                                          builder: (context,state){
                                            if(state is GetUserByIdState){
                                              return Text(state.userDTOModel.profileOverview.profileTitle=="" ?Constants.UNTITLED:state.userDTOModel.profileOverview.profileTitle);
                                            }
                                            return Text("Loading");
                                          },
                                        )
                                      ]);

                                }
                                else{
                                  return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Text("Loading")
                                      ]);
                                }
                              },

                            )
                          ]),
                      SizedBox(height: 20.0,),
                      BlocBuilder<ScheduledBloc,ScheduledState>(
                          builder: (context,state){
                            if(state is ScheduledInfoState){
                              return DateTimeRow(scheduleRequest: state.scheduleModel,);
                            }
                            else{
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text("Loading")
                                  ]);
                            }
                          }),                    Divider(height: 2.0, color: Colors.grey.shade500,),

                      BlocBuilder<ScheduledBloc,ScheduledState>(
                        builder: (context,state){
                          if(state is ScheduledInfoState){
                            ScheduleRequest request=state.scheduleModel;
                            if(request.status=="Pending" || request.status=="pending"){
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Your Response:",style: TextStyle(
                                      color: Colors.grey,fontSize: 16.0),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      RaisedButton(onPressed: (){
                                        ScheduleUpdateRequest scheduleUpdateRequest=new ScheduleUpdateRequest(
                                          id: request.id,
                                          userId: request.userId,
                                          status: "Accepted"
                                        );
                                        BlocProvider.of<ScheduledBloc>(context).add(UpdateScheduleEvent(
                                          scheduleUpdateRequest: scheduleUpdateRequest,
                                            scheduleRequest: request));
                                      },child: Center(child: Text("Accept"),),color: Color(0xFF067EED),textColor: Colors.white,),
                                      SizedBox(width: 10.0,),
                                      RaisedButton(onPressed: (){
                                        ScheduleUpdateRequest scheduleUpdateRequest=new ScheduleUpdateRequest(
                                            id: request.id,
                                            userId: request.userId,
                                            status: "Rejected"
                                        );
                                        BlocProvider.of<ScheduledBloc>(context).add(UpdateScheduleEvent(
                                          scheduleRequest: request,
                                            scheduleUpdateRequest: scheduleUpdateRequest));
                                      },child: Center(child: Text("Reject"),),color: Color(0xFF067EED),textColor: Colors.white,),
                                    ],
                                  )
                                ],
                              );

                            }
                            else if(request.status=="Accepted" || request.status=="accepted"){
                              DateTime dateTime=DateTime.parse(request.callScheduled)
                              .add(Duration(minutes: request.duration)).add(Duration(minutes: 15));
                              bool isCallNowButtonEnabled=dateTime.isAfter(DateTime.now());
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text("Call Status: "),
                                        Text("Accepted ",style: TextStyle(color: Colors.black,fontWeight:FontWeight.bold,fontSize: 16.0),),
                                      ],
                                    ),
                                    CallNowButton(scheduleRequest: request,
                                      callback:isCallNowButtonEnabled ? (){
                                      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                                        content: Text("Caller hasnt started the call or you have denied permission."),
                                        backgroundColor: Colors.red,
                                      ));

                                    }:(){},)

                                  ],
                                ),
                              );
                            }
                            else if(request.status=="Rejected" || request.status=="rejected"){
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            text: "Call Status: ",
                                            style: TextStyle(
                                                color: Colors.grey,fontSize: 16.0),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: request.status,
                                                  style: TextStyle(color: Colors.black,fontSize: 16.0))
                                            ]))
                                  ],
                                ),
                              );
                            }
                          }
                          else if(state is LoadingScheduleState){
                            return Center(child: Text("Processing"),);
                          }
                          return Center(child: Text("Loading"),);
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
                        isSchedulingChatByFreelancer: true,
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
