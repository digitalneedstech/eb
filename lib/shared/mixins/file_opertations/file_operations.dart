import 'dart:io';

import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

mixin FileOperations {
  Future<File> downloadFile(String url) async {
    HttpClient httpClient = new HttpClient();
    // generate random number.
    var rng = new Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        await file.writeAsBytes(bytes);
      }
    } catch (ex) {
      //filePath = 'Can not fetch url';
    }

    return file;
  }

  Future<dynamic> pickImageFromGallery(ImageSource source, {bool isImage = true})async {
    XFile? filesFetched;
    if(isImage)
      filesFetched= await ImagePicker().pickImage(source: source, imageQuality: 30);
    else
      filesFetched= await ImagePicker().pickVideo(source: source);
    if(filesFetched==null)
      return Future.value("");
    else
      return Future.value(filesFetched);
  }

  Future<String> uploadImageToFirebaseAndShareDownloadUrl(
      File file, String filePath) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child(
        "images/portfolio_image_${DateTime.now().millisecondsSinceEpoch}");
    firebase_storage.TaskSnapshot uploadTask = await ref.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }



  cropImage(XFile imageFile) async {
    File croppedFile = (await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
        ? [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
        ]
        : [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        )))!;
  }
}
