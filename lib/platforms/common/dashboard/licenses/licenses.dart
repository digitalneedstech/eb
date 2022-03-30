import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/login/dto/certificate/certification_info_dto_model.dart';
import 'package:flutter_eb/shared/widgets/custom_text_field/custom_text_field.dart';
import 'package:flutter_eb/shared/widgets/file_upload_widget/file_upload_widget.dart';

class LicensesPage extends StatefulWidget {
  int index;
  CertificationInfoDTOModel licenseModel;
  Function addCallback, removeCallback;
  Function addFirstTimeLoadCallback;
  LicensesPage(
      {required this.licenseModel,
      required this.addFirstTimeLoadCallback,
      required this.addCallback,
      required this.removeCallback,
      required this.index});
  LicensesPageState createState() => LicensesPageState();
}

class LicensesPageState extends State<LicensesPage> {
  TextEditingController _nameController = TextEditingController(text: "");
  TextEditingController _issuingOrganizationController =
      TextEditingController(text: "");
  TextEditingController _certificateIdController =
      TextEditingController(text: "");
  TextEditingController _certificateUrlController =
      TextEditingController(text: "");

  CertificationInfoDTOModel certificationInfoDTOModel =
      new CertificationInfoDTOModel(
          name: "", credentialId: "", credentialUrl: "", organization: "");

  late File imageFile;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  _initializePreferences() async {
    setState(() {
      _nameController = TextEditingController(text: widget.licenseModel.name);
      _issuingOrganizationController =
          TextEditingController(text: widget.licenseModel.organization);
      _certificateIdController =
          TextEditingController(text: widget.licenseModel.credentialId);
      _certificateUrlController =
          TextEditingController(text: widget.licenseModel.credentialUrl);
    });
  }

  void dispose() {
    super.dispose();
    _certificateUrlController.dispose();
    _certificateIdController.dispose();
    _issuingOrganizationController.dispose();
    _nameController.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        CustomTextFieldForSave((val) {
          widget.licenseModel.name = _nameController.text;
        },
            controller: _nameController,
            labelText: "Name",
            hintText: "Ex: SAP Ariba Procurement"),
        CustomTextFieldForSave(
          (val) {
            widget.licenseModel.organization =
                _issuingOrganizationController.text;
          },
          controller: _issuingOrganizationController,
          labelText: "Issuing Organization",
          hintText: "Enter Name",
        ),
        CustomTextFieldForSave(
          (val) {
            widget.licenseModel.credentialId = _certificateIdController.text;
          },
          controller: _certificateIdController,
          labelText: "Certificate ID",
          hintText: "-",
        ),
        CustomTextFieldForSave(
          (val) {
            widget.licenseModel.credentialUrl = _certificateUrlController.text;
          },
          controller: _certificateUrlController,
          labelText: "Certificate URL",
          hintText: "-",
        ),
        Text("Upload Your Certificate"),
        FileUploadWidget(
          index: widget.index,
          profileModel: widget.licenseModel,
          permissionCallbackError: (String errorMessage){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage),backgroundColor: Colors.red,));
          },
          callback: (file) {
            setState(() {
              imageFile = file;
              widget.licenseModel.file = file;
            });
          },
          firstImageLoadCallback: (bool isUpdated) {
            widget.addFirstTimeLoadCallback();
          },
        ),
        Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.red,
                  onPressed: () {
                    widget.removeCallback(widget.index);
                  },
                  label: Text(
                    "Remove License",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    int index = widget.index + 1;
                    widget.addCallback(index);
                  },
                  label: Text(
                    "New License",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
