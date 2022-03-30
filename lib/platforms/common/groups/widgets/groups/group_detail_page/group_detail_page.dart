import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_state.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/group_detail_page/widgets/chat/group_chat.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/group_detail_page/widgets/group_freelancers_list.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/group_detail_page/widgets/group_freelancers_status.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/group_detail_page/widgets/group_header_info.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/group_detail_page/widgets/group_header_widget.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/group_detail_page/widgets/upcoming_meetings/upcoming_meetings.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_state.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/sub_widgets/video_call/video_call.dart';
import 'package:flutter_eb/shared/constants/routes.dart';
import 'package:flutter_eb/shared/widgets/loading_shimmer/loading_shimmer.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_eb/shared/utils/camera_util_functions.dart';
class GroupDetailPage extends StatelessWidget {
  final String groupId;
  final bool isScheduleEnabled;
  final String scheduleId;
  final bool isOlderMeeting;
  GroupDetailPage({this.groupId="",
    this.scheduleId="",this.isOlderMeeting=false, this.isScheduleEnabled = false});
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GroupBloc>(context)
        .add(FetchGroupByIdEvent(groupId: groupId,userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId));
    return BlocListener<CallBloc,CallState>(
      listener: (context,state)async{
        if (state is GetAgoraAndInitiateAgoraCall) {
          _scaffoldKey.currentState!.removeCurrentSnackBar();
          if (state.callModel.id!="") {
            PermissionStatus status1=await Permission.camera.request();
            PermissionStatus status2=await Permission.microphone.request();
            try {
              handleInvalidPermissions(status1, status2);
            }catch(e){
              _scaffoldKey.currentState!.showSnackBar(new SnackBar(
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
          else
            _scaffoldKey.currentState!.showSnackBar(new SnackBar(
              content: Text("There was a server error"),
              backgroundColor: Colors.red,
            ));
        }
        if (state is GetAgoraCallModelState) {
          if (state.callModel.id!="") {
            PermissionStatus status1=await Permission.camera.request();
            PermissionStatus status2=await Permission.microphone.request();
            try {
              handleInvalidPermissions(status1, status2);
            }catch(e){
              _scaffoldKey.currentState!.showSnackBar(new SnackBar(
                content: Text("There was a server or permissions error"),
                backgroundColor: Colors.red,
              ));
            }
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  VideoCall(groupId: groupId,microPhonePermission: status2,cameraPermission: status1,
                      callModel: state.callModel, role: ClientRole.Audience,isForGroup: true,)),
            );
          }
          else {
            _scaffoldKey.currentState!.showSnackBar(new SnackBar(
              content: Text("Caller hasn't started the call"),
              backgroundColor: Colors.red,
            ));
          }
        }
      },
      child: SafeArea(
        top: true,
        child: Scaffold(
          appBar: AppBar(title: Text("Group Details"),),
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade200,
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
              if (state is FetchGroupByIdState) {
                GroupModel groupModel = state.groupModel;
                List<GroupFreelancerModel> vals=[];
                if(groupModel.groupId!=BlocProvider.of<LoginBloc>(context).userDTOModel.userId) {
                  vals= groupModel.groupMembers.entries.where((e) {
                    return e.key.userId == BlocProvider
                        .of<LoginBloc>(context)
                        .userDTOModel
                        .userId;
                  }).map((e) => e.value).toList();
                }
                return Column(
                  children: [
                    isScheduleEnabled
                        ? GroupHeaderWidget(
                            callback: (bool isCreated, String message) {
                              _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                content: Text(message),
                                backgroundColor:
                                    isCreated ? Colors.green : Colors.red,
                              ));
                             /* Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GroupsTab(message: message,isCreated: isCreated,)));*/
                            },
                            groupModel: groupModel,
                          )
                        : GroupHeaderInfoWidget(
                      isOlderMeeting: isOlderMeeting,
                            groupModel: groupModel,
                            scheduleId: scheduleId,
                            callback: (MaterialColor color, String message,bool ifBackNavigationEnabled) {
                              _scaffoldKey.currentState!.showSnackBar(SnackBar
                                (content:Text(message),backgroundColor: color,));
                              if(ifBackNavigationEnabled)
                                Navigator.pushReplacementNamed(context, Routes.GROUPS);
                            },
                          ),

                    isOlderMeeting ?GroupFreelancersStatus(
                      groupModel: groupModel,
                      scheduleId: scheduleId,
                      callback: (bool flag, String message) =>
                          _scaffoldKey.currentState!.showSnackBar(SnackBar(
                            content: Text(message),
                            backgroundColor: flag ? Colors.green : Colors.red,
                          )),
                    ):GroupFreelancersList(
                      groupModel: groupModel,
                      callback: (bool flag, String message) =>
                          _scaffoldKey.currentState!.showSnackBar(SnackBar(
                        content: Text(message),
                        backgroundColor: flag ? Colors.green : Colors.red,
                      )),
                    ),
                    isScheduleEnabled ?Container():
                    vals.isEmpty || !vals[0].isAccept ? Container(): GroupChatList(callback: (bool isAdded){
                      if(isAdded){
                        _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("Chat Message Sent"),backgroundColor: Colors.green,));
                      }
                      else{
                        _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("Chat Message Could not be Sent"),backgroundColor: Colors.red,));
                      }
                    },groupId: groupId,),
                    groupModel.adminId==BlocProvider.of<LoginBloc>(context).userDTOModel.userId ?
                    GroupChatList(callback: (bool isAdded){
                      if(isAdded){
                        _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("Chat Message Sent"),backgroundColor: Colors.green,));
                      }
                      else{
                        _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("Chat Message Could not be Sent"),backgroundColor: Colors.red,));
                      }
                    },groupId: groupId,):Container(),
                    vals.isEmpty ? Container(): UpcomingMeetingsPage(
                      groupId: groupModel.groupId,
                      callback: (String groupId,String scheduleId) {
    if(kIsWeb){
    Navigator.pushReplacementNamed(context, "group/"+groupId+"/"+scheduleId+"/false/true");
    }else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  GroupDetailPage(
                    groupId: groupId,
                    isScheduleEnabled: false,
                    scheduleId: scheduleId,
                    isOlderMeeting: true,
                  )));
    }
                      },
                    ),
                    groupModel.adminId==BlocProvider.of<LoginBloc>(context).userDTOModel.userId ?
                    UpcomingMeetingsPage(
                      groupId: groupModel.groupId,
                      callback: (String groupId,String scheduleId) {
                        if(kIsWeb){
                          Navigator.pushNamed(context, "group/"+groupId+"/"+scheduleId+"/false/true");
                        }else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      GroupDetailPage(
                                        groupId: groupId,
                                        isScheduleEnabled: false,
                                        scheduleId: scheduleId,
                                        isOlderMeeting: true,
                                      )));
                        }
                      },
                    ):Container()
                  ],
                );
              }
              if(state is LoadingGroupState) {
                return Column(
                  children: [
                    LoadingShimmerWidget(),
                    LoadingShimmerWidget(),
                    LoadingShimmerWidget(),
                  ],
                );
              }
              return Column(
                children: [
                  LoadingShimmerWidget(),
                  LoadingShimmerWidget(),
                  LoadingShimmerWidget(),
                ],
              );
            }),
          )),
        ),
      ),
    );
  }
}
