import 'package:flutter/material.dart';

class TabHeaderCompanyWidget extends StatelessWidget{
  final bool isUserRole;
  TabHeaderCompanyWidget({required this.isUserRole});
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

        ]);
  }
}