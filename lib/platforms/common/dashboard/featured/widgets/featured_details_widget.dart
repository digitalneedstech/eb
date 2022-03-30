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

class FeaturedDetailsWidget extends StatefulWidget {
  FeaturedDetailsWidgetState createState() => FeaturedDetailsWidgetState();
}

class FeaturedDetailsWidgetState extends State<FeaturedDetailsWidget> with FileOperations {
  TextEditingController _portfolioUrl = TextEditingController(text: "");
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<FeaturedInfoDTOModel> featuredInfoDTOModelList=[];
  late FeaturedInfoDTOModel featuredInfoDTOModel;
  late File imageFile;
  late SharedPreferences _preferences;

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
    return _isLoading? Text("Loading"):Form(
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
                                callback: _isButtonEnabled
                                    ? () async {
                                  setState(() {
                                    _isButtonEnabled = false;
                                  });
                                  _formKey.currentState!.save();
                                  if (imageFile != null) {
                                    var imageName="featured_${DateTime.now().millisecondsSinceEpoch}";
                                    String imageUrl =
                                    await uploadImageToFirebaseAndShareDownloadUrl(
                                        imageFile,
                                        "images/$imageName");
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

                                }))
                      ],
                    ),
                    Text("Image/Video"),
                    Row(
                      children: [
                        Expanded(
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
                        Expanded(
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
              );
  }
}
