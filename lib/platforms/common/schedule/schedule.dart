import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_state.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_event.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_state.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/schedule_popup.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/scheduled_freelancer_image/scheduled_freelancer_image.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/utils/schedule_call_functions.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
class SchedulePage extends StatefulWidget {
  final BidModel bidModel;
  final String scheduleId;
  final String status;
  SchedulePage({required this.bidModel,this.scheduleId="", this.status = "Pending"});
  SchedulePageState createState() => SchedulePageState();
}

class SchedulePageState extends State<SchedulePage> {
  TextEditingController _durationController = new TextEditingController(text: "15");
  DateTime selectedDate=DateTime.now();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  ScheduleRequest _createBidMainModel(ScheduleRequest scheduleRequest) {
    if (scheduleRequest.id == "") {
      scheduleRequest=new ScheduleRequest();
      scheduleRequest.userName=widget.bidModel.profileName;
      scheduleRequest.status = widget.status;
      scheduleRequest.userId = widget.bidModel.userId;
      scheduleRequest.askedRate = calculateRate(int.parse(_durationController.text),
          widget.bidModel.acceptedRate.toDouble());
      scheduleRequest.freelancerId = widget.bidModel.freelancerId;
      scheduleRequest.freelancerName=widget.bidModel.clientName;
      scheduleRequest.duration = int.parse(_durationController.text);
      scheduleRequest.callScheduled = selectedDate.toUtc().toIso8601String();
    }
    else{
      scheduleRequest.duration = int.parse(_durationController.text);
      scheduleRequest.callScheduled=selectedDate.toUtc().toIso8601String();
      scheduleRequest.status=widget.status;
    }
    scheduleRequest.isBidCreated=true;
    return scheduleRequest;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.scheduleId != "") {
      BlocProvider.of<ScheduledBloc>(context)
          .add(FetchScheduledCallInfoEvent(
        userId: getUserDTOModelObject(context).userId,
          scheduledId: widget.scheduleId));
    }
    BlocProvider.of<ScheduledBloc>(context)
        .add(UpdateDurationInCreatingScheduledCallEvent(duration: 0));
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text("Schedule Call"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //height: MediaQuery.of(context).size.height * 0.40,
              margin: const EdgeInsets.all(20.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(10.0),
                // border: Border.all(color: Colors.grey.shade500,width: 1.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Schedule your call with:"),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ScheduledFreelancerImageWidget(userId: widget.bidModel.freelancerId)
                      ],
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.bidModel.clientName,
                            style: TextStyle(
                              color: Color(0xFF1787E0),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          BlocBuilder<LoginBloc,LoginState>(
                            builder: (context,state){
                              if(state is GetUserByIdState){
                                return Text(state.userDTOModel.profileOverview.profileTitle==""?
                                Constants.UNTITLED:state.userDTOModel.profileOverview.profileTitle);
                              }
                              return Text("Title");
                            },
                          )

                        ])
                  ]),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Rate"),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(child: Text("Duration")),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "\$ ${calculateRate(int.parse(_durationController.text),
                                  double.parse(widget.bidModel.acceptedRate.toString()))}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              children: <TextSpan>[
                            TextSpan(
                                text: " /hr",
                                style: TextStyle(color: Colors.grey.shade500))
                          ])),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: ScheduleDropDownField(callback: (int val) {
                          setState(() {
                            _durationController.text = val.toString();
                          });
                        }),
                      )
                    ],
                  ),
                  BlocBuilder<ScheduledBloc, ScheduledState>(
                    builder: (context, state) {
                      if (state is ScheduledInfoState) {
                        return RaisedButton(
                          onPressed: () {
                            ScheduleRequest request=_createBidMainModel(state.scheduleModel);
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SchedulePopUp(scheduleRequest: request);
                                  },
                                  barrierDismissible: false);

                          },
                          child: Center(
                            child: Text("Schedule"),
                          ),
                          color: Color(0xFF067EED),
                          textColor: Colors.white,
                        );
                      } else
                        return RaisedButton(
                          onPressed: () {
                            ScheduleRequest request=ScheduleRequest();
                              request=_createBidMainModel(request);
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SchedulePopUp(scheduleRequest: request,);
                                  },
                                  barrierDismissible: false);

                          },
                          child: Center(
                            child: Text("Schedule"),
                          ),
                          color: Color(0xFF067EED),
                          textColor: Colors.white,
                        );
                    },
                  )
                ],
              ),
            ),
            /*Container(
              margin: const EdgeInsets.all(20.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(10.0),
                // border: Border.all(color: Colors.grey.shade500,width: 1.0),
              ),
              child: RaisedButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ScheduleCalender(callback: (DateTime day) {
                          setState(() {
                            date = day;
                          });
                          Navigator.pop(context);
                        });
                      });
                },
                child: Center(
                  child: Text("Select Date"),
                ),
                color: Color(0xFF067EED),
                textColor: Colors.white,
              ),
            ),*/
            Container(
              margin: const EdgeInsets.all(20.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(10.0),
                // border: Border.all(color: Colors.grey.shade500,width: 1.0),
              ),
              child: RaisedButton(
                onPressed: () async {
                  DatePicker.showDateTimePicker(context, showTitleActions: true,
                      onChanged: (date) {
                    print('change $date in time zone ' +
                        date.timeZoneOffset.inHours.toString());
                  }, onConfirm: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                    print('confirm $date');
                  }, currentTime: DateTime.now());
                },
                child: Center(
                  child: Text(selectedDate.toIso8601String().split("T")[0]
                  +" "+(selectedDate.toIso8601String().split("T")[1]).split(".")[0]),
                ),
                color: Color(0xFF067EED),
                textColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ScheduleDropDownField extends StatefulWidget {
  Function callback;
  ScheduleDropDownField({required this.callback});
  ScheduleDropDownFieldState createState() => ScheduleDropDownFieldState();
}

class ScheduleDropDownFieldState extends State<ScheduleDropDownField> {
  Map<int,String> durationValues={
    15:"15 Minutes",30:"30 Minutes",45:"45 Minutes"
  };
  int selectedVal=15;
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.40,
      padding: const EdgeInsets.all(10.0),
      child: DropdownButtonFormField(
        items: durationValues.entries.map((entry){
          return DropdownMenuItem(child: Text(entry.value),value: entry.key,);
        }).toList(),
        value: selectedVal,
        onChanged: (int? val){
          setState(() {
            selectedVal=val!;
            widget.callback(selectedVal);
          });
        },
      )
    );
  }
}
