import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/filter/filter.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ContainerWidget extends StatelessWidget{
  final String headerTitle,subTitle;
  final int index;
  ContainerWidget({required this.index,required this.subTitle,required this.headerTitle});
  @override
  Widget build(BuildContext context) {
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
                  BlocBuilder<LandingDashboardBloc,LandingDashboardState>(
                     builder: (context,state){
                       if(state is CallsMadeState){
                         List<ScheduleRequest> requests=List.from(state.requests
                             .where((element){
                               switch(index){
                                 case 0:
                                   return (element.status=="Accepted" || element.status=="accepted") && DateTime.parse(element.callScheduled).isAfter(DateTime.now());
                                 case 2:
                                   return (element.status=="Accepted" ||element.status=="accepted") && DateTime.parse(element.callScheduled).isBefore(DateTime.now());
                                 default:
                                   return (element.status=="Pending"  || element.status=="pending") && DateTime.parse(element.callScheduled).isAfter(DateTime.now());
                               }
                         }));

                         return Text(requests.length.toString(),style: TextStyle(color: Colors.black,fontSize: 16.0),);
                       }
                       else if(state is BidsMadeState){
                         return Center(child: Text(state.bidModels.length.toString()));
                       }
                       else{
                         return Container();
                       }
                     }),
                ],
              ),

          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToggleSwitch(
                totalSwitches: 3,
                inactiveBgColor: Colors.grey.shade200,
                activeBgColor: [Colors.blue],
                initialLabelIndex: 0,

                labels: ['Today', 'Week', 'Month'],
                onToggle: (index) {
                  BlocProvider.of<LandingDashboardBloc>(context).selectedFiter=index;
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
    switch(index){
      case 1:
      case 3:
      case 4:
        BlocProvider.of<LandingDashboardBloc>(context)
            .add(FetchCallsMadeEvent(
            fieldTypeToBeSearched: "",
            dateFilter: BlocProvider.of<LandingDashboardBloc>(context).selectedFiter,userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId));
        break;
      case 2:
        BlocProvider.of<LandingDashboardBloc>(context).add(FetchBidsMadeEvent(
            fieldTypeToBeSearched: "",
            dateFilter: BlocProvider.of<LandingDashboardBloc>(context).selectedFiter,userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId));
        break;
    }
  }
}