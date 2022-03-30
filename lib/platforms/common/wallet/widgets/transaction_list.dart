import 'package:flutter/material.dart';

class TransactionsListPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: 2,
    itemBuilder: (context,int index){
      return Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(flex:2,child: Text("Date",style: TextStyle(color: Colors.grey),)),
                Expanded(flex:3,child: Text("Date",style: TextStyle(color: Colors.black),))
              ],
            ),
            Row(
              children: [
                Expanded(flex:2,child: Text("Transaction",style: TextStyle(color: Colors.grey),)),
                Expanded(flex:3,child: Text("Date",style: TextStyle(color: Colors.black),))
              ],
            ),
            Row(
              children: [
                Expanded(flex:2,child: Text("Amount",style: TextStyle(color: Colors.grey),)),
                Expanded(flex:3,child: Text("Date",style: TextStyle(color: Colors.black),))
              ],
            ),
            Row(
              children: [
                Expanded(flex:2,child: Text("Balance",style: TextStyle(color: Colors.grey),)),
                Expanded(flex:3,child: Text("Date",style: TextStyle(color: Colors.black),))
              ],
            )

          ],
        ),
      );
    });
  }
}