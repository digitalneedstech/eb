import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/drawer/drawer.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/sub_widgets/switch_widget/switch_widget.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/schedule_detail.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/scheduled_freelance_details.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/scheduled_calls_bloc/scheduled_call_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/scheduled_calls_bloc/scheduled_call_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/scheduled_calls_bloc/scheduled_call_state.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/scheduled_freelancer_image/scheduled_freelancer_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/widgets/animate_list/animate_list.dart';
import 'package:flutter_eb/shared/widgets/loading_shimmer/loading_shimmer.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CallsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LandingDashboardBloc>(context)
        .selectedFiter=0;
    BlocProvider.of<ScheduledCallsDashboardBloc>(context).add(
        FetchScheduledCallsDashboardMadeEvent(
            userType:BlocProvider.of<LoginBloc>(context)
                .userDTOModel.userType,
            userId: BlocProvider.of<LoginBloc>(context)
                .userDTOModel
                .userId,
            isOnlyAcceptedCallsNeeded: true,
            associateName: BlocProvider.of<LandingDashboardBloc>(context)
                .associateNameController
                .text,
            fieldTypeToBeSearched: "Client",
            dateFilter:
            BlocProvider.of<LandingDashboardBloc>(context)
                .selectedFiter));
    return Scaffold(
      drawer: DrawerItems(),
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text("Upcoming Calls"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Group"),
                  EbSwitchWidget((val) {
                    BlocProvider.of<ScheduledCallsDashboardBloc>(context).add(
                        FetchScheduledCallsDashboardMadeEvent(
                            userType:BlocProvider.of<LoginBloc>(context)
                                .userDTOModel.userType,
                            userId: BlocProvider.of<LoginBloc>(context)
                                .userDTOModel
                                .userId,
                            isOnlyAcceptedCallsNeeded: true,
                            associateName: BlocProvider.of<LandingDashboardBloc>(context)
                                .associateNameController
                                .text,
                            fieldTypeToBeSearched: "Client",
                            dateFilter:
                            BlocProvider.of<LandingDashboardBloc>(context)
                                .selectedFiter,
                            callsType: "group"));
                  })
                ],
              ),
            ),
            Expanded(flex:3,child: AnimationLimiter(
              child: BlocBuilder<ScheduledCallsDashboardBloc,
                  ScheduledCallsDashboardState>(builder: (context, state) {
                if (state is ScheduledCallsDashboardMadeState) {
                    if(state.requests.isEmpty){
                      return NoDataFound();
                    }
                    else{
                      return ListView.builder(itemBuilder: (context,int index){
                        ScheduleRequest callModel=state.requests[index];
                        DateTime startDate = DateTime.parse(callModel.callScheduled);
                        String date= startDate.day.toString()+" "+Constants.months[startDate.month]!+" "+startDate.year.toString();
                        DateTime endDateTime = startDate.add(
                            Duration(minutes: callModel.duration));
                        String endDate= endDateTime.day.toString()+" "+Constants.months[endDateTime.month]!+" "+
                            endDateTime.year.toString();
                        return AnimateList(index:index,
                            widget:InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>callModel.userId!=getUserDTOModelObject(context).userId
                                          ? ScheduledFreelanceCallDetailPage(
                                          userId: callModel.userId,scheduleId: callModel.id,)
                                          : ScheduledCallDetailPage(
                                        scheduleId: callModel.id,userId: callModel.freelancerId,
                                      )),
                                );
                              },
                              child: Container(
                          padding: const EdgeInsets.all(20.0),
                          margin: const EdgeInsets.only(bottom: 2.0),
                          decoration: BoxDecoration(
                                color: Colors.white
                          ),
                          child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ScheduledFreelancerImageWidget(
                                        userId: callModel.freelancerId==getUserDTOModelObject(context).userId ? callModel.userId:callModel.freelancerId),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(callModel.userName,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                                        ],
                                      ),
                                    ),
                                    Expanded(child: SizedBox()),
                                    Text(date)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(icon: Icon(Icons.arrow_forward_ios,color: Colors.grey,), onPressed: (){

                                    })
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Time",style: TextStyle(color: Colors.grey),),
                          Text(date +
                                " - " +
                                endDate,style: TextStyle(color: Colors.grey.shade600),)
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Duration",style: TextStyle(color: Colors.grey),),
                                        Text("${callModel.duration} min",style: TextStyle(color: Colors.grey.shade600),)
                                      ],
                                    )
                                  ],
                                )
                              ],
                          ),
                        ),
                            ));
                      },itemCount: state.requests.length,shrinkWrap: true,physics: BouncingScrollPhysics(),);
                    }
                  }
                  return LoadingShimmerWidget();
                }

              ),
            ))
          ],
        ),
      ),
    );
  }
}