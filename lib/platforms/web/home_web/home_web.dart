import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/web/how_it_works/how_it_works.dart';
import 'package:flutter_eb/shared/services/router/routers.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,

  };
}
class HomeWeb extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ScrollConfiguration(
          behavior: MyCustomScrollBehavior(),
          child: ListView(
            shrinkWrap: true,
            children: [
                 Container(width: MediaQuery.of(context).size.width,
                   height: MediaQuery.of(context).size.height*0.45,
                 padding: const EdgeInsets.all(0.0),
                 decoration: BoxDecoration(
                   image: DecorationImage(
                     fit: BoxFit.cover,
                     image: AssetImage(
                       "assets/images/slider_web.jpg",
                     )
                   )
                 ),
                   child: Padding(
                     padding: const EdgeInsets.all(10.0),
                     child: Column(
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Expanded(child: Image.asset("assets/images/logo.jpg")),
                             Expanded(flex:2,child: SizedBox()),
                             Expanded(
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   InkWell(
                                       child: Text("How It Works",style: TextStyle(color: Colors.white),)),
                                   Text("Support",style: TextStyle(color: Colors.white),),
                                   InkWell(

                                       onTap:(){
                                         Navigator.pushNamed(context, Routers.LOGIN);
                                       },
                                       child: Text("Login",style: TextStyle(color: Colors.white),))

                                 ],
                               ),
                             ),

                           ],
                         ),
                         Expanded(child: SizedBox()),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text("REIMAGINED \n PLATFORM",style: TextStyle(color: Colors.white,fontSize: 30),)
                           ],
                         ),

                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text("TO CONVERGE MULTIPLE EXPERTS",
                               style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30.0),)
                           ],
                         ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Container(
                               width:MediaQuery.of(context).size.width*0.45,
                               child: TextFormField(

                                 decoration: InputDecoration(
                                   hintText: "Find & quickly connect with Experts",
                                   fillColor: Colors.white,
                                   filled: true
                                 ),
                               ),
                             ),
                             Container(
                               child: EbRaisedButtonWidget(callback: (){

                               },textColor: Colors.white,buttonColor: Color(0xFFFF696A),buttonText: "Search",),
                             )

                           ],
                         ),
                         Expanded(child: SizedBox())
                       ],
                     ),
                   ),
                 ),
              SkillSlider(),
              WhatCanDo(),
              ConsultingWidget(),
              ConsultingWidget2(),
              ConsultingWidget3(),
              PlanWidget(),
              ReferWidget(),

              BottomWhiteBar()
            ],
          ),
        ),
      )
    );
  }
}

class SkillSlider extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.3,
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(itemBuilder:(context,index){
        return Container(
          //color: Colors.white,
          padding: const EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width*0.2,
          height: MediaQuery.of(context).size.height*0.1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/cloud.jpg"),
              Text("Cloud Architect",style: TextStyle(color: Colors.black),)
            ],
          ),
        );
      },scrollDirection: Axis.horizontal,),
    );
  }
}

class WhatCanDo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Image.asset("assets/images/what_can_do.jpg"),
      ),
    );
  }
}

class ConsultingWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Image.asset("assets/images/what_can_do.jpg",width: MediaQuery.of(context).size.width*0.25,)),
          //Expanded(child: SizedBox()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: [
                  Text("Experts as a Service (ExaaS)",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w800),),
                  Text("A platform that provides Experts as a Service (ExaaS) where you can find and collaborate with experts from various industry domains to get SOS solutions."+
                    "This platform also aggregates experts from sectors like Finance, Legal, Health & Wellness etc.",style: TextStyle(
                    fontSize: 30.0,fontWeight: FontWeight.w200
                  ),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ConsultingWidget2 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: [
                  Text("Multiple experts aggregated",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w800),),
                  Text("to solve a problem",style: TextStyle(
                      fontSize: 30.0,fontWeight: FontWeight.w200
                  ),)
                ],
              ),
            ),
          ),
          Expanded(child: Image.asset("assets/images/what_can_do.jpg",width: MediaQuery.of(context).size.width*0.25,)),
          //Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}


class ConsultingWidget3 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2EC5CE),
      width: MediaQuery.of(context).size.width*0.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Image.asset("assets/images/mobile1.jpg",width: MediaQuery.of(context).size.width*0.25,)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: [
                  Text("Get things done more easier.",style: TextStyle(fontSize: 30.0,color:Colors.white,fontWeight: FontWeight.w800),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset("assets/images/playstore.jpg"),
                      SizedBox(width: 20.0,),
                      Image.asset("assets/images/appstore.jpg")
                    ],
                  )
                ],
              ),
            ),
          ),

          //Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class PlanWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.6,
      color: Colors.white,
      width: MediaQuery.of(context).size.width*0.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Image.asset("assets/images/standard.jpg",width: MediaQuery.of(context).size.width*0.25,)),
          Expanded(child: Image.asset("assets/images/annual.jpg",width: MediaQuery.of(context).size.width*0.25,)),
          Expanded(child: Image.asset("assets/images/enterprise.jpg",width: MediaQuery.of(context).size.width*0.25,)),
        ],
      ),
    );
  }
}

class ReferWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF4F9FF),
      width: MediaQuery.of(context).size.width*0.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Image.asset("assets/images/refer.jpg",width: MediaQuery.of(context).size.width*0.25,)),

        ],
      ),
    );
  }
}