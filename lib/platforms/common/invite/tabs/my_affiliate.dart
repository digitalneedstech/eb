import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/invite/tabs/widgets/affiliate_tile.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/filter/filter.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/search/search_skill.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_event.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_state.dart';
import 'package:flutter_eb/platforms/common/login/dto/affiliate_model/affiliate_model.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';

class MyAffiliate extends StatelessWidget{
  final Function callback;
  MyAffiliate({required this.callback});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LoginBloc>(context).add(GetAffiliatesEvent(
        senderId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId));
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
                )),
            Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    height: MediaQuery.of(context).size.height*0.75,
                    child: BlocBuilder<LoginBloc,LoginState>(
                      builder: (context,state){
                        if(state is LoadingState){
                          return Center(child: Text("Loading"));
                        }
                        else if(state is GetAffiliatesState){
                          if(state.affiliateModels.isEmpty){
                            return NoDataFound();
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount:state.affiliateModels.length,
                            itemBuilder: (context, int index) {
                              AffiliateModel affiliateModel=state.affiliateModels[index];
                              return AffiliateTile(callback:(bool isSent){
                                callback(isSent);
                              },affiliateModel:affiliateModel);
                            },
                            padding: const EdgeInsets.all(5.0),
                          );
                        }
                        return Center(child: Text("Error"),);
                      },
                    ),
                  )]
    )));
  }
}