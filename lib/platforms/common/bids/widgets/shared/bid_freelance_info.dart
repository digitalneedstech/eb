
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/bid_detail_freelancer_view/bid_detail_freelancer.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/shared/bidder_info.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/shared/job_description.dart';

class BidInfoWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      margin: const EdgeInsets.all(20.0),
      padding:
      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
        // border: Border.all(color: Colors.grey.shade500,width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Bid Offered By:"),
          SizedBox(
            height: 20.0,
          ),
          BidderInfo(),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "Job Description",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          JobDescriptionWidget()
        ],
      ),
    );
  }
}
