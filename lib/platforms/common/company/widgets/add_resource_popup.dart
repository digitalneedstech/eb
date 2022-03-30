import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_operation/company_operaiton_event.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_operation/company_operation_bloc.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_operation/company_operation_state.dart';
import 'package:flutter_eb/platforms/common/company/model/resource_model.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/widgets/custom_text_field/custom_text_field.dart';
import 'package:flutter_eb/shared/widgets/eb_outline_button_widget/eb_outline_button_widget.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';

class AddResourcesPopup extends StatefulWidget {
  final Function callback;
  AddResourcesPopup({required this.callback});
  AddResourcesPopupState createState()=>AddResourcesPopupState();
}
class AddResourcesPopupState extends State<AddResourcesPopup>{
  
  TextEditingController _emailIdController=TextEditingController();
  List<String> emailIds=[];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Invite The Resources"),
      contentPadding: const EdgeInsets.all(0.0),
      content: BlocListener<CompanyOperationBloc,CompanyOperationState>(
        listener: (context,state){
          if(state is AddOrUpdateResourceState){
            widget.callback(state.isResourceAdded);
          }
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height*0.4,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(padding: const EdgeInsets.all(10.0),child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: "Email Id",
                      controller:_emailIdController ,

                      ),
                    ),
                    SizedBox(width: 10.0,),
                    RaisedButton(onPressed: (){
                      setState(() {
                        emailIds.add(_emailIdController.text);
                        _emailIdController.text="";
                      });

                    },child: Center(child: Text("Add",style: TextStyle(fontSize: 18.0),),),color: Colors.blue,textColor: Colors.white,)
                  ],
                )),
                SizedBox(height: 10.0,),
                Container(
                  height: MediaQuery.of(context).size.height*0.2,
                  child: ListView.builder(shrinkWrap:true,itemBuilder: (context,int index){
                    return ListTile(
                      title: Text(emailIds[index]),
                      trailing: IconButton(padding: const EdgeInsets.all(0.0),
                      icon: Icon(Icons.close),color: Colors.grey,
                      onPressed: (){
                        setState(() {
                          emailIds.remove(emailIds[index]);
                        });
                      },),
                    );
                  },itemCount: emailIds.length,),
                ),
                Divider(
                  color: Colors.grey,height: 2.0,
                )
              ],
            ),
          ),
        ),
      ),
      actions: [
        EbOutlineButtonWidget(callback: ()=>Navigator.pop(context),buttonText: "Cancel",),
        BlocBuilder<CompanyOperationBloc,CompanyOperationState>(

          builder: (context,state){
            if(state is LoadingCompanyOperationState){
              return EbRaisedButtonWidget(callback: (){},buttonText: "Invite");
            }
            else{
              List<String> companyResources=emailIds.map((e){
                return e;
              }).toList();
              return EbRaisedButtonWidget(callback: (){
                BlocProvider.of<CompanyOperationBloc>(context)
                    .add(AddResourcesEvent(companyResources: companyResources,companyId:
                BlocProvider.of<LoginBloc>(context).userDTOModel.userId,
                shareLink: BlocProvider.of<LoginBloc>(context).userDTOModel.shareLinkForCompany,
                userName: BlocProvider.of<LoginBloc>(context).userDTOModel.companyDetails.companyName));
              },buttonText: "Invite");
            }
          }
        )
      ],
    );
  }
}