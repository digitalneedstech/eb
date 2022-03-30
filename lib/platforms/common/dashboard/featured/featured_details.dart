import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_state.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/featured/featured_info_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/mixins/file_opertations/file_operations.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:flutter_eb/shared/widgets/video_upload_widget/video_upload_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeaturedDetails extends StatefulWidget {
  FeaturedDetailsState createState() => FeaturedDetailsState();
}

class FeaturedDetailsState extends State<FeaturedDetails> with FileOperations {
  TextEditingController _portfolioUrl = TextEditingController(text: "");
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<FeaturedInfoDTOModel> featuredInfoDTOModelList=[];
  late FeaturedInfoDTOModel featuredInfoDTOModel;
  late File imageFile;
  late SharedPreferences _preferences;
  bool isUploading=false;
  late UserDTOModel userDTOModel;
  bool _isLoading = true;

  late String imageType, imageName;
  int type = 0;
  String selectedMediaType="Image";

  bool _isButtonEnabled=true;
  @override
  void initState() {
    super.initState();
    featuredInfoDTOModel=new FeaturedInfoDTOModel(
      name: "",fileUrl: "",fileType: "",docUrl: ""
    );
    _initializePreferences();
  }

  _initializePreferences() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      userDTOModel =
          BlocProvider.of<LoginBloc>(context).userDTOModel;
      _isLoading = false;
    });
  }

  void dispose() {
    super.dispose();
    _portfolioUrl.dispose();
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
                title: Text("Featured"),
              ),
              backgroundColor: Colors.white,
        bottomNavigationBar:Container(
            height: MediaQuery.of(context).size.height*0.1,
            padding: const EdgeInsets.all(10.0),
            color: Colors.white,
            child: EbRaisedButtonWidget(
                buttonText: _isButtonEnabled ?"Save":"Uploading",
                disabledButtontext: "Processing",
                callback: _isButtonEnabled
                    ? () async {
                  setState(() {
                    _isButtonEnabled = false;
                  });
                  _formKey.currentState!.save();
                  if (imageFile != null) {
                    isUploading=true;
                    var imageName="featured_${DateTime.now().millisecondsSinceEpoch}";
                    String imageUrl =
                    await uploadImageToFirebaseAndShareDownloadUrl(
                        imageFile,
                        "${getUserDTOModelObject(context).userId}/featured/$imageName");
                    featuredInfoDTOModel.name=imageName;
                    featuredInfoDTOModel.fileUrl=imageUrl;
                    featuredInfoDTOModel.docUrl=imageUrl;
                    featuredInfoDTOModel.fileType=imageType;
                    featuredInfoDTOModelList.add(featuredInfoDTOModel);
                  }
                  userDTOModel.featuredDetails = featuredInfoDTOModelList;
                  BlocProvider.of<ProfileBloc>(context).add(
                      UserProfileSaveStarted(userModel: userDTOModel));
                }:(){

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
                          Text("Image/Video"),
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: RadioListTile(
                                  value: 0,
                                  groupValue: type,
                                  onChanged: (int? val) {
                                    setState(() {
                                      type = val!;
                                      selectedMediaType="Image";
                                      BlocProvider.of<ProfileBloc>(context)
                                          .add(FileUpdation(file: new File("")));
                                    });
                                  },
                                  title: Text("Image"),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: RadioListTile(
                                  value: 1,
                                  groupValue: type,
                                  onChanged: (int? val) {
                                    setState(() {
                                      type = val!;
                                      selectedMediaType="Video";
                                      BlocProvider.of<ProfileBloc>(context)
                                          .add(FileUpdation(file: new File("")));
                                    });
                                  },
                                  title: Text("Video"),
                                ),
                              )
                            ],
                          ),
                          Text("Please Upload A file of Type MP4 or Mp3"),
                          new VideoUploadWidget(
                            model: featuredInfoDTOModel,
                            mediaType: selectedMediaType,
                            callback: (File file, String filePath,
                                String fileType) async {
                              setState(() {
                                imageFile = file;
                                imageName = filePath;
                                imageType = fileType;
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
