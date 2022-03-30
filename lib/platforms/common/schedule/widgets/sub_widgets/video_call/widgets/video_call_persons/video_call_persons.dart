import 'package:flutter/material.dart';

class VideoCallPersons extends StatelessWidget{
  //final VoidCallback disableAudioCallback;
  final List<String> freelancerIds;
  VideoCallPersons({required this.freelancerIds});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendees"),
      ),
      body: ListView.builder(itemBuilder: (context,int index){
        return ListTile(
          title: Text(""),

          );
      },itemCount: freelancerIds.length,),
    );
  }
}