import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/pickupcall/pages/pickup_screen.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/sub_widgets/video_call/video_call.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;

  PickupLayout({
    required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
    return (getUserDTOModelObject(context).userId != "")
        ? StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(getUserDTOModelObject(context).userId)
                .collection("calls")
                .orderBy("createdAt",descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                /*CallModel call = CallModel.fromMap(
                    snapshot.data[0]!.data() as Map<String,dynamic>,
                    snapshot.data() as Map<String,dynamic>.docs[0]
                        .id);*/
                //return PickupScreen(callModel: call);
              }
              return scaffold;
            },
          )
        : scaffold;
  }
}
