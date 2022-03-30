import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_state.dart';
import 'package:flutter_eb/shared/widgets/media_select_widget/media_select_widget.dart';
import 'package:flutter_eb/shared/widgets/video_upload_widget/video_item.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter_eb/platforms/common/login/dto/featured/featured_info_dto_model.dart';
import 'package:flutter_eb/shared/mixins/file_opertations/file_operations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoUploadWidget extends StatefulWidget {
  Function callback;
  int numOfImages;
  String mediaType;
  FeaturedInfoDTOModel model;
  VideoUploadWidget(
      {this.numOfImages = 1, required this.model,required  this.callback,required  this.mediaType});
  VideoUploadWidgetState createState() => VideoUploadWidgetState(
    callback: callback,mediaType: mediaType,model: model,numOfImages: numOfImages
  );
}

class VideoUploadWidgetState extends State<VideoUploadWidget>
    with FileOperations {
  Function callback;
  int numOfImages;
  String mediaType;
  FeaturedInfoDTOModel model;
  VideoUploadWidgetState(
      {this.numOfImages = 1,required  this.model,required  this.callback,required  this.mediaType});
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _initializeExistingProductImages();
    });
  }

  _initializeExistingProductImages() async {
    if (widget.model.fileUrl!="") {
      downloadFile(widget.model.fileUrl).then((value) {
        BlocProvider.of<ProfileBloc>(context).add(FileUpdation(
            file: value,
            type: widget.model.fileType == ".mp4" ? "Video" : "Image"));
      });
    } else {
      BlocProvider.of<ProfileBloc>(context).add(FileUpdation(file: new File("")));
    }
  }

  /*void dispose() {
    BlocProvider.of<ProfileBloc>(context).updateDataInFile(null);
    super.dispose();
  }*/

  Widget build(BuildContext context) {
    var mtype=widget.mediaType;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: VideoWidget(
          type: mtype,
          callback: (XFile file) {
            widget.callback(
                new File(file.path), path.basename(file.path), path.extension(file.path));
          },
        ),
      ),
    );
  }
}
class VideoWidget extends StatefulWidget{
  Function callback;
  String type;
  VideoWidget({required this.callback,required  this.type});
  VideoWidgetState createState()=>VideoWidgetState();
}
class VideoWidgetState extends State<VideoWidget> with FileOperations {
  late XFile imageFile;
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
      if (profileState is LoadingState) {
        return Container(
          margin: const EdgeInsets.all(5.0),
          width: 500,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Text("Loading"),
          ),
        );
      } else {
        return Container(
            margin: const EdgeInsets.all(5.0),
            width: 500,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child:
                profileState is ProfilePicUpdated && profileState.file.path != ""
                    ? profileState.type == "Image"
                        ? Container(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Image.file(
                              profileState.file,
                              width: 200,
                              height: 80,
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: VideoItems(
                              videoPlayerController:
                                  VideoPlayerController.file(profileState.file),
                              autoplay: false,
                              looping: true,
                            ))
                    : Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Colors.grey.shade200),
                        child: Center(
                          child: IconButton(
                              icon: Icon(Icons.add_a_photo,
                                  color: Colors.grey.shade600),
                              onPressed: () async {
                                bool selectedMediaVal=await showDialog(context: context,builder: (context){
                                  return MediaSelectWidget(callback: (int selectedMediaVal){
                                    Navigator.pop(context,selectedMediaVal==0);
                                  },mediaText1: "Gallery",mediaText2: "Camera",);
                                });
                                var response = await pickImageFromGallery(selectedMediaVal ? ImageSource.gallery:
                                ImageSource.camera,isImage: widget.type == "Image" ? true : false);
                                if(response is XFile) {
                                  imageFile=response;
                                  if(((path.extension(imageFile.path) !=
                                      ".jpg" && path.extension(imageFile.path) !=
                                      ".jpeg")&&
                                      widget.type == "Image"))
                                    {
                                      return showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Error"),
                                              content: Text(
                                                  "Please Upload A file of Type JPG"),
                                              actions: [
                                                FlatButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Center(
                                                      child: Text("Ok"),
                                                    ))
                                              ],
                                            );
                                          });
                                    }
                                  else if ((path.extension(imageFile.path) !=
                                      ".mp4" &&
                                      widget.type == "Video" )
                                  ) {
                                    return showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Error"),
                                            content: Text(
                                                "Please Upload A file of Type MP4 or Mp3"),
                                            actions: [
                                              FlatButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Center(
                                                    child: Text("Ok"),
                                                  ))
                                            ],
                                          );
                                        });
                                  }
    /*if ((path.extension(imageFile.path) ==
    ".mp4" &&
    widget.type == "Video" )
    ) {
                                    int sizeInBytes = new File(imageFile.path).lengthSync();
                                    double sizeInMb = sizeInBytes / (1024 * 1024);
                                    return showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Error"),
                                            content: Text(
                                                "Please Upload A file of Type MP4 or Mp3"),
                                            actions: [
                                              FlatButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Center(
                                                    child: Text("Ok"),
                                                  ))
                                            ],
                                          );
                                        });
                                  }*/

                                  BlocProvider.of<ProfileBloc>(context).add(
                                      FileUpdation(
                                          file: new File(imageFile.path), type: widget.type));
                                  widget.callback(imageFile);
                                }

                              }),
                        )));
      }
    });
  }
}
/*


class CompanyVideoUploadWidget extends StatefulWidget {
  Function callback;
  int numOfImages;
  String type;
  CompanyModel model;
  CompanyVideoUploadWidget(
      {this.numOfImages = 1, this.model, this.callback, this.type});
  CompanyVideoUploadWidgetState createState() => CompanyVideoUploadWidgetState();
}

class CompanyVideoUploadWidgetState extends State<CompanyVideoUploadWidget>
    with FileOperations {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeExistingProductImages();
    });
  }

  _initializeExistingProductImages() async {
    if (widget.model != null && widget.model.fileUrl != null) {
      downloadFile(widget.model.fileUrl).then((value) {
        BlocProvider.of<ProfileBloc>(context).add(FileUpdation(
            file: value,
            type: widget.model.fileType == ".mp4" ? "Video" : "Image"));
      });
    } else {
      BlocProvider.of<ProfileBloc>(context).add(FileUpdation(file: null));
    }
  }

  */
/*void dispose() {
    BlocProvider.of<ProfileBloc>(context).updateDataInFile(null);
    super.dispose();
  }*//*


  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: VideoWidget(
          type: widget.type,
          callback: (File file) {
            widget.callback(
                file, path.basename(file.path), path.extension(file.path));
          },
        ),
      ),
    );
  }
}

*/
