import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/login/dto/affiliate_model/affiliate_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/transaction_model.dart';

class AffiliateRevenueTile extends StatelessWidget{
  int totalCommission,lastCommission;
  String affiliateName;
  AffiliateRevenueTile({this.affiliateName="",this.lastCommission=0,this.totalCommission=0});
  @override
  Widget build(BuildContext context) {
    return Container(
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
                      affiliateName,
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
                  child: Text("Total Commission:"),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                      "${totalCommission}",
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
                  child: Text("Last Commission:"),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                      lastCommission.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: (){},
                  child: Text("Click Here For Details",style: TextStyle(color: Colors.blue),),
                )
              ],
            )
          ],
        ));
  }
}