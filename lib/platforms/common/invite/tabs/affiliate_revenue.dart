import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/invite/tabs/widgets/affiliate_revenue_tile.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/filter/filter.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/search/search_skill.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_event.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_state.dart';
import 'package:flutter_eb/platforms/common/login/dto/transaction_model.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';

class AffiliateRevenue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LoginBloc>(context).add(FetchAffiliateTransactions(
        userId: BlocProvider
            .of<LoginBloc>(context)
            .userDTOModel
            .userId));
    return SingleChildScrollView(
        child: Container(

            child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.all(10),
                      child:Row(
                        children: [
                          Expanded(
                            flex:3,
                            child: SearchSkill(callback: (){

                            },searchPlaceholder: "Search Client",),

                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [FilterPage(callback: (){

                              },)]
                          )
                        ],
                      )), Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.75,
                    child: BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        if (state is LoadingState) {
                          return Center(child: Text("Loading"));
                        }
                        else if (state is FetchAffiliateTransactionsState) {
                          if (state.transactions.isEmpty) {
                            return NoDataFound();
                          }
                          List<String> affiliates = state.transactions.keys
                              .toList();
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.transactions.length,
                            itemBuilder: (context, int index) {
                              List<TransactionModel> transactionModel = state
                                  .transactions[affiliates[index]]!;
                              int totalCommission = _getTotalAmount(transactionModel);
                              int lastCommission=transactionModel[0].amount;
                              return AffiliateRevenueTile(
                                  totalCommission:totalCommission,
                                  lastCommission:lastCommission,
                                  affiliateName: transactionModel[0].senderName);
                            },
                            padding: const EdgeInsets.all(5.0),
                          );
                        }
                        return Center(child: Text("Error"),);
                      },
                    ),
                  )
                ]
            )));
  }

  int _getTotalAmount(List<TransactionModel> models) {
    int totalCommission = 0;
    for (TransactionModel model in models) {
      totalCommission = totalCommission + model.amount;
    }
    return totalCommission;
  }
}