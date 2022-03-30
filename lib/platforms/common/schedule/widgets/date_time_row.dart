import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';

class DateTimeRow extends StatefulWidget {
  final ScheduleRequest scheduleRequest;

  DateTimeRow({required this.scheduleRequest});

DateTimeRowState createState()=>DateTimeRowState();
}
class DateTimeRowState extends State<DateTimeRow>{
late DateTime startTime, endTime;
void initState(){
  super.initState();
  getDuration();
}
  getDuration(){
    setState(() {
      startTime=DateTime.parse(widget.scheduleRequest.callScheduled).toLocal();
      endTime=DateTime.parse(widget.scheduleRequest.callScheduled)
          .add(Duration(minutes: widget.scheduleRequest.duration)).toLocal();
    });

  }

  String getStartTime(){
    var startTimeVal=startTime.toIso8601String();
    return startTime.toIso8601String().split("T")[1];
  }
  String getEndTime(){
    return endTime.toIso8601String().split("T")[1];
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width:MediaQuery.of(context).size.width*0.3,child: Text("Date")),
              SizedBox(
                height: 10.0,
              ),
              Text("${DateTime.parse(widget.scheduleRequest.callScheduled).day.toString() +"-"+ DateTime.parse(widget.scheduleRequest.callScheduled).month.toString()+"-"+DateTime.parse(widget.scheduleRequest.callScheduled).year.toString()}"),

            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Time",textAlign: TextAlign.left,),
              SizedBox(
                height: 10.0,
              ),
              Text("${getStartTime().split(".")[0]}-${getEndTime().split(".")[0]}"),

            ],
          )
        ],
      ),
    );
  }
}