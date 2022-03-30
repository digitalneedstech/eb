import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
//import 'dart:html' as html;
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,

  };
}
class HowItWorksPage extends StatelessWidget{

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
              //crossAxisAlignment: CrossAxisAlignment.center,
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
                                  Text("How It Works",style: TextStyle(color: Colors.white),),
                                  Text("Support",style: TextStyle(color: Colors.white),),
                                  Text("Login",style: TextStyle(color: Colors.white),)

                                ],
                              ),
                            ),

                          ],
                        ),
                        Expanded(child: SizedBox()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text("BECOME PART OF EXPERTBUNCH",style: TextStyle(color: Colors.white,fontSize: 30),),
                                Text("BY JOINING THE TOP COMPANIES & FREELANCERS TEAM ",style:
                                TextStyle(color: Colors.white,fontSize: 26),),
                              ],
                            ),
                            Image.asset("assets/images/how_slider_image_1.png",fit: BoxFit.cover,)
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
      width: MediaQuery.of(context).size.width*0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        children: [
          Container(
            //width: MediaQuery.of(context).size.width*0.6,
            decoration: BoxDecoration(
              color: Color(0xFF23374D),

            ),
            child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ORGANIZATION / RESOURCES",style: TextStyle(fontSize: 24.0,
                                fontWeight: FontWeight.w800,color: Colors.white),),
                            Text("Any small & Large entrepreneurs can set up their business platform to provide their resources for consulting services.",style: TextStyle(
                                fontSize: 24.0,fontWeight: FontWeight.w200,color: Colors.white
                            ),)
                          ],
                        ),
                      ),
                    ),
                    Expanded(child: Image.asset("assets/images/web_org.jpg",width: MediaQuery.of(context).size.width*0.25,)),
                  ],
                )

            ),

      Image.asset("assets/images/what_can_do.jpg",width: MediaQuery.of(context).size.width*0.25,)]
          ),
    );
  }
}

class ConsultingWidget2 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.9,
      child: Column(
          children: [
            Container(
              //width: MediaQuery.of(context).size.width*0.6,
                decoration: BoxDecoration(
                    color: Color(0xFF2EC5CE),
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [


                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Column(
                          children: [
                            Text("SME / FREELANCER",style: TextStyle(fontSize: 24.0,
                                fontWeight: FontWeight.w800,color: Colors.white),),
                            Text("Earn over time while you contribute to solutions.",style: TextStyle(
                                fontSize: 24.0,fontWeight: FontWeight.w200,color: Colors.white
                            ),)
                          ],
                        ),
                      ),
                    ),
                    Expanded(flex:2,child: Image.asset("assets/images/web_video_call.jpg",width: MediaQuery.of(context).size.width*0.25,)),
                  ],
                )

            ),

            Image.asset("assets/images/what_can_do.jpg",width: MediaQuery.of(context).size.width*0.25,)]
      ),
    );
  }
}


class ConsultingWidget3 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
              decoration: BoxDecoration(
                  color: Color(0xFF23384D),
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Image.asset("assets/images/web_video_call.jpg",width: MediaQuery.of(context).size.width*0.25,)),

                  Expanded(flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Column(
                        children: [
                          Text("Refer and get",style: TextStyle(fontSize: 24.0,
                              fontWeight: FontWeight.w800,color: Colors.white),),
                          Text("Royalty benefit\n Lifetime",style: TextStyle(
                              fontSize: 24.0,fontWeight: FontWeight.w200,color: Colors.white
                          ),)
                        ],
                      ),
                    ),
                  ),

                ],
              )

          );
  }
}

class BottomWhiteBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,


      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1,
                vertical: MediaQuery.of(context).size.height*0.1),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/images/logo.jpg"),
                      Text("Aggregating Experts"),
                          Text("Converging Skills"),
                          Text("SOS Solution Platform with Bid"),
                          Text("Your Price (Bid), Your\n convenience (Schedule)"),
Text("A platform for Freelancers to work from anywhere")


                    ],
                  ),
                ),
                SizedBox(width: 20.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("FOR CLIENT",style: TextStyle(fontWeight: FontWeight.bold),),
                      Divider(color: Colors.blue,),
                      Text("FAQ"),
                      Text("Hire Experts"),
                      Text("Know More"),
                      SizedBox(),
                      Text("FOR CLIENT",style: TextStyle(fontWeight: FontWeight.bold),),
                      Divider(color: Colors.blue,),
                      Text("FAQ"),
                      Text("Hire Experts"),


                    ],
                  ),
                ),
                SizedBox(width: 20.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ORGANIZATION / RESOURCES PROVIDER",style: TextStyle(fontWeight: FontWeight.bold),),
                      Divider(color: Colors.blue,),
                      Text("Add Resources"),
                      Text("Promote your Service"),
                      Text("Know More"),
                      SizedBox(),
                      Text("FOR AFFILIATE",style: TextStyle(fontWeight: FontWeight.bold),),
                      Divider(color: Colors.blue,),
                      Text("Refer & Earn"),
                      Text("How It Benefits"),
                      InkWell(onTap: (){
                        //html.window.open('https://expertbunch-c5b78.web.app/terms/index.html', 'new tab');
                        //js.context.callMethod('open', ['https://expertbunch-c5b78.web.app/#/terms']);
                        //Navigator.pushNamed(context, Routers.TERMS);
                      },child: Text("Terms And Conditions")),


                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Color(0xFF23384D),
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.05),
            child: Center(
              child: Text("Expert Bunch © 2021   |   All Rights Reserved.   |   Privacy Policy",style: TextStyle(color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }
}