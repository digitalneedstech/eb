import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/bids_bloc/bids_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/bids_bloc/bids_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/bids_bloc/bids_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';
import 'package:toggle_switch/toggle_switch.dart';

class OverviewBidWidget extends StatelessWidget{
  final String headerTitle,subTitle;
  final int index;
  final bool isFreelancer;
  OverviewBidWidget({required this.isFreelancer,required this.index,required this.subTitle,required this.headerTitle});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<BidsDashboardBloc>(context)
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
              BlocBuilder<BidsDashboardBloc,BidsDashboardState>(
                  builder: (context,state){
                    if (state is FetchBidsMadeState) {
                      if (state.bidModels.isEmpty) return NoDataFound();
                      List<BidModel> bids = isFreelancer
                          ? List.from(state.bidModels.where((e) =>
                      e.userId !=
                              BlocProvider.of<LoginBloc>(context)
                                  .userDTOModel
                                  .userId))
                          : List.from(state.bidModels.where((e) =>
                      e.userId ==
                              BlocProvider.of<LoginBloc>(context)
                                  .userDTOModel
                                  .userId));
                      if (bids.isEmpty) return NoDataFound();
                      return Center(child: Text(bids.length.toString()));
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
                totalSwitches: 4,
                inactiveBgColor: Colors.grey.shade200,
                activeBgColor: [Colors.blue],
                initialLabelIndex: BlocProvider.of<BidsDashboardBloc>(context)
                    .selectedFiter,

                labels: ['Today', 'Week', 'Month','ALL'],
                onToggle: (index) {
                  BlocProvider.of<BidsDashboardBloc>(context)
                      .selectedFiter=index;
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
    BlocProvider.of<BidsDashboardBloc>(context).add(FetchBidsMadeEvent(
      fieldTypeToBeSearched: "",
        userType: BlocProvider.of<LoginBloc>(context)
            .userDTOModel.userType,
        userId: BlocProvider.of<LoginBloc>(context)
            .userDTOModel.userId,
        dateFilter:
        BlocProvider.of<BidsDashboardBloc>(context)
            .selectedFiter));
  }
}