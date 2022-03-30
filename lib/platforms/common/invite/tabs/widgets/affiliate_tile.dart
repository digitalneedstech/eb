import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/invite/bloc/affiliate_bloc.dart';
import 'package:flutter_eb/platforms/common/invite/bloc/affiliate_event.dart';
import 'package:flutter_eb/platforms/common/invite/bloc/affiliate_state.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/affiliate_model/affiliate_model.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';

class AffiliateTile extends StatelessWidget{
  AffiliateModel affiliateModel;
  final Function callback;
  AffiliateTile({required this.affiliateModel,required this.callback});
  @override
  Widget build(BuildContext context) {
    return BlocListener<AffiliateBloc,AffiliateState>(
      listener: (context,state){
        if(state is SendAffiliateLinkState){
          callback(state.isSent);
        }
      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                    spreadRadius: 1.0)
              ]),
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text("Client Email:"),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                        affiliateModel.email,
                        style: TextStyle(
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text("Status:"),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                        affiliateModel.isAccepted ? "Accepted":"Pending",
                        style: TextStyle(
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BlocBuilder<AffiliateBloc, AffiliateState>(
                      builder: (context, state) {
                        if (state is SendAffiliateLinkInProgressState) {
                          return EbRaisedButtonWidget(
                              buttonText: "Sending", callback: (){

                          });
                        }
                        return EbRaisedButtonWidget(
                          buttonText: "Send Invite Again",
                          callback: () {
                            BlocProvider.of<AffiliateBloc>(context).add(
                                SendAffiliateLinkEvent(
                                  isResend: true,
                                    senderName: BlocProvider.of<LoginBloc>(context)
                                        .userDTOModel
                                        .personalDetails
                                        .displayName,
                                    senderId: BlocProvider.of<LoginBloc>(context)
                                        .userDTOModel.userId,
                                    email: affiliateModel.email,
                                    shareLink: BlocProvider.of<LoginBloc>(context)
                                        .userDTOModel
                                        .shareLink));
                          },
                        );
                      })
                ],
              )
            ],
          )),
    );
  }
}