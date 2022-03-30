import 'package:flutter/material.dart';

class TabHeaderWidget extends StatelessWidget{
  final bool isUserRole;
  TabHeaderWidget({required this.isUserRole});
  @override
  Widget build(BuildContext context) {
    return TabBar(
        indicatorColor: Colors.blue,
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.white,
        isScrollable: true,
        tabs: [
          Tab(text: "Overview"),
          Tab(text: isUserRole
              ? "Calls Made"
              : "Calls Received"),
          Tab(
              text: isUserRole
                  ? "Schedule Calls Made"
                  : "Schedule Calls Received"),
          Tab(text: isUserRole
              ? "Bid Sent"
              : "Bids Received"),
          Tab(
              text: isUserRole
                  ? "Contract Bid Sent"
                  : "Contract Bids Received")
        ]);
  }
}