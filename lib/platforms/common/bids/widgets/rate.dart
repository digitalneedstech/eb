import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_state.dart';

class BidRate extends StatelessWidget{
  final int hourlyRate;
  BidRate({this.hourlyRate=0});
  @override
  Widget build(BuildContext context) {
    return RichText(
                text: TextSpan(
                    text:
                    hourlyRate.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: " /hr",
                          style: TextStyle(
                              color: Colors.grey.shade500))
                    ]));
  }
}