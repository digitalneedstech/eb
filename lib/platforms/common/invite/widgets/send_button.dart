import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/invite/bloc/affiliate_bloc.dart';
import 'package:flutter_eb/platforms/common/invite/bloc/affiliate_event.dart';
import 'package:flutter_eb/platforms/common/invite/bloc/affiliate_state.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';

class AffiliateSendButton extends StatefulWidget {
  final Function callback;
  AffiliateSendButton({required this.callback});
  AffiliateSendButtonState createState() => AffiliateSendButtonState();
}

class AffiliateSendButtonState extends State<AffiliateSendButton> {
  TextEditingController _emailAddressController =
      TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    return BlocListener<AffiliateBloc, AffiliateState>(
      listener: (context, state) {
        if (state is SendAffiliateLinkState) {
          widget.callback(state.isSent,!state.isSent ? "Link Has Already been sent":state.errorMessage);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _emailAddressController,
                decoration: InputDecoration(
                    labelText: "Enter Email Address",
                    enabledBorder: InputBorder.none,
                    labelStyle: TextStyle(color: Colors.grey)),
              ),
            ),
            BlocBuilder<AffiliateBloc, AffiliateState>(
                builder: (context, state) {
              if (state is SendAffiliateLinkInProgressState) {
                return EbRaisedButtonWidget(
                    buttonText: "Sending", callback: (){

                });
              }
              return EbRaisedButtonWidget(
                buttonText: "Send",
                callback: () {
                  _emailAddressController.text.trim()!=""?
                  BlocProvider.of<AffiliateBloc>(context).add(
                      SendAffiliateLinkEvent(
                          senderName: BlocProvider.of<LoginBloc>(context)
                              .userDTOModel
                              .personalDetails
                              .displayName,
                          senderId: BlocProvider.of<LoginBloc>(context)
                              .userDTOModel.userId,
                          email: _emailAddressController.text,
                          shareLink: BlocProvider.of<LoginBloc>(context)
                              .userDTOModel
                              .shareLink)):null;
                },
              );
            })
          ],
        ),
      ),
    );
  }
}
