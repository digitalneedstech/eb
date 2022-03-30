import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_update_operations/group_update_operations_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_update_operations/group_update_operations_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_update_operations/group_update_operations_state.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_event.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_state.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_group_update_request.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/shared/utils/schedule_call_functions.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_schedule_operations/group_schedule_update_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_schedule_operations/group_schedule_update_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_schedule_operations/group_schedule_update_state.dart';

class ScheduleGroupCallUpdateButton extends StatelessWidget {
  final GroupModel groupModel;
  final String scheduleId;
  final String userName;
  final Function callback;
  final Function validator;
  final int duration;
  final DateTime selectedDate;
  ScheduleGroupCallUpdateButton(
      {required this.callback,
        required this.validator,
        required this.scheduleId,
        required this.selectedDate,
        required this.groupModel,
        required this.userName,
        required this.duration});
  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupUpdateOperationsBloc, GroupUpdateOperationsState>(
      listener: (context, state) {
        if(state is UpdateGroupScheduleCallState){
          callback(state.isUpdated);
          BlocProvider.of<GroupUpdateOperationsBloc>(context).add(
              FetchGroupScheduledCallByIdEvent(
                  groupId: groupModel.groupId, schedueId: scheduleId));
        }
      },
      child: BlocBuilder<GroupUpdateOperationsBloc, GroupUpdateOperationsState>(
          builder: (context, state) {
            if (state is FetchGroupScheduledCallByIdInProgressState || state is UpdateGroupScheduleCallInProgressState) {
              return EbRaisedButtonWidget(
                callback: (){

                },
                disabledButtontext: "Processing",
                buttonText: "Processing",
                textColor: Colors.white,
              );
            }
            if (state is FetchGroupScheduledCallByIdState) {
              int acceptedStatusCount=0;
              int rejectedStatusCount=0;
              String status="Pending";
              for(Freelancers freelancer in state.scheduleNewRequestModel.schedule.freelancers){
                if(freelancer.status=="accepted" || freelancer.status=="Accepted"){
                  acceptedStatusCount=acceptedStatusCount+1;
                }
                if(freelancer.status=="rejected" || freelancer.status=="Rejected"){
                  rejectedStatusCount=rejectedStatusCount+1;
                }
              }
              if(acceptedStatusCount==state.scheduleNewRequestModel.schedule.freelancers.length){
                status="accepted";
              }

              if(rejectedStatusCount==state.scheduleNewRequestModel.schedule.freelancers.length){
                status="rejected";
              }

              return getWidgetBasedOnStatus(state.scheduleNewRequestModel, context,status);
            }
            return Container();
          }),
    );
  }

  ScheduleNewRequestModel _createScheduleModel() {
    return new ScheduleNewRequestModel(
      type: "group",
      schedule: ScheduleNewRequest(
          callScheduled: DateTime.now().toIso8601String(),
          description: "",
          duration: duration,
          askedRate: 0,
          status: "pending",
          userId: groupModel.adminId,
          groupId: groupModel.groupId),
    );
  }

  void updateScheduleModel(
      ScheduleNewRequestModel scheduleNewRequestModel, String status) {
    scheduleNewRequestModel.schedule.status = "status";
  }

  Widget getWidgetBasedOnStatus(
      ScheduleNewRequestModel scheduleNewRequestModel, BuildContext context,String status) {
    switch (status) {
      case "pending":
      case "Pending":
        return scheduleNewRequestModel.schedule.userId ==
            BlocProvider.of<LoginBloc>(context).userDTOModel.userId
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Call Status : ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Waiting For Users Response")
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Your Response : "),
            InkWell(
                onTap: () {
                  ScheduleUpdateGroupRequest schduleUpdateGroupRequest=new ScheduleUpdateGroupRequest(
                      id: scheduleId,
                      status: "Rejected",
                      groupId:groupModel.groupId,
                      freelancerId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId,
                    freelancerName: BlocProvider.of<LoginBloc>(context).userDTOModel.personalDetails.displayName
                  );
                  BlocProvider.of<GroupUpdateOperationsBloc>(context)
                      .add(UpdateGroupScheduleCallEvent(
                    groupId: groupModel.groupId,
                    groupOwnerId: groupModel.adminId,
                    scheduleNewRequestModel: schduleUpdateGroupRequest,
                  ));
                },
                child: Text(
                  "Reject",
                  style: TextStyle(color: Colors.blue),
                )),
            SizedBox(width: 10.0,),
            EbRaisedButtonWidget(
              callback: () {
                ScheduleUpdateGroupRequest schduleUpdateGroupRequest=new ScheduleUpdateGroupRequest(
                  id: scheduleId,
                  status: "accepted",
                  groupId:groupModel.groupId,
                  freelancerId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId,
                    freelancerName: BlocProvider.of<LoginBloc>(context).userDTOModel.personalDetails.displayName
                );
                BlocProvider.of<GroupUpdateOperationsBloc>(context)
                    .add(UpdateGroupScheduleCallEvent(
                  groupId: groupModel.groupId,
                  groupOwnerId: groupModel.adminId,
                  scheduleNewRequestModel: schduleUpdateGroupRequest,
                ));
              },
              buttonText: "Accept",
            )
          ],
        );
      case "accepted":
      case "Accepted":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Call Status : ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),EbRaisedButtonWidget(
                  disabledButtontext: "Call Expired",
                  callback: DateTime.now()
                      .isAfter(DateTime.parse(scheduleNewRequestModel.schedule.callScheduled)
                      .add(Duration(minutes: scheduleNewRequestModel.schedule.duration))
                  .add(Duration(minutes: 15)))? (){

                  }:() async {
                    if (scheduleNewRequestModel.schedule.userId ==
                        BlocProvider.of<LoginBloc>(context).userDTOModel.userId) {
                      await Permission.camera.request();
                      await Permission.microphone.request();
                      UserDTOModel userDTOModel =
                          BlocProvider.of<LoginBloc>(context).userDTOModel;
                      switch (userDTOModel.planType) {
                        case "pro":
                        case "Pro":
                          walletCalculationBeforeStartingCallForUpdatedModelForAGroup(
                              context, 0, scheduleNewRequestModel,scheduleNewRequestModel.schedule.groupId);
                          break;
                        case "enterprise":
                        case "Enterprise":
                          walletCalculationBeforeStartingCallForUpdatedModelForAGroup(
                              context, 1, scheduleNewRequestModel,scheduleNewRequestModel.schedule.groupId);
                          break;
                        default:
                          walletCalculationBeforeStartingCallForUpdatedModelForAGroup(
                              context, 2, scheduleNewRequestModel,scheduleNewRequestModel.schedule.groupId);
                          break;
                      }
                    } else {
                      BlocProvider.of<CallBloc>(context).add(GetAgoraCallModel(userId: "",
                          scheduleRequest: scheduleNewRequestModel,groupId: groupModel.groupId));
                    }
                  },
                  buttonText: scheduleNewRequestModel.schedule.userId ==
                      BlocProvider.of<LoginBloc>(context).userDTOModel.userId
                      ? "Start Call"
                      : "Join Call",
                )
          ],
        );
      case "rejected":
      case "Rejected":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Call Status:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Rejected:"),
          ],
        );
      default:
        return EbRaisedButtonWidget(
          buttonText: "Schedule Group Call",
          callback: () {
            ScheduleNewRequestModel scheduleNewRequestModel =
            _createScheduleModel();
            BlocProvider.of<GroupBloc>(context).add(
                CreateGroupScheduleCallEvent(
                    scheduleNewRequestModel: scheduleNewRequestModel,
                    groupId: groupModel.groupId));
          },
        );
    }
  }
}
