import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_operations/group_operations_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_operations/group_operations_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_operations/group_operations_state.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/widgets/loading_shimmer/loading_shimmer.dart';
import 'package:intl/intl.dart';

class UpcomingMeetingsPage extends StatelessWidget {
  final String groupId;
  final callback;
  UpcomingMeetingsPage({this.callback, required this.groupId});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(10.0),
      color: Colors.white,
      //height: MediaQuery.of(context).size.height * 0.5,
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Upcoming Meetings",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),

            ],
          ),
          MeetingsListWidget(callback: (String groupId,String scheduleId){
            callback(groupId,scheduleId);
          },groupId: groupId,)
        ],
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}

class MeetingsListWidget extends StatelessWidget {
  final String groupId;
  final Function callback;
  MeetingsListWidget({required this.callback, required this.groupId});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GroupOperationsBloc>(context)
        .add(FetchGroupScheduledCallsEvent(groupId: groupId));
    return BlocBuilder<GroupOperationsBloc, GroupOperationsState>(builder: (context, state) {
      if (state is FetchScheduledCallsState) {
        if(state.scheduledCalls.isEmpty)
          return Center(child: Text("No Upcoming meetings"),);
        else {
          return Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.4,
            child: ListView.builder(itemCount: state.scheduledCalls.length,
              itemBuilder: (context, int index) {
                ScheduleNewRequest scheduleNewRequestModel = state
                    .scheduledCalls[index];
                DateTime dateTime = DateTime.parse(
                    scheduleNewRequestModel.callScheduled);
                DateTime endDateTime = dateTime.add(
                    Duration(
                        minutes: scheduleNewRequestModel.duration));
                String date = dateTime.day.toString() +
                    "-" +
                    Constants.months[dateTime.month]! +
                    "-" +
                    dateTime.year.toString();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              callback(scheduleNewRequestModel.groupId,scheduleNewRequestModel.scheduleId);
                            },
                            child: Text(
                              "View Details",
                              style: TextStyle(color: Colors.blue),
                            ))
                      ],
                    )
                  ],
                );
              },
              shrinkWrap: true,),
          );
        }
      }
      if(state is FetchScheduledCallsInProgressState){
        return LoadingShimmerWidget();
      }
      return Container();
    });
  }
}
