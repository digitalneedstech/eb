import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_event.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_state.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/sub_widgets/video_call/video_call.dart';
import 'package:flutter_eb/shared/utils/schedule_call_functions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_eb/shared/utils/camera_util_functions.dart';
class CallNowButton extends StatelessWidget {
  final ScheduleRequest scheduleRequest;
  final Function callback;
  CallNowButton({required this.scheduleRequest,required  this.callback});
  @override
  Widget build(BuildContext context) {
    return BlocListener<CallBloc, CallState>(
      listener: (context, state) async {
        if (state is GetAgoraCallModelState) {
          if (state.callModel.id != "") {
            PermissionStatus status1 = await Permission.camera.request();
            PermissionStatus status2 = await Permission.microphone.request();
            try {
              handleInvalidPermissions(status1, status2);
            } catch (e) {
              callback();
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoCall(
                      cameraPermission: status1,
                      microPhonePermission: status1,
                      isForGroup: false,
                      callModel: state.callModel,
                      role: ClientRole.Audience)),
            );
          } else
            callback();
        }
      },
      child: BlocBuilder<CallBloc, CallState>(
        builder: (context, state) {
          return RaisedButton(
            onPressed: state is LoadingInitiateState
                ? null
                : () {
                    BlocProvider.of<CallBloc>(context).add(
                        GetAgoraCallModel(scheduleRequest: scheduleRequest,userId: "",groupId: ""));
                  },
            child: Center(
              child: state is LoadingInitiateState
                  ? Text("Loading")
                  : Text("Join"),
            ),
            disabledTextColor: Colors.white,
            color: Color(0xFF067EED),
            textColor: Colors.white,
          );
        },
      ),
    );
  }
}
