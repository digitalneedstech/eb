import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_schedule_operations/group_schedule_update_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_schedule_operations/group_schedule_update_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_schedule_operations/group_schedule_update_state.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/group_detail_page/sub_widgets/group_freelancer_individual_status.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/group_detail_page/sub_widgets/group_freelancer_tile.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/listing_page.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/constants/routes.dart';

class GroupFreelancersStatus extends StatelessWidget {
  final GroupModel groupModel;
  final Function callback;
  final String scheduleId;
  GroupFreelancersStatus({this.scheduleId="", required this.callback, required this.groupModel});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GroupScheduleUpdateOperationsBloc>(context).add(
        FetchFreelancerScheduledCallStatusEvent(
            groupModel: groupModel, scheduleId: scheduleId));
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(10.0),
      color: Colors.white,
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${groupModel.groupMembers.length} Members",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),

            ],
          ),
          BlocBuilder<GroupScheduleUpdateOperationsBloc,
              GroupScheduleUpdateOperationsState>(
            builder: (context, state) {
              if (state is FetchFreelancerScheduledCallStatusInProgressState) {
                return Center(
                  child: Text("Loading"),
                );
              }
              if (state is FetchFreelancerScheduledCallStatusState) {
                return ListView.builder(
                  itemBuilder: (context, int index) {
                    List<UserDTOModel> users =
                        state.freelanceModelWithStatusMap.keys.toList();
                    return GroupFreelancerIndividualStatus(
                      status: state.freelanceModelWithStatusMap[users[index]]!,
                      callback: (bool flag, String message) {
                        callback(flag, message);
                      },
                      freelancerModel: users[index],
                    );
                  },
                  physics: BouncingScrollPhysics(),
                  itemCount: state.freelanceModelWithStatusMap.length,
                  shrinkWrap: true,
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}
