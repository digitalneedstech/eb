import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_event.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_state.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/sub_widgets/video_call/video_call.dart';
import 'package:flutter_eb/shared/utils/camera_util_functions.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:permission_handler/permission_handler.dart';
class ReceiverFreelancerPage extends StatelessWidget{
  final String channelId;

  final String groupId;
  ReceiverFreelancerPage({this.groupId="",required this.channelId});

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ScheduledBloc>(context)
        .add(FetchCallInfoEvent(channelId: channelId,
        userId: getUserDTOModelObject(context).userId));
    return BlocListener<ScheduledBloc,ScheduledState>(
      listener: (context,state)async{
        if(state is CallInfoState){
          if (state.callModel.id!="") {
            PermissionStatus status1=await Permission.camera.request();
            PermissionStatus status2=await Permission.microphone.request();
            try {
              handleInvalidPermissions(status1, status2);
            }catch(e){
              ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                content: Text("There was a server or permissions error"),
                backgroundColor: Colors.red,
              ));
            }
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  VideoCall(groupId: groupId,
                      microPhonePermission: status2,
                      cameraPermission: status1,isForGroup: true,
                      callModel: state.callModel,
                      role: ClientRole.Broadcaster)),
            );
          }
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text("Taking you to call")
            ],
          )
        )
      ),
    );
  }
}
