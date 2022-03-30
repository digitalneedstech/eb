import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/company_model/company_model.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_state.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/mixins/file_opertations/file_operations.dart';
import 'package:flutter_eb/shared/widgets/custom_text_field/custom_text_field.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:flutter_eb/shared/widgets/image_widget/image_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CompanyProfilePage extends StatefulWidget {
  CompanyProfilePageState createState() => CompanyProfilePageState();
}

class CompanyProfilePageState extends State<CompanyProfilePage> with FileOperations {
  TextEditingController _companyNameController = TextEditingController(text: "");
  TextEditingController _companyWebsiteController = TextEditingController(text: "");
  TextEditingController _companyOverviewController = TextEditingController(text: "");
  TextEditingController _industryController = TextEditingController(text: "");
  late CompanyModel _companyModel;
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late SharedPreferences _preferences;

  late UserDTOModel userDTOModel;

  bool _isLoading = true;
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
      _companyModel = userDTOModel.companyDetails;
      _companyNameController =
            TextEditingController(text: _companyModel.companyName);
        _companyOverviewController =
            TextEditingController(text: _companyModel.web);
        _companyOverviewController =
            TextEditingController(text: _companyModel.overview);
        _industryController = TextEditingController(
            text: _companyModel.industry);

      _isLoading = false;


    });
  }

  void dispose() {
    super.dispose();
    _companyNameController.dispose();
    _companyWebsiteController.dispose();
    _companyOverviewController.dispose();
    _industryController.dispose();

  }

  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is LoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Wait...")));
        } else if (state is SaveCompleted) {
          _preferences.setString("user", jsonEncode(state.userDTOModel));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Navigating to Profile Section...")));
          BlocProvider.of<LoginBloc>(context).userDTOModel = state.userDTOModel;
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
                  height: MediaQuery.of(context).size.height * 0.1,
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: EbRaisedButtonWidget(
                      buttonText: "Save",
                      disabledButtontext: "Processing",
                      callback:_isButtonEnabled
                          ? () async {
                        setState(() {
                          _isButtonEnabled = false;
                        });
                        _formKey.currentState!.save();
                        if (imageFile.path != "") {
                          String imageUrl =
                          await uploadImageToFirebaseAndShareDownloadUrl(
                              imageFile,
                              "images/company_image_${DateTime.now().millisecondsSinceEpoch}");
                          _companyModel.companyPic = imageUrl;
                        }
                        userDTOModel.companyDetails =
                            _companyModel;
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
                    CompanyImageUploadWidget(
                      model: _companyModel,
                      callback: (file) {
                        setState(() {
                          imageFile = file;
                        });
                      },
                    ),
                    new CustomTextFieldForSave(
                      (val) {
                        setState(() {
                          _companyModel.companyName=_companyNameController.text;
                        });
                      },
                      controller: _companyNameController,
                      labelText: "Company Name",
                      hintText:"Company Name",

                    ),
                    new CustomTextFieldForSave(

                      (val) {
                        setState(() {
                          _companyModel.web=_companyWebsiteController.text;
                        });
                      },                      controller: _companyWebsiteController,
                      labelText: "Company Website",
                      hintText:"Company Website",

                    ),
                    new CustomTextFieldForSave(
                      (val) {
                        setState(() {
                          _companyModel.overview=_companyOverviewController.text;
                        });
                      },
                      controller: _companyOverviewController,
                      maxLines: 3,
                      labelText: "Company Overview",
                      hintText:"Company Overview",

                    ),
                    new CustomTextFieldForSave(

                      (val) {
                        setState(() {
                          _companyModel.industry=_industryController.text;
                        });
                      },                      controller: _industryController,
                      labelText: "Industry",
                      hintText:"Industry",

                    ),

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
