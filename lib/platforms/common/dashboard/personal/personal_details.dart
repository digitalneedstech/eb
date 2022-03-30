import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_state.dart';
import 'package:flutter_eb/platforms/common/dashboard/personal/widgets/otp_verify.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/personal_details_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/mixins/file_opertations/file_operations.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/custom_text_field/custom_text_field.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:flutter_eb/shared/widgets/image_widget/image_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/assets/colors/colors.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../bloc/profile_state.dart';

class PersonalDetails extends StatefulWidget {
  PersonalDetailsState createState() => PersonalDetailsState();
}

class PersonalDetailsState extends State<PersonalDetails> with FileOperations {
  TextEditingController _firstNameController = TextEditingController(text: "");
  TextEditingController _lastNameController = TextEditingController(text: "");
  TextEditingController _emailController = TextEditingController(text: "");
  TextEditingController _mobileController = TextEditingController(text: "");
  TextEditingController _whatsAppController = TextEditingController(text: "");
  TextEditingController _countryCodeController =
      TextEditingController(text: "+91");
  TextEditingController _displayNameController =
      TextEditingController(text: "");
  TextEditingController _countryController = TextEditingController(text: "India");
  late PersonalDetailsDTOModel personalDetailsDTOModel;
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late SharedPreferences _preferences;

  late UserDTOModel userDTOModel;

  bool _isLoading = true;
  bool _copy_number_to_whatsapp = false;
  int masked = 0;

  File imageFile=new File("");

  bool _isButtonEnabled = true;
  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  _initializePreferences() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      userDTOModel = BlocProvider.of<LoginBloc>(context).userDTOModel;
      personalDetailsDTOModel = userDTOModel.personalDetails;
      _firstNameController =
            TextEditingController(text: personalDetailsDTOModel.firstName);
        _lastNameController =
            TextEditingController(text: personalDetailsDTOModel.lastName);
        _emailController =
            TextEditingController(text: personalDetailsDTOModel.email);
        _mobileController = TextEditingController(
            text: personalDetailsDTOModel.mobileData.rawPhone);
        _whatsAppController = TextEditingController(
            text: personalDetailsDTOModel.whatsAppData.rawPhone);
        _displayNameController =
            TextEditingController(text: personalDetailsDTOModel.displayName);
        _countryController =
            TextEditingController(text: personalDetailsDTOModel.country=="" ? "India":personalDetailsDTOModel.country);
        _countryCodeController = TextEditingController(
            text: personalDetailsDTOModel.mobileData.countryCode==""? "+91":personalDetailsDTOModel.mobileData.countryCode);
        masked = personalDetailsDTOModel.isMasked == true ? 1 : 0;
      _isLoading = false;
    });
  }

  void dispose() {
    super.dispose();
    _whatsAppController.dispose();
    _countryController.dispose();
    _countryCodeController.dispose();
    _displayNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
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
          BlocProvider.of<LoginBloc>(context).userDTOModel = state.userDTOModel;
          Navigator.pop(context);
        } else if (state is ExceptionState) {
          _scaffoldKey.currentState!.removeCurrentSnackBar();
          _scaffoldKey.currentState!.showSnackBar(new SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
          ));
        } else if (state is OTPSentState) {
          if (state.isSent) {
            showDialog(
                context: context,
                builder: (context) {
                  return OTPVerify(
                    mobile: _mobileController.text,
                    callback: (bool isVerified) {
                      Navigator.pop(context);
                      if (!isVerified) {
                        _scaffoldKey.currentState!.showSnackBar(SnackBar(
                          content: Text("OTP Is Not Correct."),
                          backgroundColor: Colors.red,
                        ));
                      } else {
                        personalDetailsDTOModel.mobileData.mobile =
                            _countryCodeController.text +
                                _mobileController.text;
                        personalDetailsDTOModel.mobileData.dialCode =
                            _countryCodeController.text;
                        userDTOModel.isVerified = isVerified;
                      }
                    },
                  );
                },
                barrierDismissible: false);
          } else {
            _scaffoldKey.currentState!.showSnackBar(SnackBar(
              content: Text("There was server error."),
              backgroundColor: Colors.red,
            ));
          }
        }
      },
      child: _isLoading
          ? Scaffold(
              appBar: AppBar(
                title: Text("Personal Details"),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Loading")],
                ),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                title: Text("Personal"),
              ),
              key: _scaffoldKey,
              backgroundColor: Colors.grey.shade300,
              bottomNavigationBar: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, loginState) {
                return Container(
                    width: getScreenWidth(context)>800 ? MediaQuery.of(context).size.width*0.6:
                    MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
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
                                _formKey.currentState!.save();
                                if (imageFile.path != "") {
                                  String imageUrl =
                                      await uploadImageToFirebaseAndShareDownloadUrl(
                                          imageFile,
                                          "images/profile_image_${DateTime.now().millisecondsSinceEpoch}");
                                  personalDetailsDTOModel.profilePic = imageUrl;
                                }
                                if (_copy_number_to_whatsapp) {
                                  personalDetailsDTOModel.isWhatsAppSame = true;
                                } else {
                                  personalDetailsDTOModel.isWhatsAppSame =
                                      false;
                                }
                                userDTOModel.personalDetails =
                                    personalDetailsDTOModel;
                                BlocProvider.of<ProfileBloc>(context).add(
                                    UserProfileSaveStarted(
                                        userModel: userDTOModel));
                              }
                            : (){}));
              }),
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
                          ImageUploadWidget(
                            model: personalDetailsDTOModel,
                            callback: (file) {
                              setState(() {
                                imageFile = file;
                              });
                            },
                          ),
                          getScreenWidth(context)>800 ?Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextFieldForSave(
                                    (val) {
                                  setState(() {
                                    personalDetailsDTOModel.firstName =
                                        _firstNameController.text;
                                  });
                                },
                                controller: _firstNameController,
                                labelText: "First Name",
                                hintText: "First Name",

                              ),
                              new CustomTextFieldForSave(
                                      (val) {
                                    setState(() {
                                      personalDetailsDTOModel.lastName =
                                          _lastNameController.text;
                                    });
                                  },
                                  controller: _lastNameController,
                                  labelText: "Last Name",
                                  hintText: "Last Name"
                              )
                            ],
                          ):Container(),
                          getScreenWidth(context)>800 ?Container():CustomTextFieldForSave(
                                (val) {
                              setState(() {
                                personalDetailsDTOModel.firstName =
                                    _firstNameController.text;
                              });
                            },
                            controller: _firstNameController,
                            labelText: "First Name",
                            hintText: "First Name",

                          ),
                          getScreenWidth(context)>800 ?Container():new CustomTextFieldForSave(
                                (val) {
                              setState(() {
                                personalDetailsDTOModel.lastName =
                                    _lastNameController.text;
                              });
                            },
                            controller: _lastNameController,
                            labelText: "Last Name",
                            hintText: "Last Name"
                          ),
                          getScreenWidth(context)>800 ?Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextFieldForSave(
                                      (val) {
                                    personalDetailsDTOModel.email =
                                        _emailController.text;
                                  },
                                  controller: _emailController,
                                  labelText: "Email ID",
                                  hintText: "Email ID"
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CountryCodePicker(

                                      onChanged: (CountryCode countryCode) {
                                        setState(() {
                                          _countryCodeController.text =
                                          countryCode.dialCode!;
                                        });
                                      },
                                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                      initialSelection: 'IN',
                                      favorite: ['+91', 'IN'],
                                      // optional. Shows only country name and flag
                                      showCountryOnly: false,
                                      // optional. Shows only country name and flag when popup is closed.
                                      showOnlyCountryWhenClosed: false,
                                      // optional. aligns the flag and the Text left
                                      alignLeft: false,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.70,
                                      child: CustomTextFieldForSave(
                                              (val) {
                                            personalDetailsDTOModel.mobileData
                                                .rawPhone = _mobileController.text;
                                          },
                                          controller: _mobileController,
                                          labelText: "Mobile Number",
                                          hintText: "Mobile Number"
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ):Container(),
                          getScreenWidth(context)>800 ?Container():CustomTextFieldForSave(
                                  (val) {
                                personalDetailsDTOModel.email =
                                    _emailController.text;
                              },
                              controller: _emailController,
                              labelText: "Email ID",
                              hintText: "Email ID"
                          ),
                          getScreenWidth(context)>800 ?Container():Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: CountryCodePicker(

                                  onChanged: (CountryCode countryCode) {
                                    setState(() {
                                      _countryCodeController.text =
                                      countryCode.dialCode!;
                                    });
                                  },
                                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                  initialSelection: 'IN',
                                  favorite: ['+91', 'IN'],
                                  // optional. Shows only country name and flag
                                  showCountryOnly: false,
                                  // optional. Shows only country name and flag when popup is closed.
                                  showOnlyCountryWhenClosed: false,
                                  // optional. aligns the flag and the Text left
                                  alignLeft: false,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.70,
                                  child: CustomTextFieldForSave(
                                          (val) {
                                        personalDetailsDTOModel.mobileData
                                            .rawPhone = _mobileController.text;
                                      },
                                      controller: _mobileController,
                                      labelText: "Mobile Number",
                                      hintText: "Mobile Number"
                                  ),
                                ),
                              ),

                            ],
                          ),
                          BlocBuilder<ProfileBloc, ProfileState>(
                              builder: (context, state) {
                            return InkWell(
                              onTap: state is OTPSendInProgressState
                                  ? null
                                  : () {
                                      BlocProvider.of<ProfileBloc>(context).add(
                                          MobileVerify(
                                              mobile: _countryCodeController.text+_mobileController.text));
                                    },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                color: themeColor,
                                child: Text(
                                  "Send Otp",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }),
                          CheckboxListTile(
                            value: _copy_number_to_whatsapp,
                            onChanged: (bool? val) {
                              setState(() {
                                _copy_number_to_whatsapp = val!;
                                if (val) {
                                  _whatsAppController.text =
                                      _mobileController.text;
                                } else
                                  _whatsAppController.text = "";
                              });
                            },
                            title: Text("Copy Number To whatsapp"),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CountryCodePicker(
                                  onChanged: (CountryCode countryCode) {
                                    setState(() {
                                      _countryCodeController.text =
                                          countryCode.dialCode!;
                                    });
                                  },
                                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                  initialSelection: 'IN',
                                  favorite: ['+91', 'IN'],
                                  // optional. Shows only country name and flag
                                  showCountryOnly: false,
                                  // optional. Shows only country name and flag when popup is closed.
                                  showOnlyCountryWhenClosed: false,
                                  // optional. aligns the flag and the Text left
                                  alignLeft: false,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomTextFieldForSave(
                                      (val) {
                                    personalDetailsDTOModel.whatsAppData
                                        .rawPhone = _whatsAppController.text;
                                  },
                                  controller: _whatsAppController,
                                  labelText: "WhatsApp Number",
                                  hintText: "WhatsApp Number",

                                ),
                              ),
                            ],
                          ),
                          CustomTextFieldForSave(
                                (val) {
                              personalDetailsDTOModel.displayName =
                                  _displayNameController.text;
                            },
                            controller: _displayNameController,
                            labelText: "Display Name",
                            hintText: "Display Name",

                          ),

                          Container(
                              width: MediaQuery.of(context).size.width*0.45,
                              child:
                              TextFormField(
                                controller: _countryController,
                                onTap: (){
                                  showCountryPicker(
                                    context: context,
                                    //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                                    showPhoneCode: true,
                                    onSelect: (Country country) {
                                      _countryController.text=country.name;
                                    },
                                  );
                                },
                                onSaved: (val){
                                  personalDetailsDTOModel.country=_countryController.text;
                                },
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text("Mask Profile")),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: RadioListTile(
                                  value: 1,
                                  groupValue: masked,
                                  onChanged: (val) {
                                    setState(() {
                                      masked = 1;
                                      personalDetailsDTOModel.isMasked =
                                          masked == 1 ? true : false;
                                    });
                                  },
                                  title: Text("Yes"),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: RadioListTile(
                                  value: 0,
                                  groupValue: masked,
                                  onChanged: (val) {
                                    setState(() {
                                      masked = 0;
                                      personalDetailsDTOModel.isMasked =
                                          masked == 0 ? false : true;
                                    });
                                  },
                                  title: Text("No"),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(),
                              )
                            ],
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
