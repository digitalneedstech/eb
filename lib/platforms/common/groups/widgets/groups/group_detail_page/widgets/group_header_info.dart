import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_update_operations/group_update_operations_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_update_operations/group_update_operations_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_update_operations/group_update_operations_state.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/group_detail_page/group_detail_page.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/widgets/group_accept_reject_update.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/widgets/schedule_group_call_button.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/widgets/schedule_group_call_update.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_event.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_state.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/widgets/eb_circle_avatar/eb_circle_avatar.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:flutter_eb/shared/widgets/loading_shimmer/loading_shimmer.dart';
import 'package:intl/intl.dart';

class GroupHeaderInfoWidget extends StatelessWidget {
  final GroupModel groupModel;
  final bool isOlderMeeting;
  final String scheduleId;
  final Function callback;
  GroupHeaderInfoWidget({this.scheduleId="",this.isOlderMeeting=false, required this.callback,
    required this.groupModel});
  @override
  Widget build(BuildContext context) {
    if(scheduleId!="") {
      BlocProvider.of<GroupUpdateOperationsBloc>(context).add(
          FetchGroupScheduledCallByIdEvent(
              groupId: groupModel.groupId, schedueId: scheduleId));
    }
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(10.0),
      //height: isOlderMeeting ? MediaQuery.of(context).size.height * 0.3:MediaQuery.of(context).size.height * 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            groupModel.groupName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            "${groupModel.groupMembers.length} members",
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(
            height: 10.0,
          ),
          GroupOwnerInfo(
            adminId: groupModel.adminId,
          ),
          SizedBox(
            height: 10.0,
          ),
          isOlderMeeting ? ScheduleCallDateDetails(groupId: groupModel.groupId,scheduleId: scheduleId,):Container(),
          isOlderMeeting ?SizedBox(
            height: 10.0,
          ):Container(),
          isOlderMeeting ?ScheduleCallAmountAndDurationDetails(groupId: groupModel.groupId,):Container(),

          isOlderMeeting?Divider(
            color: Colors.grey,
          ):Container(),
          isOlderMeeting ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              scheduleId=="" ? (BlocProvider.of<LoginBloc>(context).userDTOModel.userId==groupModel.adminId ? ScheduleGroupCallButtonByOwner(
                userName: BlocProvider.of<LoginBloc>(context)
                    .userDTOModel
                    .personalDetails
                    .displayName,
                validator: (bool isValid) {
                  if (!isValid)
                    callback(false, "Please Select All the fields",false);
                },
                callback: (bool isCreated) {
                  if (isCreated) {
                    callback(isCreated, "Schedule is Created",true);
                    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Schedule is Created"),backgroundColor: Colors.green,));
                  } else {
                    callback(isCreated, "Schedule cant Created",false);
                    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Schedule cannt be Created"),backgroundColor: Colors.red,));
                  }
                },
                groupModel:groupModel, selectedDate: DateTime.now(),
              ):Container()):
               ScheduleGroupCallUpdateButton(
                 selectedDate: DateTime.now(),
                duration: 0,
                userName: BlocProvider.of<LoginBloc>(context)
                    .userDTOModel
                    .personalDetails
                    .displayName,
                validator: (bool isValid) {
                  if (!isValid)
                    callback(false, "Please Select All the fields",false);
                },
                callback: (bool isCreated) {
                  if (isCreated) {
                    callback(Colors.green, "Schedule is Created",false);
                    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Schedule is Created"),backgroundColor: Colors.green,));
                  } else {
                    callback(Colors.red, "Schedule cant Created",false);
                    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Schedule cannt be Created"),backgroundColor: Colors.red,));
                  }
                },
                groupModel:groupModel,
                scheduleId: scheduleId,
              )
            ],
          ):BlocProvider.of<LoginBloc>(context).userDTOModel.userId==groupModel.adminId ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EbRaisedButtonWidget(
                buttonText: "Schedule Group Call",
                callback: () {
    if(kIsWeb){
    Navigator.pushNamed(context, "group/"+groupModel.groupId+"/null/true");
    }else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  GroupDetailPage(
                    groupId: groupModel.groupId,
                    isScheduleEnabled: true,
                  )));
    }
                },
              ),
            ],
          ):GroupAcceptRejectUpdateWidget(groupModel: groupModel,callback: (bool isupdated){
            if (isupdated) {
              callback(Colors.green, "Status is Updated",true);
              //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Schedule is Created"),backgroundColor: Colors.green,));
            } else {
              callback(Colors.red, "Status cant Updated",false);
              //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Schedule cannt be Created"),backgroundColor: Colors.red,));
            }
          })
        ],
      ),
    );
  }
}

class GroupOwnerInfo extends StatelessWidget {
  final String adminId;
  GroupOwnerInfo({this.adminId=""});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LoginBloc>(context).add(GetUserByIdEvent(userId: adminId));
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state is LoadingState) {
        return LoadingShimmerWidget();
      }
      if(state is ExceptionState){
        return Text(state.message);
      }
      if (state is GetUserByIdState) {
        if (state.userDTOModel.userId == "") {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text("Admin Info Not Found")],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: EbCircleAvatarWidget(profileImageUrl: state.userDTOModel.personalDetails.profilePic),
              ),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.userDTOModel.personalDetails.displayName,
                    style: TextStyle(color: Colors.blue),
                  )
                ],
              ))
            ],
          );
        }
      }
      return LoadingShimmerWidget();
    });
  }
}

class ScheduleCallDateDetails extends StatelessWidget {
  final String groupId;
  final String scheduleId;
  ScheduleCallDateDetails({required this.groupId,required this.scheduleId});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupUpdateOperationsBloc, GroupUpdateOperationsState>(builder: (context, state) {
      if (state is FetchGroupScheduledCallByIdState) {
        DateTime dateTime = DateTime.parse(
            state.scheduleNewRequestModel.schedule.callScheduled);
        DateTime endDateTime = dateTime.add(
            Duration(minutes: state.scheduleNewRequestModel.schedule.duration));
        String date = dateTime.day.toString() +
            "-" +
            Constants.months[dateTime.month]! +
            "-" +
            dateTime.year.toString();
        return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(date)
                ],
              ),
              SizedBox(width: 20.0,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Time",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(DateFormat.Hms().format(dateTime) +
                      " - " +
                      DateFormat.Hms().format(endDateTime))
                ],
              ),
              Expanded(child: SizedBox())
            ]);
      }
      else if (state is FetchGroupScheduledCallByIdInProgressState) {
        return LoadingShimmerWidget();
      }
      return Container();
    });
  }
}


class ScheduleCallAmountAndDurationDetails extends StatelessWidget {
  final String groupId;
  ScheduleCallAmountAndDurationDetails({required this.groupId});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupUpdateOperationsBloc, GroupUpdateOperationsState>(builder: (context, state) {
      if (state is FetchGroupScheduledCallByIdState) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Amount",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text("\$ "+state.scheduleNewRequestModel.schedule.askedRate.toString())
                ],
              ),
              SizedBox(width: 20.0,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Duration",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(state.scheduleNewRequestModel.schedule.duration.toString()+" mins")
                ],
              ),
              Expanded(child: SizedBox())
            ]);
      }
      if(state is FetchGroupScheduledCallByIdInProgressState){
        return LoadingShimmerWidget();
      }
      return Container();
    });
  }
}