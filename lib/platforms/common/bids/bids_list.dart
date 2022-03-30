import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_event.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_state.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/bid_detail_freelancer_view/bid_detail_freelancer.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/bid_detail_user_view/bid_detail.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';

//TODO- Get bids for user and freelancer
class BidsList extends StatefulWidget {
  BidListPageState createState()=>BidListPageState();
}
class BidListPageState extends State<BidsList>{
  String userId="";
  void initState(){
    super.initState();
    userId = BlocProvider.of<LoginBloc>(context).userDTOModel.userId;
    BlocProvider.of<BidBloc>(context)
        .add(FetchBidListEvent(userId: userId, userType: "user"));

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bids")
      ),
      body: BlocBuilder<BidBloc, BidState>(builder: (context, state) {
        if (state is LoadingBidState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Loading")],
            ),
          );
        } else if (state is BidListState) {
          if(state.bidModels.isEmpty)
            return NoDataFound();
          return ListView.builder(
            itemCount: state.bidModels.length,
            itemBuilder: (context,int index){
              return ListTile(
                onTap: () {
                  if(state.bidModels[index].userId!=userId){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BidDetailFreelancerPage(
                          freelancerId: state.bidModels[index].freelancerId,bidId: state.bidModels[index].userId,userIdOfBidder: state.bidModels[index].userId)),
                    );
                  }
                  else{
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BidDetailPage(bidId: state.bidModels[index].id)),
                    );
                  }

                },
                title: Text("Bid${index}"),
              );
            },

          );
        } else
          return Container();
      }),
    );
  }
}
