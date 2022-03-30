import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/posts/posts_list.dart';
import 'package:flutter_eb/platforms/common/wallet/index.dart';
import 'package:flutter_eb/platforms/web/web_dashboard/pages/dashboard/dashboard.dart';

class SidePage extends StatelessWidget{
  int index;
  SidePage(this.index);
  @override
  Widget build(BuildContext context) {
    switch(index){
      case 0:
        return WebDashboardPage(isFreelancer: false,selectedIndex: 2,);
      case 1:
        return WalletPage();
      case 5:
        return PostsPage();
    }
    return WebDashboardPage(isFreelancer: false,selectedIndex: 0,);
  }
}