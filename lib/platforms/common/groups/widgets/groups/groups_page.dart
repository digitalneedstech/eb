import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/tabs/groups_page.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/tabs/other_groups_page.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/eb_web_app_bar/eb_web_appbar.dart';

class GroupsTabPage extends StatelessWidget{
  GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
      initialIndex: 0,
      child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: getScreenWidth(context)>800 ?PreferredSize(
              preferredSize: Size.fromHeight(100.0), // here the desired height
              child: Column(
                children: [
                  TabBar(
                      indicatorColor: Colors.blue,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.white,
                      tabs: [
                        Tab(text: "My Groups"),
                        Tab(text: "Other Groups")
                      ]),
                ],
              )
          ): AppBar(automaticallyImplyLeading:false,
              title: SizedBox(
                  height:0.0
              ),
              bottom: TabBar(
                  indicatorColor: Colors.blue,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Tab(text: "My Groups"),
                    Tab(text: "Other Groups")
                  ])
          ),
          body: TabBarView(
            children: [
              GroupsPage(),
              OtherGroupsPage()
            ],
          )),
    );
  }
}