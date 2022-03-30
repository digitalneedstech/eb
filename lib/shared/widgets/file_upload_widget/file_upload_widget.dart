import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_eb/platforms/common/login/dto/certificate/certification_info_dto_model.dart';
import 'package:flutter_eb/shared/mixins/file_opertations/file_operations.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_state.dart';
import 'dart:io';
import 'package:flutter_eb/platforms/common/login/dto/profile_overview_dto_model.dart';
import 'package:permission_handler/permission_handler.dart';

class FileUploadWidget extends StatefulWidget {
  Function callback;
  int numOfImages;
  Function firstImageLoadCallback;
  Function? permissionCallbackError;
  dynamic model;
  dynamic profileModel;
  int index;
  FileUploadWidget(
      {this.numOfImages = 1,
        this.index=0,
      this.permissionCallbackError,
      required this.firstImageLoadCallback,
      this.model,
      required this.callback,
      this.profileModel});
  FileUploadWidgetState createState() => FileUploadWidgetState();
}

class FileUploadWidgetState extends State<FileUploadWidget>
    with FileOperations {
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _initializeExistingProductImages();
    });
  }

  _initializeExistingProductImages() async {
    if (widget.model != null) {
      ProfileOverviewDTOModel profileOverviewDTOModel =
          widget.model as ProfileOverviewDTOModel;
      if (profileOverviewDTOModel.portfolioUrl != "") {
        BlocProvider.of<ProfileBloc>(context).add(FileUpdationStarted());
        downloadFile(profileOverviewDTOModel.portfolioUrl).then((value) {
          BlocProvider.of<ProfileBloc>(context).add(FileUpdation(file: value));
          widget.firstImageLoadCallback(true);
        });
      } else {
        widget.firstImageLoadCallback(true);
        BlocProvider.of<ProfileBloc>(context)
            .add(FileUpdation(file: new File("")));
      }
    } else {
      if (widget.profileModel is CertificationInfoDTOModel) {
        CertificationInfoDTOModel model = widget.profileModel;
        if (model.fileUrl != "") {
          BlocProvider.of<ProfileBloc>(context).add(FileUpdationStarted());
          downloadFile(model.fileUrl).then((value) {
            BlocProvider.of<ProfileBloc>(context)
                .add(LicensesFileUpdation(file: value,index:widget.index ));
            widget.firstImageLoadCallback(true);
          });
        } else {
          widget.firstImageLoadCallback(true);
          BlocProvider.of<ProfileBloc>(context)
              .add(LicensesFileUpdation(file: new File(""),index:widget.index ));
        }
      }
    }
  }

  /*void dispose() {
    BlocProvider.of<ProfileBloc>(context).updateDataInFile(null);
    super.dispose();
  }*/

  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: ImagesWidget2(
          numOfImages: widget.numOfImages,
          callback: (File file) {
            widget.callback(file);
          },
          permissionCallbackError: (String error) {
            if (widget.permissionCallbackError != null) {
              widget.permissionCallbackError!(error);
            }
          },
          index: widget.index,
        ),
      ),
    );
  }
}

class ImagesWidget2 extends StatelessWidget with FileOperations {
  int numOfImages;
  Function permissionCallbackError;
  int index;
  ImagesWidget2(
      {this.numOfImages = 1,
        this.index=0,
      required this.callback,
      required this.permissionCallbackError});

  late File imageFiles;
  Function callback;

  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      width: 150,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            if (profileState is ProfilePicUpdated) {
              if (profileState.file.path != "") {
                return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(path.basename(profileState.file.path)),
                        Text("File Uploaded"),
                      ],
                    ));
              } else {
                return getFileInfo(context);
              }
            }
            if (profileState is LicenseFileUpdated) {
              if (profileState.file.path != "") {
                return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(path.basename(profileState.file.path)),
                        Text("File Uploaded"),
                      ],
                    ));
              } else {
                return getFileInfo(context);
              }
          }
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }

  Widget getFileInfo(BuildContext context) {
    return Column(
      children: [
        OutlineButton(
          onPressed: () async {
            pickFile(context);
          },
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          borderSide: BorderSide(width: 2.0, color: Colors.grey.shade400),
          child: Text("Upload File"),
          textColor: Colors.black,
        ),
        Text("No File Chosen"),
        Expanded(child: SizedBox())
      ],
    );
  }

  pickFile(BuildContext context) async {
    if (await Permission.storage.request().isGranted) {
      pickAndGetAFile(context);
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      if (statuses[Permission.storage] == PermissionStatus.granted) {
        pickAndGetAFile(context);
      } else {
        permissionCallbackError(
            "File Uploading permission was not given. Please Update Settings.");
      }
    }
  }

  pickAndGetAFile(BuildContext context) async {
    FilePickerResult? result = (await FilePicker.platform.pickFiles());
    if (result != null) {
      imageFiles = File(result.files.single.path!);
      if (imageFiles.path != "") {
        switch (path.extension(imageFiles.path)) {
          case ".doc":
          case ".pdf":
          case ".ppt":
            BlocProvider.of<ProfileBloc>(context).add(LicensesFileUpdation(
                file: imageFiles, index:index ));

            callback(imageFiles);
            break;
          default:
            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Error"),
                    content: Text("Please Upload A file of Type Doc or Pdf"),
                    actions: [
                      FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Center(
                            child: Text("Ok"),
                          ))
                    ],
                  );
                });
        }
      }
    }
  }
}
