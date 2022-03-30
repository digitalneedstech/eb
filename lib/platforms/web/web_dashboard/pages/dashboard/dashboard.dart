import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/bids_bloc/bids_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/scheduled_calls_bloc/scheduled_call_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/scheduled_calls_bloc/scheduled_call_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/scheduled_calls_bloc/scheduled_call_state.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/bids_bloc/bids_event.dart' as bidState;
class WebDashboardPage extends StatefulWidget {
  final bool isFreelancer;
  final int selectedIndex;
  WebDashboardPage({this.isFreelancer=false,this.selectedIndex=0});

  WebDashboardPageState createState()=>WebDashboardPageState();
}
class WebDashboardPageState extends State<WebDashboardPage> {

  initialExecution(BuildContext context){
    BlocProvider.of<LandingDashboardBloc>(context)
        .selectedFiter=3;
    BlocProvider.of<ScheduledCallsDashboardBloc>(context).add(
        FetchScheduledCallsDashboardMadeEvent(
            userId: getUserDTOModelObject(context).userId,
            userType: BlocProvider.of<LoginBloc>(context)
                .userProfileType,
            associateName: BlocProvider.of<LandingDashboardBloc>(context)
                .associateNameController
                .text,
            fieldTypeToBeSearched: widget.isFreelancer ? "Client" : "Freelancer",
            dateFilter:
            3));

    BlocProvider.of<ScheduledCallsDashboardBloc>(context).add(
        FetchScheduledCallsDashboardMadeEvent(
            userId: BlocProvider.of<LoginBloc>(context)
                .userDTOModel.userId,
            userType: BlocProvider.of<LoginBloc>(context)
                .userProfileType,
            associateName: BlocProvider.of<LandingDashboardBloc>(context)
                .associateNameController
                .text,
            fieldTypeToBeSearched: widget.isFreelancer ? "Client" : "Freelancer",
            dateFilter:
            3));

    BlocProvider.of<BidsDashboardBloc>(context).add(bidState.FetchBidsMadeEvent(
        userId: BlocProvider.of<LoginBloc>(context)
            .userDTOModel.userId,
        userType: BlocProvider.of<LoginBloc>(context)
            .userProfileType,
        associateName: BlocProvider.of<LandingDashboardBloc>(context)
            .associateNameController
            .text,
        fieldTypeToBeSearched: widget.isFreelancer ? "Client" : "Freelancer",
        dateFilter:
        BlocProvider.of<LandingDashboardBloc>(context)
            .selectedFiter));

  }
  @override
  Widget build(BuildContext context) {
    initialExecution(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            CountWidget("Accepted Calls", 0, (){

            },false),
            CountWidget("Scheduled Calls", 1, (){

            },widget.isFreelancer),
            CountWidget("Bid Received", 2, (){

            },widget.isFreelancer)
          ],
        ),
        Expanded(
            child: ListInfoWidget(widget.selectedIndex,widget.isFreelancer))
      ],
    );
  }
}

class ListInfoWidget extends StatelessWidget{
  final int index;
  final bool isFreelancer;
  ListInfoWidget(this.index,this.isFreelancer);
  @override
  Widget build(BuildContext context) {
    switch(index){
      case 0:
      case 1:
        return ScheduledCallsListWidget(isFreelancer);
      default:
        return BidReceivedListWidget(isFreelancer);
    }
  }
}

class CountWidget extends StatelessWidget{
  int index;
  String header;
  Function callback;
  bool isFreelancer;
  CountWidget(this.header,this.index,this.callback,this.isFreelancer);
  @override
  Widget build(BuildContext context) {
    if(index==1){
      return ScheduledCallsWidget(isFreelancer,header);
    }
    else if(index==2){
      return BidReceivedWidget(isFreelancer, header);
    }
    else
      return Container(
      width: MediaQuery.of(context).size.width * 0.1,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey, width: 2.0)),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                header,
                style: TextStyle(color: Colors.grey, fontSize: 12.0),
              ),
            ),
            Text(
              "7",
              style: TextStyle(color: Colors.black, fontSize: 18.0),
            )
          ],
        ),
      ),
    );
  }
}
class ScheduledCallsWidget extends StatelessWidget{
  bool isFreelancer;
  String header;
  ScheduledCallsWidget(this.isFreelancer,this.header);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduledCallsDashboardBloc,
        ScheduledCallsDashboardState>(builder: (context, state) {
      if (state is ScheduledCallsDashboardMadeState) {
        if (state.requests.isEmpty)
          return NoDataFound();
        else {
          List<ScheduleRequest> calls = [];
          if (BlocProvider
              .of<LoginBloc>(context)
              .userProfileType != Constants.CUSTOMER) {
            calls = isFreelancer
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
          }
          else
            calls = state.requests;
          if (calls.isEmpty) return NoDataFound();
          return Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.1,
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey, width: 2.0)),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    header,
                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                  Text(
                    calls.length.toString(),
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                  )
                ],
              ),
            ),
          );
        }
      }
      return Container();
    });
  }
}

class ScheduledCallsListWidget extends StatelessWidget{
  bool isFreelancer;
  ScheduledCallsListWidget(this.isFreelancer);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduledCallsDashboardBloc,
        ScheduledCallsDashboardState>(builder: (context, state) {
      if (state is ScheduledCallsDashboardMadeState) {
        if (state.requests.isEmpty)
          return NoDataFound();
        else {
          List<ScheduleRequest> calls = [];
          if (BlocProvider
              .of<LoginBloc>(context)
              .userProfileType != Constants.CUSTOMER) {
            calls = isFreelancer
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
          }
          else
            calls = state.requests;
          if (calls.isEmpty) return NoDataFound();
          return ListView(children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Sr.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                      child: Text(
                        "Johnson",
                        style: TextStyle(color: Colors.white),
                      )),
                  Expanded(
                      child: Text(
                        "1200/hr",
                        style: TextStyle(color: Colors.white),
                      )),
                  Expanded(
                      child: Text(
                        "1200/hr",
                        style: TextStyle(color: Colors.white),
                      )),
                  Expanded(
                      child: Text(
                        "Accepted",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
            ListView.separated(
              itemBuilder: (context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("1"),
                    ),
                    Expanded(child: Text("Johnson")),
                    Expanded(child: Text("1200/hr")),
                    Expanded(child: Text("1200/hr")),
                    Expanded(child: Text("Accepted"))
                  ],
                );
              },
              separatorBuilder: (context, int index) {
                return Divider(color: Colors.grey);
              },
              itemCount: 10,
              shrinkWrap: true,
            )
          ]);
        }
      }
      return Container();
    });
  }
}

class BidReceivedWidget extends StatelessWidget{
  bool isFreelancer;
  String header;
  BidReceivedWidget(this.isFreelancer,this.header);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduledCallsDashboardBloc,
        ScheduledCallsDashboardState>(builder: (context, state) {
      if (state is ScheduledCallsDashboardMadeState) {
        if (state.requests.isEmpty)
          return NoDataFound();
        else {
          List<ScheduleRequest> calls = [];
          if (BlocProvider
              .of<LoginBloc>(context)
              .userProfileType != Constants.CUSTOMER) {
            calls = isFreelancer
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
          }
          else
            calls = state.requests;
          if (calls.isEmpty) return NoDataFound();
          return Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.1,
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey, width: 2.0)),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    header,
                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                  Text(
                    "${calls.length}",
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                  )
                ],
              ),
            ),
          );
        }
      }
      return Container();
    });
  }
}


class BidReceivedListWidget extends StatelessWidget{
  bool isFreelancer;
  BidReceivedListWidget(this.isFreelancer);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduledCallsDashboardBloc,
        ScheduledCallsDashboardState>(builder: (context, state) {
      if (state is ScheduledCallsDashboardMadeState) {
        if (state.requests.isEmpty)
          return NoDataFound();
        else {
          List<ScheduleRequest> calls = [];
          if (BlocProvider
              .of<LoginBloc>(context)
              .userProfileType != Constants.CUSTOMER) {
            calls = isFreelancer
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
          }
          else
            calls = state.requests;
          if (calls.isEmpty) return NoDataFound();
          return ListView(children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Sr.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                      child: Text(
                        "Johnson",
                        style: TextStyle(color: Colors.white),
                      )),
                  Expanded(
                      child: Text(
                        "1200/hr",
                        style: TextStyle(color: Colors.white),
                      )),
                  Expanded(
                      child: Text(
                        "1200/hr",
                        style: TextStyle(color: Colors.white),
                      )),
                  Expanded(
                      child: Text(
                        "Accepted",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
            ListView.separated(
              itemBuilder: (context, int index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("1"),
                    ),
                    Expanded(child: Text("Johnson")),
                    Expanded(child: Text("1200/hr")),
                    Expanded(child: Text("1200/hr")),
                    Expanded(child: Text("Accepted"))
                  ],
                );
              },
              separatorBuilder: (context, int index) {
                return Divider(color: Colors.grey);
              },
              itemCount: 10,
              shrinkWrap: true,
            )
          ]);
        }
      }
      return Container();
    });
  }
}