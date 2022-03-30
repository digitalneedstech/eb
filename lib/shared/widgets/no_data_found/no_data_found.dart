import 'package:flutter/material.dart';

class NoDataFound extends StatelessWidget{
  final String message;
  NoDataFound({this.message="No Data Found"});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message,style: TextStyle(fontSize: 16.0),)
        ],
      ),
    );
  }
}