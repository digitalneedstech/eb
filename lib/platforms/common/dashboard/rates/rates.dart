import 'dart:convert';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_state.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/rate/rate_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/widgets/custom_text_field/custom_text_field.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Rates extends StatefulWidget {
  RatesState createState() => RatesState();
}

class RatesState extends State<Rates> {
  TextEditingController _hourlyRatesController = TextEditingController();
  TextEditingController _currencyController = TextEditingController(text: "USD");
  TextEditingController _minimumAcceptableBidController =
  TextEditingController();

  bool _isNegotiable = false;
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late SharedPreferences _preferences;
  late UserDTOModel userDTOModel;
  late RateDetailsDTOModel rateDetailsDTOModel;
  bool _isLoading = true;

  bool _isButtonEnabled=true;
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
      rateDetailsDTOModel = userDTOModel.rateDetails;
      _hourlyRatesController =
            TextEditingController(text: userDTOModel.rateDetails.hourlyRate.toString());
        _currencyController =
            TextEditingController(text: userDTOModel.rateDetails.currency);
        _minimumAcceptableBidController =
            TextEditingController(text: userDTOModel.rateDetails.minBid.toString());
        _isNegotiable = userDTOModel.rateDetails.negotiable;
      _isLoading = false;
    });
  }

  void dispose() {
    super.dispose();
    _minimumAcceptableBidController.dispose();
    _hourlyRatesController.dispose();
    _currencyController.dispose();
  }

  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is LoadingState) {
          _scaffoldKey.currentState!.removeCurrentSnackBar();
          _scaffoldKey.currentState!
              .showSnackBar(new SnackBar(content: Text("Please Wait...")));
        } else if (state is SaveCompleted) {
          _preferences.setString("user", jsonEncode(state.userDTOModel));
          _scaffoldKey.currentState!.removeCurrentSnackBar();
          _scaffoldKey.currentState!.showSnackBar(
              new SnackBar(content: Text("Navigating to Profile Section...")));
          Navigator.pop(context);
        } else if (state is ExceptionState) {
          _scaffoldKey.currentState!.removeCurrentSnackBar();
          _scaffoldKey.currentState!.showSnackBar(new SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
          ));
        }
      },
      child: _isLoading
          ? Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Loading")],
          ),
        ),
      )
          : Scaffold(
        appBar: AppBar(
          title: Text("Hourly Rates"),
        ),
        key: _scaffoldKey,
        //backgroundColor: Colors.grey.shade300,
        bottomNavigationBar:Container(
            height: MediaQuery.of(context).size.height*0.1,
            padding: const EdgeInsets.all(10.0),
            color: Colors.white,
            child: EbRaisedButtonWidget(
                buttonText: "Save",
                disabledButtontext: "Processing",
                callback: _isButtonEnabled
                    ? () async {
                  setState(() {
                    _isButtonEnabled = false;
                  });
                  if(_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    userDTOModel.rateDetails = rateDetailsDTOModel;
                    BlocProvider.of<ProfileBloc>(context).add(
                        UserProfileSaveStarted(userModel: userDTOModel));
                  }
                }:(){})),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFieldForValidateAndSave(
                      (val) {
                        rateDetailsDTOModel.hourlyRate =
                            int.parse(_hourlyRatesController.text);
                      },
                      (val){
                        if(_isNegotiable && int.parse(_minimumAcceptableBidController.text)>int.parse(_hourlyRatesController.text))
                          return "Min Bid cant be more than Hourly rate";
                      },
                      controller: _hourlyRatesController,
                      labelText: "Hourly Rates",
                      inputType: TextInputType.number,
                      hintText: "Ex: '\$100/hr",

                    ),
                    TextFormField(
                      controller: _currencyController,
                      style: TextStyle(fontSize: 30.0),
                      decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        hintText: "Please enter currency"
                      ),
                      onTap:(){
                        showCurrencyPicker(
                            context: context,
                            showFlag: true,
                            showCurrencyName: true,
                            showCurrencyCode: true,
                            onSelect: (Currency currency) {
                              _currencyController.text=currency.code;
                            }
                        );
                      },
                      onSaved: (val) {
                        rateDetailsDTOModel.currency =
                            _currencyController.text;
                      },
                    ),
                    SizedBox(height: 10.0,),
                    _isNegotiable ?CustomTextFieldForValidateAndSave(
                          (val) {
                        rateDetailsDTOModel.minBid =
                            int.parse(_minimumAcceptableBidController.text);
                      },
                          (val){
                        if(_isNegotiable && int.parse(_minimumAcceptableBidController.text)>int.parse(_hourlyRatesController.text))
                          return "Min Bid cant be more than Hourly rate";
                      },
                      controller: _minimumAcceptableBidController,
                      labelText: "Minimum Acceptable Bid",
                      hintText: "Ex: '\$80",
                      inputType: TextInputType.number
                    ):Container(),
                    CheckboxListTile(
                        value: _isNegotiable,
                        title: Text("Is Negotiable"),
                        onChanged: (bool? val) {
                          setState(() {
                            _isNegotiable = val!;
                            rateDetailsDTOModel.negotiable = val;
                          });
                        })
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
