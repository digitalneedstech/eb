import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/invite/invite_page.dart';
import 'package:flutter_eb/platforms/common/invite/tabs/affiliate_revenue.dart';
import 'package:flutter_eb/platforms/common/invite/tabs/my_affiliate.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/eb_web_app_bar/eb_web_appbar.dart';

class InviteTab extends StatelessWidget{
  GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3,
      initialIndex: 0,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade200,
          appBar: getScreenWidth(context)>800 ?PreferredSize(
              preferredSize: Size.fromHeight(100.0), // here the desired height
              child: Column(
                children: [
                  EbWebAppBarWidget(),TabBar(
                          indicatorColor: Colors.blue,
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.white,
                          tabs: [
                            Tab(text: "Invite Users"),
                            Tab(text: "My Affiliate"),
                            Tab(text: "Affiliate Revenue")
                          ])

                ],
              )
          ):AppBar(title: Text("Invite Others"),bottom: TabBar(
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(text: "Invite Users"),
                Tab(text: "My Affiliate"),
                Tab(text: "Affiliate Revenue")
              ]),
          ),
          body: TabBarView(
            children: [

              InvitePage(callback: (bool isSent,String errorMessage){
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(isSent ?
               "Link Has Been Sent":errorMessage),
                backgroundColor: isSent ? Colors.green:Colors.red,));
              },),
              MyAffiliate(callback: (bool isSent){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isSent ?"Link is Sent":"Link Could not be sent"),backgroundColor:isSent ?Colors.green:Colors.red,));
              },),
              AffiliateRevenue()
            ],
          )),
    );
  }
}