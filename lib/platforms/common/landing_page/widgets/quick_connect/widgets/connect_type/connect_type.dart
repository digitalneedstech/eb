import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
class ConnectType extends StatefulWidget{
  final String name;
  final int index;
  final int groupSelectedVal;
  final Function callback;
  ConnectType({required this.name,required this.groupSelectedVal,
    required this.index,required this.callback});
  ConnectTypeState createState()=>ConnectTypeState();
}
class ConnectTypeState extends State<ConnectType>{
  bool isEnabled=true;
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [RadioListTile(
            value: widget.index,
            groupValue: widget.groupSelectedVal,
            onChanged: (val) {
              setState(() {
                widget.callback(val);
                if ((widget.index == 1 &&
                    (BlocProvider
                        .of<LoginBloc>(context)
                        .userDTOModel
                        .planType ==
                        "pro" ||
                        BlocProvider
                            .of<LoginBloc>(context)
                            .userDTOModel
                            .planType ==
                            "Pro")) ||
                    (widget.index > 1 &&
                        (BlocProvider
                            .of<LoginBloc>(context)
                            .userDTOModel
                            .planType ==
                            "enterprise" ||
                            BlocProvider
                                .of<LoginBloc>(context)
                                .userDTOModel
                                .planType ==
                                "Enterprise")) ||
                    (widget.index==1 &&
                        (BlocProvider
                            .of<LoginBloc>(context)
                            .userDTOModel
                            .planType ==
                            "enterprise" ||
                            BlocProvider
                                .of<LoginBloc>(context)
                                .userDTOModel
                                .planType ==
                                "Enterprise"))) {
                  isEnabled = true;
                } else if (widget.index == 0) {
                  isEnabled = true;
                }
                else{
                  isEnabled=false;
                }
              });
            },
            title: Text(widget.name.split("-")[0]),
            activeColor: Colors.black),
          !isEnabled && widget.groupSelectedVal==widget.index ? Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Color(0xFF2980B9),
                borderRadius: BorderRadius.circular(10.0)),
            child: widget.name.split("-")[1]=="pro" ?Center(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Become Pro Member",style: TextStyle(color: Colors.white),),
                      Row(
                        children: [
                          Text("For Plan Details. ",style: TextStyle(fontStyle: FontStyle.italic),),
                          InkWell(
                            child:Text("Click Here",style: TextStyle(color: Colors.white),),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EbRaisedButtonWidget(
                            callback: (){

                            },
                            buttonText: "Pay Now",
                          ),
                        ],
                      )
                    ],
                  ),
                  Text("\$59",style: TextStyle(color: Colors.white),)
                ],
              ),
            ):Center(
              child: RichText(
                  text: TextSpan(
                      text: "To Become Enterprise Member \nPlease Contact Support.\n",
                      style: TextStyle(
                          color: Colors.white),
                      children: <TextSpan>[
                        TextSpan(
                            text: "For Plan Details.",
                            style: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey.shade400)),

                      ])),
            ),
          ):Container()
        ]
    );
  }
}