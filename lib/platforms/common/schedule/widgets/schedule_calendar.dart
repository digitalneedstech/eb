import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleCalender extends StatelessWidget{
  final Function callback;
  ScheduleCalender({required this.callback});
  @override
  Widget build(BuildContext context) {
    //TODO-
    return Container();
    /*return AlertDialog(
      title: Center(child: Text("Select the date")),
      content: Container(
        child: TableCalendar(

          //onCalendarCreated: CalendarController(),
          *//*onDaySelected: (DateTime day, List events, List holidays) {
            this.callback(day);
          },*//*
          currentDay: DateTime.now(),
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(Duration(days: 100000)),
        ),
      ),
    );*/
  }
}