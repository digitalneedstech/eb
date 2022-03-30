import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';

class RateDurationRow extends StatelessWidget{
  final ScheduleRequest scheduleRequest;
  RateDurationRow({required this.scheduleRequest});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width:MediaQuery.of(context).size.width*0.3,child: Text("Rate")),
              SizedBox(
                height: 10.0,
              ),
              RichText(
                  text: TextSpan(
                      text: "\$ ${scheduleRequest.askedRate}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: " /hr",
                            style: TextStyle(color: Colors.grey.shade500))
                      ]))
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Duration"),
              SizedBox(
                height: 10.0,
              ),
              Text("${scheduleRequest.duration } min"),

            ],
          )
        ],
      ),
    );
  }
}