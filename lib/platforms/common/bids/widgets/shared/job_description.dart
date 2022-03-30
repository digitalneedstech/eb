
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_state.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_state.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';

class JobDescriptionWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BidBloc,BidState>(
        builder: (context,state){
          if(state is BidInfoState){
            return Text(state.bidModel.description,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black),);
          }
          return Text("Loading",overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black),);
        });

  }
}
