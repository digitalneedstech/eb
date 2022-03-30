import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/home_nav/notifications/widgets/notifications_list_widget.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/drawer/drawer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class NotificationsListPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      drawer: DrawerItems(),
      appBar: AppBar(
        title: Text("Notifications"),

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimationLimiter(
          child: NotificationsListWidget(),
        ),
      ),
    );
  }
}