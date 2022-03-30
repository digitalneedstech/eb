import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/web/web_dashboard/pages/index.dart';
import 'package:flutter_eb/shared/widgets/eb_web_app_bar/eb_web_appbar.dart';
class WebDashboard extends StatefulWidget{
  WebDashboardState createState()=>WebDashboardState();
}
class WebDashboardState extends State<WebDashboard>{
  List<String> tabs=["My Task","Wallet","My Profile","Chats","Groups","My Posts","My Company","My Affiliate",
  "Upcoming Calls"];
  Map<String,int> tabsMap={
    "My Task":0,"Wallet":1,"My Profile":2,"Chats":3,"Groups":4,
    "My Posts":5,"My Company":6,"My Affiliate":7,
    "Upcoming Calls":8
  };
  int activeTab=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            //EbWebAppBarWidget(),
            Expanded(
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: ListView(shrinkWrap:true,children:
                      tabsMap.entries.map((e) {
                        return ListTile(
                          onTap: (){
                            setState(() {
                              activeTab=e.value;
                            });
                          },
                          title: Text(e.key),
                          selectedColor: activeTab==e.value? Colors.grey:Colors.white,
                        );
                      }).toList()),
                    ),
                    Expanded(flex: 3,child: SidePage(activeTab))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}