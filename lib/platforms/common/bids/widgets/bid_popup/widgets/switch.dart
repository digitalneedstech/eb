import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_event.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_state.dart';

class SwitchBidType extends StatefulWidget {

  String bidId;
  bool bidType;
  Function callback;
  SwitchBidType({required this.callback,required this.bidId,required this.bidType});
  SwitchBidTypeState createState()=>SwitchBidTypeState();
}
class SwitchBidTypeState extends State<SwitchBidType>{
  bool value=false;
  @override
  Widget build(BuildContext context) {
    return widget.bidId == ""
        ? Column(
      children: [
        RadioListTile(
          groupValue: value,
          value: false,
          onChanged: (bool? val) {
            widget.callback(false);
            setState(() {
              value=val!;
            });
          },
          title: Text("One Time Commitment"),
        ),
        RadioListTile(
          groupValue: value,
          value: true,
          onChanged: (bool? val) {
            widget.callback(true);
            setState(() {
              value=val!;
            });
          },
          title: Text("Long Time Commitment"),
        )
      ],
    )
        : BlocBuilder<BidBloc, BidState>(builder: (context, state) {
      if (state is BidInfoInPopupState) {
        BlocProvider.of<BidBloc>(context).isLongTerm =
            state.bidModel.isLongTerm;
        return state.bidModel.isLongTerm
            ? Text("The Bid is Long Term")
            : Text("The Bid is Short Term");
      }
      return Container();
    });
  }
}