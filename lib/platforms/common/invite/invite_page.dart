import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/invite/widgets/send_button.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:flutter_eb/shared/widgets/eb_web_app_bar/eb_web_appbar.dart';
import 'package:share/share.dart';
import 'package:sprintf/sprintf.dart';

class InvitePage extends StatelessWidget {
  final Function callback;
  InvitePage({required this.callback});
  @override
  Widget build(BuildContext context) {
    TextStyle style=TextStyle(color: Colors.white);
    return Center(
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: getScreenWidth(context)>600 ? MediaQuery.of(context).size.width*0.6:
              MediaQuery.of(context).size.width,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Invite Others and get Bonus",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
                      " Thus main industry's standard dummy text ever",
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 10.0,
                  ),
                  AffiliateSendButton(callback: (bool isSent,String errorMessage){
                    callback(isSent,errorMessage);
                  },),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("OR"),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Share Your Link:"),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                labelStyle: TextStyle(color: Colors.grey)),
                            initialValue: BlocProvider.of<LoginBloc>(context)
                                .userDTOModel
                                .shareLink,
                          ),
                        ),
                        EbRaisedButtonWidget(
                          buttonText: "Send",
                          callback: () {
                            String notificationContent="Hello %s \n You have been invited by %s to be a service provider / user in \n "
                                "ExpertBunch.com which is a platform for professionals from various industries. This \n"
                                "will enable you to provide service through this app/portal and earn on time basis. \n \n"
                                "Click the link to join ExpertBunch service providers platform \n "
                                "%s \n"
                                "In case of any trouble in connecting, contact support@expertbunch.com";
                            Share.share(sprintf(notificationContent,[
                              "User",BlocProvider.of<LoginBloc>(context).userDTOModel.personalDetails.displayName,
                              BlocProvider.of<LoginBloc>(context).userDTOModel.shareLink
                            ]));
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text("How It Works",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      )),
                  SizedBox(
                    height: 20.0,
                  ),
                  getScreenWidth(context)>800 ?Wrap(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width*0.2,
                        child: Column(
                          children: [
                            Text("1. Share your Link",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                                textAlign: TextAlign.center),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                                "Send the Invite link to established fact that a reader will be by the series of readable content",
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.2,
                        child: Column(
                          children: [
                            Text("2. Get Signup Discount",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                                textAlign: TextAlign.center),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                                "Send the Invite link to established fact that a reader will be by the series of readable content",
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      )
                    ],
                  ):Container(),
                  getScreenWidth(context)>800 ?Container():Text("1. Share your Link",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center),
                  getScreenWidth(context)>800 ?Container():SizedBox(
                    height: 10.0,
                  ),
                  getScreenWidth(context)>800 ?Container():Text(
                      "Send the Invite link to established fact that a reader will be by the series of readable content",
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center),
                  getScreenWidth(context)>800 ?Container():SizedBox(
                    height: 20.0,
                  ),
                  getScreenWidth(context)>800 ?Container():Text("2. Get Signup Discount",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center),
                  getScreenWidth(context)>800 ?Container():SizedBox(
                    height: 10.0,
                  ),
                  getScreenWidth(context)>800 ?Container():Text(
                      "Send the Invite link to established fact that a reader will be by the series of readable content",
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          getScreenWidth(context)>800 ?Expanded(child: Container(
            color: Colors.black,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width*0.6,
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Padding(padding: const EdgeInsets.all(5.0),
                            child: Text("About Us",style: style,),),
                          Padding(padding: const EdgeInsets.all(5.0),
                            child: Text("Blog",style: style,),),
                          Padding(padding: const EdgeInsets.all(5.0),
                            child: Text("Careers",style: style,),),
                          Padding(padding: const EdgeInsets.all(5.0),
                            child: Text("Contact Us",style: style,),),

                        ],
                      ),
                    ),
                    Expanded(child: Column(
                      children: [
                        Padding(padding: const EdgeInsets.all(5.0),
                          child: Text("Help Center",style: style,),),
                        Padding(padding: const EdgeInsets.all(5.0),
                          child: Text("Safety Center",style: style,),),
                        Padding(padding: const EdgeInsets.all(5.0),
                          child: Text("Community Guidelines",style: style,),),

                      ],
                    )),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(padding: const EdgeInsets.all(5.0),
                            child: Text("Cookies Policy",style: style,),),
                          Padding(padding: const EdgeInsets.all(5.0),
                            child: Text("Privacy Policy",style: style,),),
                          Padding(padding: const EdgeInsets.all(5.0),
                            child: Text("Text",style: style,),),
                          Padding(padding: const EdgeInsets.all(5.0),
                            child: Text("Terms Of Service",style: style,),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),flex: 1,):Container()
        ],
      ),
    );
  }
}
