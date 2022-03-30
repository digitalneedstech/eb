import 'package:flutter_eb/shared/utils/camera_util_functions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/sub_widgets/video_call/video_call.dart';
import 'package:permission_handler/permission_handler.dart';
class PickupScreen extends StatelessWidget {
  final CallModel callModel;
  PickupScreen({required this.callModel});
  GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming Call From...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 50),
            Text(
              callModel.userName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () {

                    Navigator.pop(context);}
                ),
                SizedBox(width: 25),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.green,
                  onPressed: () async{
                  PermissionStatus status1=await Permission.camera.request();
                  PermissionStatus status2=await Permission.microphone.request();
                  try {
                    handleInvalidPermissions(status1, status2);
                  }catch(e){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("There was a server or permissions error"),
                      backgroundColor: Colors.red,
                    ));
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              VideoCall(cameraPermission: status1,microPhonePermission: status2,
                                  isForGroup: false,
                                  callModel: callModel,
                                  role: ClientRole.Audience)),
                      );

                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }}