
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_message.dart';

class BidMessage extends StatelessWidget {
  bool isFromOtherParty;
  BidMessageModel bidMessage;

  BidMessage({this.isFromOtherParty = false, required this.bidMessage});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: isFromOtherParty ? Color(0xFFD6E6FD) : Colors.grey.shade200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bid Offered",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "\$ ${bidMessage.amount}",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          bidMessage.hoursNeeded==0 ?Container():Text(
            "Hours Needed: ${bidMessage.hoursNeeded}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "Valid Till : ${bidMessage
                .validTill.split("T")[0].toString()}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            bidMessage.message,
            style: TextStyle(color: Colors.black54),
          )
        ],
      ),
    );
  }
}
