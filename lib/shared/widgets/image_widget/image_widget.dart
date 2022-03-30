import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_state.dart';
import 'package:flutter_eb/platforms/common/login/dto/company_model/company_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/personal_details_dto_model.dart';
import 'dart:io';
import 'package:flutter_eb/shared/mixins/file_opertations/file_operations.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:flutter_eb/shared/widgets/media_select_widget/media_select_widget.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadWidget extends StatefulWidget {
  Function callback;
  int numOfImages;
  PersonalDetailsDTOModel model;
  ImageUploadWidget({this.numOfImages = 1,required  this.model, required this.callback});
  ImageUploadWidgetState createState() => ImageUploadWidgetState();
}

class ImageUploadWidgetState extends State<ImageUploadWidget>
    with FileOperations {
  void initState() {
    super.initState();
    _initializeExistingProductImages();
  }

  _initializeExistingProductImages() async {
    if (widget.model.profilePic != "") {
      downloadFile(widget.model.profilePic).then((value) {
        BlocProvider.of<ProfileBloc>(context).add(FileUpdation(file: value));
      });
    } else
      BlocProvider.of<ProfileBloc>(context).add(FileUpdation(file: new File("")));
  }

  Widget build(BuildContext context) {
    //_initializeExistingProductImages();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        //border: Border.all(color: Colors.grey.shade500),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: ImagesWidget2(callback: (File file) {
          widget.callback(file);
        }),
      ),
    );
  }
}

class ImagesWidget2 extends StatelessWidget with FileOperations {
  Function callback;
  final String title;
  ImagesWidget2({required this.callback,this.title="Upload/Change Pic"});
  late XFile imageFiles;
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(5.0),
          width: 120,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, profileState) {
            if (profileState is ProfilePicUpdated) {
              if (profileState.file.path != "") {
                return Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.file(
                    profileState.file,
                    width: 80,
                    height: 80,
                  ),
                );
              } else {
                return Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.grey.shade200),
                    child: Center(
                      child: IconButton(
                          icon: Icon(Icons.add_a_photo,
                              color: Colors.grey.shade600),
                          onPressed: () => updatePicture(context)),
                    ));
              }
            }
            if (profileState is ProfilePicUpdationInProgress) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }),
        ),
        SizedBox(
          width: 10.0,
        ),
        EbRaisedButtonWidget(
          callback: () {
            updatePicture(context);
          },
          buttonText: title,
        )
      ],
    );
  }

  updatePicture(BuildContext context) async {
    bool selectedMediaVal = await showDialog(
        context: context,
        builder: (context) {
          return MediaSelectWidget(
            callback: (int selectedMediaVal) {
              Navigator.pop(context, selectedMediaVal == 0);
            },
            mediaText1: "Gallery",
            mediaText2: "Camera",
          );
        });
    var response = await pickImageFromGallery(
        selectedMediaVal ? ImageSource.gallery : ImageSource.camera);
    if(response is XFile) {
      imageFiles=response;
      await cropImage(imageFiles);
      BlocProvider.of<ProfileBloc>(context).add(
          FileUpdation(file: new File(imageFiles.path)));
      callback(new File(imageFiles.path));
    }
  }
}


class CompanyImageUploadWidget extends StatefulWidget {
  Function callback;
  int numOfImages;
  CompanyModel model;
  CompanyImageUploadWidget({this.numOfImages = 1,required  this.model,required  this.callback});
  CompanyImageUploadWidgetState createState() => CompanyImageUploadWidgetState();
}

class CompanyImageUploadWidgetState extends State<CompanyImageUploadWidget>
    with FileOperations {
  void initState() {
    super.initState();
    _initializeExistingProductImages();
  }

  _initializeExistingProductImages() async {
    if (widget.model.companyPic != "") {
      downloadFile(widget.model.companyPic).then((value) {
        BlocProvider.of<ProfileBloc>(context).add(FileUpdation(file: File(value.path)));
      });
    } else
      BlocProvider.of<ProfileBloc>(context).add(FileUpdation(file: new File("")));
  }

  Widget build(BuildContext context) {
    //_initializeExistingProductImages();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        //border: Border.all(color: Colors.grey.shade500),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: ImagesWidget2(callback: (File file) {
          widget.callback(file);
        },title: "Upload/Change Photo",),
      ),
    );
  }
}
