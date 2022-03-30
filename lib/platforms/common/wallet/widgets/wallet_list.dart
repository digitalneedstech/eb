import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_state.dart';
import 'package:flutter_eb/platforms/common/wallet/model/transaction_model.dart';
import 'package:flutter_eb/platforms/common/wallet/model/transaction_response.dart';
import 'package:flutter_eb/platforms/common/wallet/widgets/sub_widgets/add_bank_account.dart';
import 'package:flutter_eb/platforms/common/wallet/widgets/sub_widgets/add_money.dart';
import 'package:flutter_eb/platforms/common/wallet/widgets/sub_widgets/withdraw_money.dart';

class WalletListPage extends StatelessWidget{
  Function callback;
  WalletListPage({required this.callback});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10.0),
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("My Balance"),
              Center(child: BlocBuilder<LoginBloc,LoginState>(builder: (context,state){
                if(state is LoadingState){
                  return Text("Loading",style: TextStyle(fontSize: 30.0,color: Colors.black),);
                }
                else if(state is UpdateUserState) {
                  return Text(state.userDTOModel.walletAmount.toString(),
                    style: TextStyle(fontSize: 30.0, color: Colors.black),);
                }
                return Text(BlocProvider.of<LoginBloc>(context).userDTOModel.walletAmount.toString(),
                  style: TextStyle(fontSize: 30.0, color: Colors.black),);

              },)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RaisedButton(
                    onPressed: (){
                      showDialog(context: context,
                          builder: (context){
                        return AddMoneyPopUp(callback: (String transactionId,TransactionResponse transactionResponse){
                          callback(transactionId,transactionResponse);
                        });
                          });
                    },
                    color: Colors.blue,
                    child: Center(
                      child: Text("Add Money",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  RaisedButton(
                    onPressed: (){
                      showDialog(context: context,
                          builder: (context){
                            return WithdrawMoney();
                          });
                    },
                    color: Colors.blue,
                    child: Center(
                      child: Text("Withdraw Money",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width*0.45,
                  child: Text("Linked Bank Accounts",style: TextStyle(color: Colors.grey,fontSize: 20.0),)),

              Container(
                width: MediaQuery.of(context).size.width*0.4,
                child: RaisedButton(
                  onPressed: (){
                    showDialog(context: context,
                        builder: (context){
                          return AddBankAccountPopUp();
                        });
                  },
                  color: Colors.blue,
                  child: Center(
                    child: Text("Add Account",style: TextStyle(fontSize:14.0,color: Colors.white),),
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (context,int index){
          return Container(
            color: Colors.white,
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(flex:2,child: Text("Account Name:",style: TextStyle(color: Colors.grey),)),
                    Expanded(flex:3,child: Text("Joseph",style: TextStyle(color: Colors.black),))
                  ],
                ),
                Row(
                  children: [
                    Expanded(flex:2,child: Text("Bank Name:",style: TextStyle(color: Colors.grey),)),
                    Expanded(flex:3,child: Text("Joseph",style: TextStyle(color: Colors.black),))
                  ],
                ),
                Row(
                  children: [
                    Expanded(flex:2,child: Text("IFSC:",style: TextStyle(color: Colors.grey),)),
                    Expanded(flex:3,child: Text("Joseph",style: TextStyle(color: Colors.black),))
                  ],
                ),
                Row(
                  children: [
                    Expanded(flex:2,child: Text("Valid Till:",style: TextStyle(color: Colors.grey),)),
                    Expanded(flex:3,child: Text("Joseph",style: TextStyle(color: Colors.black),))
                  ],
                ),
                Row(
                  children: [
                    Expanded(flex:2,child: Text("Status:",style: TextStyle(color: Colors.grey),)),
                    Expanded(flex:3,child: Text("Joseph",style: TextStyle(color: Colors.black),))
                  ],
                )
              ],
            ),
          );
        },)
      ],
    );
  }
}