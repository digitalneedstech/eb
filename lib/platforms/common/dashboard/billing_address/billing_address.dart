import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_state.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/billing_address/billing_address_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/custom_text_field/custom_text_field.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:flutter_eb/shared/widgets/eb_web_app_bar/eb_web_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/profile_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../bloc/profile_state.dart';

class BillingAddress extends StatefulWidget {
  BillingAddressState createState() => BillingAddressState();
}

class BillingAddressState extends State<BillingAddress> {
  TextEditingController _address1Controller = TextEditingController(text: "");
  TextEditingController _address2Controller = TextEditingController(text: "");
  TextEditingController _cityController = TextEditingController(text: "");
  TextEditingController _countryController = TextEditingController(text: "India");
  TextEditingController _stateController = TextEditingController(text: "");
  TextEditingController _zipCodeController = TextEditingController(text: "+91");
  TextEditingController _gstNoController =
  TextEditingController(text: "");
  late BillingAddressModel billingAddressModel;
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late SharedPreferences _preferences;

  late UserDTOModel userDTOModel;

  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  _initializePreferences() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      userDTOModel =
          BlocProvider.of<LoginBloc>(context).userDTOModel;
      billingAddressModel = userDTOModel.billingAddress;
      _address1Controller =
            TextEditingController(text: billingAddressModel.address1);
        _address2Controller =
            TextEditingController(text: billingAddressModel.address2);
        _cityController =
            TextEditingController(text: billingAddressModel.city);
        _stateController =
            TextEditingController(text: billingAddressModel.state);
        _gstNoController =
            TextEditingController(text: billingAddressModel.zipCode.toString());
        _zipCodeController =
            TextEditingController(text: billingAddressModel.gstNo);
        _countryController =
            TextEditingController(text: billingAddressModel.country=="" ?"India":billingAddressModel.country);

      _isLoading = false;
    });
  }

  void dispose() {
    super.dispose();
    _address1Controller.dispose();
    _countryController.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _gstNoController.dispose();
  }

  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is LoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Wait...")));
        } else if (state is SaveCompleted) {
          _preferences.setString("user", jsonEncode(state.userDTOModel));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Navigating to Profile Section...")));
          BlocProvider.of<LoginBloc>(context).userDTOModel=state.userDTOModel;
          Navigator.pop(context);
        } else if (state is ExceptionState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
          ));
        }
      },
      child: _isLoading
          ? Scaffold(
        appBar: AppBar(
          title: Text("Billing Address"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Loading")],
          ),
        ),
      )
          : Scaffold(
        appBar: getScreenWidth(context)>800 ?PreferredSize(
            preferredSize: Size.fromHeight(50.0), // here the desired height
            child: EbWebAppBarWidget()
        ): AppBar(
          title: Text("Personal"),
        ),
        key: _scaffoldKey,
        backgroundColor: Colors.grey.shade300,
        bottomNavigationBar:getScreenWidth(context)>800 ?Container():Container(
            height: MediaQuery.of(context).size.height*0.1,
            padding: const EdgeInsets.all(10.0),
            color: Colors.white,
            child: EbRaisedButtonWidget(
                buttonText: "Save",
                disabledButtontext: "Processing",
                callback: () async {
                  _formKey.currentState!.save();
                  userDTOModel.billingAddress = billingAddressModel;
                  BlocProvider.of<ProfileBloc>(context).add(
                      UserProfileSaveStarted(userModel: userDTOModel));
                })),

        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: getScreenWidth(context)>800 ? MediaQuery.of(context).size.width*0.6:
              MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            height: MediaQuery.of(context).size.height*0.1,
                            padding: const EdgeInsets.all(10.0),
                            color: Colors.white,
                            child: EbRaisedButtonWidget(
                                buttonText: "Save",
                                disabledButtontext: "Processing",
                                callback: () async {
                                  _formKey.currentState!.save();
                                  userDTOModel.billingAddress = billingAddressModel;
                                  BlocProvider.of<ProfileBloc>(context).add(
                                      UserProfileSaveStarted(userModel: userDTOModel));
                                }))
                      ],
                    ),
                    new CustomTextFieldForSave(
                      (val) {
                        setState(() {
                          billingAddressModel.address1 =
                              _address1Controller.text;
                        });
                      },
                      controller: _address1Controller,
                      labelText: "Address 1",
                      hintText: "Address 1",

                    ),
                    new CustomTextFieldForSave(
                      (val) {
                        setState(() {
                          billingAddressModel.address2 =
                              _address2Controller.text;
                        });
                      },
                      controller: _address2Controller,
                      labelText: "Addresss 2",
                      hintText: "Address 2",

                    ),
                    Row(
                      //crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Expanded(
                          child:
                          CustomTextFieldForSave(
                            (val) {
                              billingAddressModel.city =
                                  _cityController.text;
                            },
                            controller: _cityController,
                            labelText: "City",
                            hintText: "City",

                          ),
                        ),
                        SizedBox(width: 10.0,),
                        Expanded(
                          child:
                          CustomTextFieldForSave(
                            (val) {
                              billingAddressModel.state =
                                  _stateController.text;
                            },
                            controller: _stateController,
                            labelText: "State",
                            hintText: "State",

                          ),
                        ),

                      ],
                    ),
                    Row(
                      //crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Expanded(
                            child:
                            TextFormField(
                              controller: _countryController,
                              decoration: InputDecoration.collapsed(
                                border: InputBorder.none,
                                hintText: "Please enter country"
                              ),
                              onTap: (){
                                showCountryPicker(
                                  context: context,
                                  //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                                  showPhoneCode: true,
                                  onSelect: (Country country) {
                                    _countryController.text=country.displayName;
                                  },
                                );
                              },
                              onSaved: (val){
                                billingAddressModel.country=_countryController.text;
                              },
                            )),
                        SizedBox(width: 10.0,),
                        Expanded(
                          child:
                          CustomTextFieldForSave(
                            (val) {
                              billingAddressModel.zipCode =
                                  int.parse(_zipCodeController.text);
                            },
                            controller: _zipCodeController,
                            labelText: "Zip code",
                            inputType: TextInputType.number,
                            hintText: "Zip Code",

                          ),
                        ),

                      ],
                    ),
                    CustomTextFieldForSave(
                      (val) {
                        setState(() {
                          billingAddressModel.gstNo =
                              _gstNoController.text;
                        });
                      },
                      controller: _gstNoController,
                      labelText: "GST No",
                      hintText: "GST No",

                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
