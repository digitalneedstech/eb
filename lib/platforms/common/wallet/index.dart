import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_event.dart';
import 'package:flutter_eb/platforms/common/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_eb/platforms/common/wallet/bloc/wallet_event.dart';
import 'package:flutter_eb/platforms/common/wallet/bloc/wallet_state.dart';
import 'package:flutter_eb/platforms/common/wallet/model/transaction_response.dart';
import 'package:flutter_eb/platforms/common/wallet/widgets/transaction_list.dart';
import 'package:flutter_eb/platforms/common/wallet/widgets/wallet_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletPage extends StatelessWidget {
  GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc,WalletState>(
      listener: (context,state){
        if(state is UpdateTransactionState){
          BlocProvider.of<LoginBloc>(context).add(UpdateUserEvent(userDTOModel: state.userDTOModel));
          SharedPreferences.getInstance().then((value){
            value.setString("user", jsonEncode(state.userDTOModel));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Details Updated."),backgroundColor: Colors.green,));
          });

        }
      },
      child: DefaultTabController(length: 2,
          initialIndex: 0,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(title: Text("Wallet"),bottom: TabBar(
                indicatorColor: Colors.blue,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.white,
                tabs: [
                  Tab(text: "My Wallet"),
                  Tab(text: "My Transactions")
                ]),
            ),
              body: TabBarView(
                children: [
                  WalletListPage(callback: (String transactionId,dynamic transactionResponse){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Processing Payment. Please Hold on."),));
                    //TODO- Wallet updation will be done by web hooks
                    /*BlocProvider.of<WalletBloc>(context).add(UpdateTransactionEvent(userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId,
                    transactionId: transactionId,transactionResponse: transactionResponse));*/

                  },),
                  TransactionsListPage()
                ],
              )),
          ),
    );
  }
}