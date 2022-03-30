import 'package:flutter_eb/shared/utils/camera_util_functions.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_state.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/sub_widgets/video_call/video_call.dart';
import 'package:flutter_eb/shared/utils/schedule_call_functions.dart';
import 'package:permission_handler/permission_handler.dart';

class ScheduleButton extends StatelessWidget {
  final ScheduleRequest scheduleRequest;
  final Function callback;
  ScheduleButton({required this.scheduleRequest,required this.callback});
  @override
  Widget build(BuildContext context) {
    DateTime date=DateTime.parse(scheduleRequest.callScheduled).add(Duration(minutes: scheduleRequest.duration));

    return BlocListener<CallBloc, CallState>(
        listener: (context, state)async {
          if (state is GetAgoraAndInitiateAgoraCall) {
            if (state.callModel != null) {
              PermissionStatus status1=await Permission.camera.request();
              PermissionStatus status2=await Permission.microphone.request();
              try {
                handleInvalidPermissions(status1, status2);
              }catch(e){
callback();
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VideoCall(microPhonePermission: status2,cameraPermission: status1,
                            callModel: state.callModel,isForGroup: false,
                            role: ClientRole.Broadcaster)),
              );
            }
            else
              callback();
          }
        },
        child: BlocBuilder<CallBloc,CallState>(
          builder: (context,state) {
            if(state is LoadingInitiateState){
              return RaisedButton(
                onPressed:null,
                child: Text("Loading"),
                color: Color(0xFF067EED),
                textColor: Colors.white,
                disabledTextColor: Colors.white,
              );
            }
            return RaisedButton(
              onPressed:() async {
                await Permission.camera.request();
                await Permission.microphone.request();
                UserDTOModel userDTOModel =
                    BlocProvider
                        .of<LoginBloc>(context)
                        .userDTOModel;
                switch (userDTOModel.planType) {
                  case "pro":
                  case "Pro":
                    walletCalculationBeforeStartingCallForSingleFreelancer(
                        context, 0, scheduleRequest);
                    break;
                  case "enterprise":
                  case "Enterprise":
                    walletCalculationBeforeStartingCallForSingleFreelancer(
                        context, 1, scheduleRequest);
                    break;
                  default:
                    walletCalculationBeforeStartingCallForSingleFreelancer(
                        context, 2, scheduleRequest);
                    break;
                }
              },
              child: Text("Start Call"),
              color: Color(0xFF067EED),
              textColor: Colors.white,
              disabledTextColor: Colors.white,
            );
          }
        ));
  }


}
