import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/calls_bloc/calls_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/calls_bloc/calls_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/calls_bloc/calls_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';
import 'package:toggle_switch/toggle_switch.dart';

class OverviewUpcomingCallWidget extends StatelessWidget{
  final String headerTitle,subTitle;
  final int index;
  final bool isFreelancer;
  OverviewUpcomingCallWidget({required this.isFreelancer,required this.index,required this.subTitle,required this.headerTitle});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CallsDashboardBloc>(context)
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
              BlocBuilder<CallsDashboardBloc,CallsDashboardState>(
                  builder: (context,state){
                    if (state is CallsMadeState) {
                      if (state.requests.isEmpty)
                        return NoDataFound();
                      else {
                        List<CallModel> calls = isFreelancer
                            ? List.from(state.requests
                            .where((e) =>
                        e.userId !=
                            BlocProvider
                                .of<LoginBloc>(context)
                                .userDTOModel
                                .userId)
                            .toList())
                            : List.from(state.requests
                            .where((e) =>
                        e.userId ==
                            BlocProvider
                                .of<LoginBloc>(context)
                                .userDTOModel
                                .userId)
                            .toList());
                        if (calls.isEmpty) return NoDataFound();
                        return Center(
                            child: Text(calls.length.toString()));
                      }
                    }
                    else
                      return Center(child: Text("Loading"));
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
                initialLabelIndex: BlocProvider.of<CallsDashboardBloc>(context).selectedFiter,

                labels: ['Today', 'Week', 'Month','All'],
                onToggle: (index) {
                  BlocProvider.of<CallsDashboardBloc>(context).selectedFiter=index;
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
    BlocProvider.of<CallsDashboardBloc>(context).add(FetchUpcomingCallsMadeEvent(
      userType: BlocProvider.of<LoginBloc>(context)
          .userDTOModel.userType,
        fieldTypeToBeSearched: "",
        userId: BlocProvider.of<LoginBloc>(context)
            .userDTOModel
            .userId,
        dateFilter:
        BlocProvider.of<CallsDashboardBloc>(context).selectedFiter));
  }
}