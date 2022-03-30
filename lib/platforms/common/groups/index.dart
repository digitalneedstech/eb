import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/groups_page.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/wishlist.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/drawer/drawer.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/eb_web_app_bar/eb_web_appbar.dart';

class GroupsTab extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
      initialIndex: 0,
      child: Scaffold(
          drawer: DrawerItems(),
        backgroundColor: Colors.grey.shade200,
          appBar: getScreenWidth(context)>800 ?PreferredSize(
              preferredSize: Size.fromHeight(100.0), // here the desired height
              child: Column(
                children: [
                  EbWebAppBarWidget(),
                  TabBar(
                      indicatorColor: Colors.blue,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.white,
                      tabs: [
                        Tab(text: "WishList"),
                        Tab(text: "Group")
                      ]),
                ],
              )
          ): AppBar(
            centerTitle: true,
            title: Text("Groups"),bottom: TabBar(
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(text: "WishList"),
                Tab(text: "Group")
              ]),
          ),
          body: TabBarView(
            children: [

              WishListPage(),
              GroupsTabPage(),
            ],
          )),
    );
  }
}