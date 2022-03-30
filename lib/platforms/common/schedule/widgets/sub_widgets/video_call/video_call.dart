import 'dart:async';
import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter_eb/app/my_app.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_agora_callback.dart';
import 'package:flutter_eb/platforms/common/ratings/bloc/ratings_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/sub_widgets/video_call/widgets/video_call_rating/video_call_rating.dart';
import 'package:permission_handler/permission_handler.dart';
import 'widgets/rating_widget.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/ratings/model/rating_model.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_event.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/shared/widgets/eb_outline_button_widget/eb_outline_button_widget.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';

class VideoCall extends StatefulWidget {
  final CallModel callModel;
  final ClientRole role;
  final PermissionStatus cameraPermission, microPhonePermission;
  final String groupId;
  final bool isForGroup;
  final String callType;
  const VideoCall(
      {this.callType = "video",
      this.groupId = "",
      this.cameraPermission = PermissionStatus.granted,
      this.microPhonePermission = PermissionStatus.granted,
      this.isForGroup = false,
      required this.callModel,
      required this.role});

  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  List<int> _users = [];
  late int _remoteUserId;
  int _myUId = 0;
  final _infoStrings = <String>[];
  bool muted = false;
  late RtcEngine _engine;
  TextEditingController _descriptionController =
      new TextEditingController(text: "");
  double ratingVal = 0.0;
  DateTime startTime=DateTime.now();
  late DateTime endTime;
  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    _engine = await RtcEngine.createWithContext(
        RtcEngineContext("e9dd9ce80c0f4bacb49b1e2affb74c88"));
    this._addAgoraEventHandlers();
    if (widget.cameraPermission.isGranted) {
      if (widget.callType == "video") {
        await _engine.enableVideo();
        //VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
        //configuration.dimensions = VideoDimensions(width:1920, height: 1080);
        //await _engine.setVideoEncoderConfiguration(configuration);
      }
    }
    await _engine.enableWebSdkInteroperability(true);
    bool isEnabled = (await _engine.isSpeakerphoneEnabled())!;
    await _engine.setEnableSpeakerphone(isEnabled);
    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.Communication);
    //await _engine.setClientRole(ClientRole.Broadcaster);
    //await _engine.enableLocalAudio(true);
    await _engine.joinChannel(widget.callModel.token, widget.callModel.channel,
        null, widget.callModel.userUid);
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) async {
      if (code == ErrorCode.InvalidToken) {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Invalid Token"),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Center(
                    child: Text("Video token is Invalid"),
                  ),
                ),
                actions: [
                  EbOutlineButtonWidget(
                      buttonText: "Ok",
                      callback: () {
                        Navigator.pop(context, true);
                      })
                ],
              );
            },
            barrierDismissible: false);
        _engine.leaveChannel();
      } else if (code == ErrorCode.TokenExpired) {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Token Expired"),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Center(
                    child: Text("Video token is Invalid"),
                  ),
                ),
                actions: [
                  EbOutlineButtonWidget(
                      buttonText: "Ok",
                      callback: () {
                        Navigator.pop(context, true);
                      })
                ],
              );
            },
            barrierDismissible: false);
        _engine.leaveChannel();
      }
    }, rejoinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        startTime = DateTime.now();
      });
      if (widget.role == ClientRole.Audience) {
        BlocProvider.of<CallBloc>(context).add(LogUserVideoCallingTime(
            groupId: widget.groupId,
            uId: uid,
            userId: getUserDTOModelObject(context).userId,
            isForGroup: widget.groupId == "" ? false : true,
            callModel: widget.callModel,
            dateTime: DateTime.now().toIso8601String(),
            isUser: false,
            typeOfLogging: "start"));
      } else {
        BlocProvider.of<CallBloc>(context).add(LogUserVideoCallingTime(
            uId: uid,
            isForGroup: widget.groupId == "" ? false : true,
            groupId: widget.groupId,
            userId: getUserDTOModelObject(context).userId,
            callModel: widget.callModel,
            dateTime: DateTime.now().toIso8601String(),
            isUser: true,
            typeOfLogging: "start"));
      }
      if (widget.groupId != "") {
        BlocProvider.of<CallBloc>(context)
            .scheduleRepository
            .getUsersAlreadyInCall(widget.groupId, widget.callModel)
            .then((value) {
          setState(() {
            _myUId = uid;
            _users = value;
          });
        });
      }
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        startTime = DateTime.now();
      });
      if (widget.role == ClientRole.Audience) {
        BlocProvider.of<CallBloc>(context).add(LogUserVideoCallingTime(
            groupId: widget.groupId,
            uId: uid,
            userId: getUserDTOModelObject(context).userId,
            isForGroup: widget.groupId == "" ? false : true,
            callModel: widget.callModel,
            dateTime: DateTime.now().toIso8601String(),
            isUser: false,
            typeOfLogging: "start"));
      } else {
        BlocProvider.of<CallBloc>(context).add(LogUserVideoCallingTime(
            uId: uid,
            isForGroup: widget.groupId == "" ? false : true,
            groupId: widget.groupId,
            userId: getUserDTOModelObject(context).userId,
            callModel: widget.callModel,
            dateTime: DateTime.now().toIso8601String(),
            isUser: true,
            typeOfLogging: "start"));
      }
      if (widget.groupId != "") {
        BlocProvider.of<CallBloc>(context)
            .scheduleRepository
            .getUsersAlreadyInCall(widget.groupId, widget.callModel)
            .then((value) {
          setState(() {
            _myUId = uid;
            _users = value;
          });
        });
      }
    }, tokenPrivilegeWillExpire: (String val) async {
      bool isRenewable = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Token Expiring"),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Center(
                  child: Text("Video token is expiring"),
                ),
              ),
              actions: [
                EbOutlineButtonWidget(
                    buttonText: "Ok",
                    callback: () {
                      Navigator.pop(context, false);
                    }),
                EbOutlineButtonWidget(
                    buttonText: "Renew",
                    callback: () {
                      Navigator.pop(context, true);
                    })
              ],
            );
          });
      if (isRenewable)
        _engine.renewToken(widget.callModel.token);
      else
        _engine.leaveChannel();
    }, leaveChannel: (stats) {
      setState(() {
        endTime = DateTime.now();
      });
      CallAgoraCallBack callAgoraCallBack = new CallAgoraCallBack(
          stats.duration, startTime, endTime, widget.callType);
      if(widget.callModel.agoraCallback==null)
        widget.callModel.agoraCallback=[];
      widget.callModel.agoraCallback!.add(callAgoraCallBack);
      _onCallEnd(context, _myUId, widget.callModel);
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    //_engine.enableVideo();
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _onChangeCameraVisibility() {
    _engine.enableLocalVideo(false);
  }

  List<Widget> listRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(RtcLocalView.SurfaceView());
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  Widget videoViewWidget(view) {
    return Expanded(child: Container(child: view));
  }

  Widget expandedVideoViewWidget(List<Widget> views) {
    final wrappedViews = views.map<Widget>(videoViewWidget).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget videoViewRowsWidget() {
    final views = listRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[videoViewWidget(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            expandedVideoViewWidget([views[0]]),
            expandedVideoViewWidget([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            expandedVideoViewWidget(views.sublist(0, 2)),
            expandedVideoViewWidget(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            expandedVideoViewWidget(views.sublist(0, 2)),
            expandedVideoViewWidget(views.sublist(2, 4))
          ],
        ));
      default:
        return Wrap(
          children: [expandedVideoViewWidget(views)],
        );
    }
    return Container();
  }

  Widget toolbarWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          widget.callType == "video"
              ? RawMaterialButton(
                  onPressed: _onChangeCameraVisibility,
                  child: Icon(
                    Icons.camera,
                    color: Colors.blueAccent,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.white,
                  padding: const EdgeInsets.all(12.0),
                )
              : Container(),
          RawMaterialButton(
            onPressed: () {
              _engine.leaveChannel();
            },
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          widget.callType == "video"
              ? RawMaterialButton(
                  onPressed: _onSwitchCamera,
                  child: Icon(
                    Icons.switch_camera,
                    color: Colors.blueAccent,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.white,
                  padding: const EdgeInsets.all(12.0),
                )
              : Container()
        ],
      ),
    );
  }

  Widget panelWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context, int uId, CallModel callModel) async {
    return showDialog(
            context: context,
            builder: (context) {
              return new AlertDialog(
                title: Text("Rate your Experience"),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Center(child: RatingBuilder()),
                      ReviewDescriptionWidget(),
                    ],
                  ),
                ),
                contentPadding: const EdgeInsets.all(10.0),
                actions: [
                  EbOutlineButtonWidget(
                    callback: () {
                      Navigator.pop(context, false);
                    },
                    buttonText: "Cancel",
                  ),
                  RatingButtonWidget(
                    callback: (bool isAdded) {
                      Navigator.pop(context, true);
                    },
                    forUserId: widget.role == ClientRole.Broadcaster
                        ? widget.callModel.receiverId[0]
                        : widget.callModel.userId,
                    ratingModel: widget.role == ClientRole.Broadcaster
                        ? new RatingModel(
                            review: BlocProvider.of<RatingBloc>(context).review,
                            rating: BlocProvider.of<RatingBloc>(context).rating,
                            userId: widget.callModel.userId)
                        : new RatingModel(
                            review: BlocProvider.of<RatingBloc>(context).review,
                            rating: BlocProvider.of<RatingBloc>(context).rating,
                            userId: widget.callModel.receiverId[0]),
                  )
                ],
              );
            },
            barrierDismissible: false)
        .then((value) {
      if (widget.role == ClientRole.Audience) {
        BlocProvider.of<CallBloc>(context).add(LogUserVideoCallingTime(
            uId: uId,
            userId: getUserDTOModelObject(context).userId,
            groupId: widget.groupId,
            isForGroup: widget.groupId == "" ? false : true,
            callModel: callModel,
            dateTime: DateTime.now().toIso8601String(),
            isUser: false,
            typeOfLogging: "end"));
      } else {
        BlocProvider.of<CallBloc>(context).add(LogUserVideoCallingTime(
            uId: uId,
            userId: getUserDTOModelObject(context).userId,
            callModel: callModel,
            dateTime: DateTime.now().toIso8601String(),
            isUser: true,
            groupId: widget.groupId,
            isForGroup: widget.groupId == "" ? false : true,
            typeOfLogging: "end"));
      }
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Video"),
        actions: widget.groupId != ""
            ? [IconButton(onPressed: () {}, icon: Icon(Icons.person))]
            : [],
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            videoViewRowsWidget(),
            panelWidget(),
            toolbarWidget(),
          ],
        ),
      ),
    );
  }
}
