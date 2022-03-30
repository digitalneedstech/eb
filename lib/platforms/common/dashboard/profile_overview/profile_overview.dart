import 'dart:convert';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_state.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/profile_overview_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/mixins/file_opertations/file_operations.dart';
import 'package:flutter_eb/shared/widgets/button_with_animation/button_with_animation.dart';
import 'package:flutter_eb/shared/widgets/custom_text_field/custom_text_field.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:flutter_eb/shared/widgets/file_upload_widget/file_upload_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileOverview extends StatefulWidget {
  ProfileOverviewState createState() => ProfileOverviewState();
}

class ProfileOverviewState extends State<ProfileOverview> with FileOperations {
  TextEditingController _profileTitleController =
      TextEditingController(text: "");
  TextEditingController _experienceController = TextEditingController(text: "");
  TextEditingController _overviewController = TextEditingController(text: "");
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late ProfileOverviewDTOModel profileOverviewDTOModel;
  late SharedPreferences _preferences;
  bool _isLoading = true;
  int _isSap = 0;
  late UserDTOModel userDTOModel;
  bool _isButtonEnabled = false;
  late int industryType;
  File imageFile=new File("");
  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  _initializePreferences() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      userDTOModel = BlocProvider.of<LoginBloc>(context).userDTOModel;
      profileOverviewDTOModel = userDTOModel.profileOverview;
      _profileTitleController = TextEditingController(
            text: userDTOModel.profileOverview.profileTitle);
        _experienceController = TextEditingController(
            text: userDTOModel.profileOverview.totalExperience);
        _overviewController =
            TextEditingController(text: userDTOModel.profileOverview.overview);
        _isSap = userDTOModel.profileOverview.isSap == true ? 1 : 0;
        industryType = userDTOModel.profileOverview.industryType;
      _isLoading = false;
    });
  }

  void dispose() {
    super.dispose();
    _overviewController.dispose();
    _experienceController.dispose();
    _profileTitleController.dispose();
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
          BlocProvider.of<LoginBloc>(context).userDTOModel=state.userDTOModel;
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
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text("Profile Overview"),
              ),
              backgroundColor: Colors.grey.shade300,
              bottomNavigationBar: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, loginState) {
                return Container(
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

                                _formKey.currentState!.save();
                                if (imageFile.path != "") {
                                  String imageUrl =
                                      await uploadImageToFirebaseAndShareDownloadUrl(
                                          imageFile,
                                          "images/portfolio_image_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}");
                                  profileOverviewDTOModel.portfolioUrl =
                                      imageUrl;
                                }
                                userDTOModel.profileOverview =
                                    profileOverviewDTOModel;
                                BlocProvider.of<ProfileBloc>(context).add(
                                    UserProfileSaveStarted(
                                        userModel: userDTOModel));
                              }
                            : (){}));
              }),
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
                          CustomTextFieldForSave(
                                (val) {
                              profileOverviewDTOModel.profileTitle =
                                  _profileTitleController.text;
                            },
                            controller: _profileTitleController,
                            labelText: "Profile Title",
                            hintText: "Ex: Sap Consultant and Trainee"
                          ),
                          getScreenWidth(context)>800 ?Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextFieldForSave(
                                      (val) {
                                    profileOverviewDTOModel.totalExperience =
                                        _experienceController.text;
                                  },
                                  controller: _experienceController,
                                  labelText: "Total Years Of Experience",
                                  hintText: "Ex: 15 years"
                              ),
                            Column(
                              children: [
                                Text("Industry"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      child: RadioListTile(
                                        value: 0,
                                        groupValue: industryType,
                                        onChanged: (val) {
                                          setState(() {
                                            industryType = 0;
                                            profileOverviewDTOModel.industryType =
                                                industryType;
                                          });
                                        },
                                        title: Text("IT"),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      child: RadioListTile(
                                        value: 1,
                                        groupValue: industryType,
                                        onChanged: (val) {
                                          setState(() {
                                            industryType = 1;
                                            profileOverviewDTOModel.industryType =
                                                industryType;
                                          });
                                        },
                                        title: Text("Non Technical"),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                industryType == 0
                                    ? Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: RadioListTile(
                                        value: 1,
                                        groupValue: _isSap,
                                        onChanged: (val) {
                                          setState(() {
                                            _isSap = 1;
                                            profileOverviewDTOModel.isSap =
                                            _isSap == 1 ? true : false;
                                          });
                                        },
                                        title: Text("SAP"),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: RadioListTile(
                                        value: 0,
                                        groupValue: _isSap,
                                        onChanged: (val) {
                                          setState(() {
                                            _isSap = 0;
                                            profileOverviewDTOModel.isSap =
                                            _isSap == 0 ? false : true;
                                          });
                                        },
                                        title: Text("Non SAP"),
                                      ),
                                    ),
                                  ],
                                )
                                    : Container(),
                              ],
                            )
                            ],
                          ):Container(),
                          getScreenWidth(context)>800 ? Container():CustomTextFieldForSave(
                                  (val) {
                                profileOverviewDTOModel.totalExperience =
                                    _experienceController.text;
                              },
                            controller: _experienceController,
                            labelText: "Total Years Of Experience",
                            hintText: "Ex: 15 years"
                          ),
                          CustomTextFieldForSave(
                                (val) {
                              profileOverviewDTOModel.overview =
                                  _overviewController.text;
                            },
                            controller: _overviewController,
                            labelText: "Overview",
                            hintText: "Highlight Your experience in brief"
                          ),
                          getScreenWidth(context)>800 ? Container():Text("Industry"),
                          getScreenWidth(context)>800 ? Container():Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: RadioListTile(
                                  value: 0,
                                  groupValue: industryType,
                                  onChanged: (val) {
                                    setState(() {
                                      industryType = 0;
                                      profileOverviewDTOModel.industryType =
                                          industryType;
                                    });
                                  },
                                  title: Text("IT"),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: RadioListTile(
                                  value: 1,
                                  groupValue: industryType,
                                  onChanged: (val) {
                                    setState(() {
                                      industryType = 1;
                                      profileOverviewDTOModel.industryType =
                                          industryType;
                                    });
                                  },
                                  title: Text("Non Technical"),
                                ),
                              ),
                            ],
                          ),
                          getScreenWidth(context)>800 ? Container():SizedBox(
                            height: 10.0,
                          ),
                          getScreenWidth(context)>800 ? Container():industryType == 0
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: RadioListTile(
                                        value: 1,
                                        groupValue: _isSap,
                                        onChanged: (val) {
                                          setState(() {
                                            _isSap = 1;
                                            profileOverviewDTOModel.isSap =
                                                _isSap == 1 ? true : false;
                                          });
                                        },
                                        title: Text("SAP"),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: RadioListTile(
                                        value: 0,
                                        groupValue: _isSap,
                                        onChanged: (val) {
                                          setState(() {
                                            _isSap = 0;
                                            profileOverviewDTOModel.isSap =
                                                _isSap == 0 ? false : true;
                                          });
                                        },
                                        title: Text("Non SAP"),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text("Upload Your Bio-data / Profile"),
                          FileUploadWidget(
                            model: profileOverviewDTOModel,
                            callback: (file) {
                              setState(() {
                                imageFile = file;
                              });
                            },
                            firstImageLoadCallback: (bool isUpdated){
                              setState(() {
                                _isButtonEnabled=true;
                              });
                            },
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
