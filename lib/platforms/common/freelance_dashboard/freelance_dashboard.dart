import 'package:flutter/material.dart';
import 'package:flutter_eb/shared/constants/routes.dart';

class FreelanceDashboard extends StatefulWidget {
  FreelanceDashboardState createState()=>FreelanceDashboardState();
}
class FreelanceDashboardState extends State<FreelanceDashboard>{
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text("Freelance Dashboard"),
          automaticallyImplyLeading: false,
        ),
        body:ListView(
          children: [
            ListTile(title: Text("Bids"),onTap: ()=>Navigator.pushNamed(context, Routes.BID_LIST),),
            ListTile(title: Text("Calls"),onTap: ()=>Navigator.pushNamed(context, Routes.BID_LIST),),
            ListTile(title: Text("Profiles"),onTap: ()=>Navigator.pushNamed(context, Routes.DASHBOARD),),
          ],
        )
    );
  }
}