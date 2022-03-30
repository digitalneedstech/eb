import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_operations/group_operations_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_operations/group_operations_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_operations/group_operations_state.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';

class ScheduleGroupCallButtonByOwner extends StatelessWidget{
  final GroupModel groupModel;
  final String userName;
  final Function callback;
  final Function validator;
  final int duration;
  final DateTime selectedDate;
  ScheduleGroupCallButtonByOwner(
      {required this.callback,
        required this.validator,
        required this.selectedDate,
        required this.groupModel,
        required this.userName,
        this.duration=0});
  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupOperationsBloc, GroupOperationsState>(
      listener: (context, state) {
        if (state is ScheduleGroupCallState) {
          callback(state.isScheduled);
        }
      },
      child: BlocBuilder<GroupOperationsBloc, GroupOperationsState>(
          builder: (context, state) {
            if (state is GroupSchedulingInProgressState) {
              return EbRaisedButtonWidget(
                callback: (){},
                buttonText: "Processing",
                textColor: Colors.white,
              );
            }

            return EbRaisedButtonWidget(
              buttonText: "Schedule Group Call",
              callback: () {
                if (duration==0)
                  validator(false);
                else {
                  ScheduleNewRequestModel scheduleNewRequestModel =
                  _createScheduleModel();
                  BlocProvider.of<GroupOperationsBloc>(context).add(
                      ScheduleGroupCallEvent(
                          scheduleNewRequestModel: scheduleNewRequestModel));
                }
              },
            );
          }),
    );
  }

  ScheduleNewRequestModel _createScheduleModel() {
    double totalAskedRate=0;
    for(UserDTOModel users in groupModel.groupMembers.keys.toList()){
      totalAskedRate=totalAskedRate+users.rateDetails.hourlyRate;
    }
    List<Freelancers> freelancers=groupModel.groupMembers.keys.map((key){
      return new Freelancers(id: key.userId,status: "pending");
    }).toList();
    return new ScheduleNewRequestModel(
      type: "group",
      schedule: ScheduleNewRequest(
          callScheduled: DateTime.now().toIso8601String(),
          description: "Call is Getting scheduled",
          duration: duration,
          askedRate: totalAskedRate,
          status: "pending",
          freelancers: freelancers,
          userId: groupModel.adminId,
          groupId: groupModel.groupId),
    );
  }
}
