import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_operation/company_operaiton_event.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_operation/company_operation_bloc.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_operation/company_operation_state.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/widgets/custom_text_field/custom_text_field.dart';
import 'package:flutter_eb/shared/widgets/eb_outline_button_widget/eb_outline_button_widget.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UpdateHoursPopup extends StatefulWidget{
  UserDTOModel resource;
  Function callBack;
  UpdateHoursPopup({required this.resource,required this.callBack});
  UpdateHoursPopupState createState()=>UpdateHoursPopupState();
}
class UpdateHoursPopupState extends State<UpdateHoursPopup>{
  TextEditingController _hourlyRatesController=TextEditingController();
  TextEditingController _minBidController=TextEditingController();
  bool _isNegotiable=true;

  late UserDTOModel companyResource;
  GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  void initState(){
    super.initState();
    companyResource=widget.resource;
    _hourlyRatesController=TextEditingController(text: widget.resource.rateDetails.hourlyRate.toString());
    _minBidController=TextEditingController(text: widget.resource.rateDetails.minBid.toString());
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<CompanyOperationBloc,CompanyOperationState>(
      listener: (context,state){
        if(state is AddOrUpdateResourceState){
          widget.callBack(state.isResourceAdded);
        }
      },
      child: AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Hourly Rates"),
            IconButton(icon: Icon(Icons.close),color: Colors.grey, onPressed: ()=>Navigator.pop(context)),

          ],
        ),
        contentPadding: const EdgeInsets.all(0.0),
        content: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height*0.6,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child:Text("Hourly Rates"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: CustomTextFieldForSave(

                        (val)=>companyResource.rateDetails.hourlyRate=int.parse(val),
                      icon: Icon(Icons.attach_money),
                      labelText: "Eg: 100",
                      controller: _hourlyRatesController,

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child:Text("Negotiable"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            value: true,
                            onChanged: (bool? val){
                              setState(() {
                                companyResource.rateDetails.negotiable=val==true;
                                _isNegotiable=!_isNegotiable;
                              });
                            },
                            title: Text("Yes"), groupValue: _isNegotiable

                          ),
                        ),
                        Expanded(child: RadioListTile<bool>(
                          groupValue: _isNegotiable,
                          value: false,
                          onChanged: (bool? val){
                            setState(() {
                              companyResource.rateDetails.negotiable=val==false;
                              _isNegotiable=!_isNegotiable;
                            });
                          },
                          title: Text("No"),

                        )),

                      ],
                    )
                  ),
                  _isNegotiable ?Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:Text("Minimum Acceptable Bid"),
                  ):Container(),
                  _isNegotiable ?Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomTextFieldForSave(
                        (val)=>companyResource.rateDetails.minBid=int.parse(val),
                        icon: Icon(Icons.attach_money),
                      labelText: "Eg: 80",
                      controller: _minBidController,

                    ),
                  ):Container(),
                  Divider(height: 2.0,color: Colors.grey,)
                ],
              ),
            ),
          ),
        ),
        actions: [
          EbOutlineButtonWidget(buttonText: "Cancel",callback: ()=>Navigator.pop(context)),
          BlocBuilder<CompanyOperationBloc,CompanyOperationState>(

              builder: (context,state){
                  VoidFutureCallBack functionToExecuteOnClick=()async{
                    if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                       BlocProvider.of<CompanyOperationBloc>(context)
                            .add(UpdateResourceEvent(
                            companyResource: companyResource));

                    }
                  };

                return EbRaisedButtonWidget(callback: functionToExecuteOnClick,buttonText: "Update");
              }
          )
        ],
      ),
    );
  }
}