import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_event.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_state.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_state.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/platforms/common/schedule/schedule.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/sub_widgets/video_call/video_call.dart';
import 'package:flutter_eb/shared/utils/schedule_call_functions.dart';
import 'package:flutter_eb/shared/widgets/eb_circle_avatar/eb_circle_avatar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_eb/shared/utils/camera_util_functions.dart';

class ScheduleCall extends StatefulWidget {
  final CallModel callModel;
  final String buttonTitle;
  ScheduleCall({required this.callModel, this.buttonTitle = "Schedule"});
  ScheduleCallState createState() => ScheduleCallState();
}

class ScheduleCallState extends State<ScheduleCall> {
  TextEditingController _durationController = new TextEditingController(text: "15");
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Widget build(BuildContext context) {
    BlocProvider.of<LoginBloc>(context)
        .add(GetUserByIdEvent(userId: widget.callModel.receiverId[0]));
    return BlocListener<CallBloc, CallState>(
      listener: (context, state) async {
        if (state is GetAgoraAndInitiateAgoraCall) {
          if (state.callModel.id != "") {
            PermissionStatus status1 = await Permission.camera.request();
            PermissionStatus status2 = await Permission.microphone.request();
            try {
              handleInvalidPermissions(status1, status2);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("There was a server or permissions error"),
                backgroundColor: Colors.red,
              ));
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoCall(
                      callModel: state.callModel,
                      cameraPermission: status1,
                      microPhonePermission: status2,
                      isForGroup: false,
                      role: ClientRole.Broadcaster)),
            );
          } else
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("There was a server error"),
              backgroundColor: Colors.red,
            ));
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Schedule Call"),
        ),
        backgroundColor: Colors.grey.shade200,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BlocBuilder<LoginBloc, LoginState>(
                              builder: (context, state) {
                            if (state is GetUserByIdState) {
                              return state.userDTOModel.userId == ""
                                  ? EbCircleAvatarWidget()
                                  : EbCircleAvatarWidget(
                                      profileImageUrl: state.userDTOModel
                                          .personalDetails.profilePic);
                            }
                            return EbCircleAvatarWidget();
                          })
                        ],
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.callModel.receiverName,
                              style: TextStyle(
                                color: Color(0xFF1787E0),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text("Title")
                          ])
                    ]),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      //height: MediaQuery.of(context).size.height*0.4,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text("Rate")),
                              SizedBox(
                                height: 10.0,
                              ),
                              RichText(
                                  text: TextSpan(
                                      text:
                                          "\$ ${calculateRate(int.parse(_durationController.text),
                                              widget.callModel.acceptedPrice.toDouble())}",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                      children: <TextSpan>[
                                    TextSpan(
                                        text: " /hr",
                                        style: TextStyle(
                                            color: Colors.grey.shade500))
                                  ]))
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Duration"),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child:
                                    ScheduleDropDownField(callback: (int val) {
                                      setState((){
                                        _durationController.text = val.toString();
                                      });

                                }),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlineButton(
                              onPressed: () => Navigator.pop(context),
                              child: Center(
                                child: Text("Cancel"),
                              )),
                          SizedBox(
                            width: 10.0,
                          ),
                          ScheduleButton(
                            duration:_durationController.text,
                              title: widget.buttonTitle,
                              errorCallback: (val) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(val),
                                  backgroundColor: Colors.red,
                                ));
                              },
                              callModel: widget.callModel)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleButton extends StatefulWidget {
  final String duration;
  final Function errorCallback;
  final CallModel callModel;
  final String title;

  ScheduleButton(
      {required this.title,
      this.duration = "",
      required this.errorCallback,
      required this.callModel});
  ScheduleButtonState createState() => ScheduleButtonState();
}

class ScheduleButtonState extends State<ScheduleButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: _isLoading
          ? null
          : () async {
              if (widget.duration == "") {
                widget.errorCallback("Please Fill In Duration");
              } else {
                widget.callModel.duration = int.parse(widget.duration);
                await Permission.camera.request();
                await Permission.microphone.request();
                UserDTOModel userDTOModel =
                    BlocProvider.of<LoginBloc>(context).userDTOModel;
                setState(() {
                  _isLoading = true;
                });
                switch (userDTOModel.planType) {
                  case "pro":
                  case "Pro":
                    walletCalculationBeforeStartingCallForInstantCall(
                        context, 0, widget.callModel);
                    break;
                  case "enterprise":
                  case "Enterprise":
                    walletCalculationBeforeStartingCallForInstantCall(
                        context, 1, widget.callModel);
                    break;
                  default:
                    walletCalculationBeforeStartingCallForInstantCall(
                        context, 2, widget.callModel);
                    break;
                }
              }
            },
      child: Center(
        child: Text(widget.title),
      ),
      color: Colors.blue,
      textColor: Colors.white,
    );
  }
}

class BidTextField extends StatefulWidget {
  Function callback;
  BidTextField({required this.callback});
  BidTextFieldState createState() => BidTextFieldState();
}

class BidTextFieldState extends State<BidTextField> {
  String bidValue = "";
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.40,
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        initialValue: bidValue,
        onChanged: (String val) {
          setState(() {
            bidValue = val;
            widget.callback(bidValue);
          });
        },
        decoration: InputDecoration(
          hintText: "Enter Value",
          enabledBorder: OutlineInputBorder(
            gapPadding: 0.0,
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }
}
