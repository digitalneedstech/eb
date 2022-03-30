import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/scheduled_calls_bloc/scheduled_call_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/scheduled_calls_bloc/scheduled_call_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/scheduled_calls_bloc/scheduled_call_state.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';
import 'package:toggle_switch/toggle_switch.dart';

class OverviewScheduledCallWidget extends StatelessWidget{
  final String headerTitle,subTitle;
  final int index;
  OverviewScheduledCallWidget({required this.index,required this.subTitle,required this.headerTitle});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ScheduledCallsDashboardBloc>(context)
        .selectedFiter=3;
    _getDataForContainer(context);
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width*0.8,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(headerTitle,style: TextStyle(color: Colors.grey,fontSize: 14.0),),
          SizedBox(height: 10.0),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(subTitle,style: TextStyle(color: Colors.grey,fontSize: 18.0),)]),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<ScheduledCallsDashboardBloc,ScheduledCallsDashboardState>(
                  builder: (context,state){
                    if (state is AllCallsDashboardMadeState) {
                      if (state.requests==0) return NoDataFound();
                      return Center(child: Text(state.requests.toString()));
                    }
                    return Container();
                  }),
            ],
          ),

          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToggleSwitch(
                totalSwitches: 4,
                inactiveBgColor: Colors.grey.shade200,
                activeBgColor: [Colors.blue],
                initialLabelIndex: BlocProvider.of<ScheduledCallsDashboardBloc>(context).selectedFiter,

                labels: ['Today', 'Week', 'Month','All'],
                onToggle: (index) {
                  BlocProvider.of<ScheduledCallsDashboardBloc>(context).selectedFiter=index;
                  _getDataForContainer(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  _getDataForContainer(BuildContext context){
    BlocProvider.of<ScheduledCallsDashboardBloc>(context).add(
        FetchAllCallsDashboardMadeEvent(
          userType: BlocProvider.of<LoginBloc>(context)
              .userDTOModel.userType,
          fieldTypeToBeSearched: "",
          callStatus: "pending",
            userId: BlocProvider.of<LoginBloc>(context)
                .userDTOModel.userId,
            dateFilter:
            BlocProvider.of<ScheduledCallsDashboardBloc>(context).selectedFiter));
  }
}
