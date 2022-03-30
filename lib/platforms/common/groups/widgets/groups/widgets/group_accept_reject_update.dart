import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_update_operations/group_update_operations_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_update_operations/group_update_operations_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_update_operations/group_update_operations_state.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';

class GroupAcceptRejectUpdateWidget extends StatelessWidget {
  final GroupModel groupModel;
  final Function callback;
  GroupAcceptRejectUpdateWidget(
      {required this.callback,
        required this.groupModel,
  });
  @override
  Widget build(BuildContext context) {
    List<GroupFreelancerModel> vals=[];
    if(groupModel.adminId!=BlocProvider.of<LoginBloc>(context).userDTOModel.userId) {
      vals = groupModel.groupMembers.entries.where((e) {
        return e.key.userId == BlocProvider
            .of<LoginBloc>(context)
            .userDTOModel
            .userId;
      }).map((e) => e.value).toList();
    }
    return BlocListener<GroupUpdateOperationsBloc, GroupUpdateOperationsState>(
      listener: (context, state) {
        if(state is UpdateFreelancerGroupStatusState){
          callback(state.isUpdated);

        }
      },
      child: BlocBuilder<GroupUpdateOperationsBloc, GroupUpdateOperationsState>(
          builder: (context, state) {
            if (state is UpdateGroupScheduleCallInProgressState) {
              return EbRaisedButtonWidget(
                callback: (){},
                disabledButtontext: "Processing",
                buttonText: "Processing",
                textColor: Colors.white,
              );
            }
            return vals.isEmpty ||  vals[0].isAccept?Container():Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Your Response : "),
                InkWell(
                    onTap: () {
                      BlocProvider.of<GroupUpdateOperationsBloc>(context)
                          .add(UpdateFreelancerGroupStatusEvent(
                        groupId: groupModel.groupId,
                        status: "rejected",
                        freelancerId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId
                      ));
                    },
                    child: Text(
                      "Reject",
                      style: TextStyle(color: Colors.blue),
                    )),
                SizedBox(width: 10.0,),
                EbRaisedButtonWidget(
                  callback: () {
                    BlocProvider.of<GroupUpdateOperationsBloc>(context)
                        .add(UpdateFreelancerGroupStatusEvent(
                        groupId: groupModel.groupId,
                        status: "accepted",
                        freelancerId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId
                    ));
                  },
                  buttonText: "Accept",
                )
              ],
            );

          }),
    );
  }
}
