import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_operation/company_operaiton_event.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_operation/company_operation_bloc.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_operation/company_operation_state.dart';
import 'package:flutter_eb/platforms/common/home_nav/home_nav.dart';

class CompanyConfirmNotification extends StatelessWidget{
  final String userId,companyId;
  CompanyConfirmNotification({required this.userId,required this.companyId});
  GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<CompanyOperationBloc,CompanyOperationState>(
      listener: (context,state){
        if(state is UpdateResourceLoadingConfirmState){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Loading..")));

        }
        if(state is UpdateResourceConfirmState){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.isUpdated? "Resource is Updated":"There was some error"),
          backgroundColor: state.isUpdated ? Colors.green:Colors.red,));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>
                HomeNav(index: 0)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Confirm"),
        ),
        key: _scaffoldKey,
        body: ListTile(
          title: Text("Please accept or reject the notification"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RaisedButton(onPressed: (){
                BlocProvider.of<CompanyOperationBloc>(context)
                    .add(UpdateResourceConfirmEvent(userId: userId,companyId: companyId,status: "accepted"));
              },child: Center(child: Text("Accept"),),color: Colors.green,textColor: Colors.white,),
              RaisedButton(onPressed: (){
                BlocProvider.of<CompanyOperationBloc>(context)
                    .add(UpdateResourceConfirmEvent(userId: userId,companyId: companyId,status: "rejected"));
              },child: Center(child: Text("Reject"),),color: Colors.green,textColor: Colors.white,)
            ],
          ),
        ),

      ),
    );
  }
}