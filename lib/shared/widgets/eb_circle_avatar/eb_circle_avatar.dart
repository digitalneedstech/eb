import 'package:flutter/material.dart';

class EbCircleAvatarWidget extends StatelessWidget{
  final String profileImageUrl;
  final double radius;
  EbCircleAvatarWidget({this.radius=30.0,this.profileImageUrl=""});
  @override
  Widget build(BuildContext context) {
    if(profileImageUrl=="") {
      return CircleAvatar(child: Icon(Icons.person,color: Colors.white,size: radius),backgroundColor: Colors.grey,radius: radius);
    }
    else{
      return CircleAvatar(backgroundImage:NetworkImage(profileImageUrl),radius: radius);
    }
  }
}