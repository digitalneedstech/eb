import 'dart:convert';

import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_state.dart';
import 'package:flutter_eb/platforms/common/dashboard/licenses/licenses.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/certificate/certification_info_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/mixins/file_opertations/file_operations.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LicensesWidget extends StatefulWidget {
  LicensesWidgetState createState() => LicensesWidgetState();
}

class LicensesWidgetState extends State<LicensesWidget> with FileOperations {
  //static List<LicensesPage> itemsList = [LicensesPage(index: 0)];
  Map<int, CertificationInfoDTOModel>  itemModels = {
    0: new CertificationInfoDTOModel(
        name: "", credentialId: "", credentialUrl: "", organization: "")
  };
  List<LicensesPage> itemWidgetFields = [];
  late UserDTOModel userDTOModel;
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late SharedPreferences _preferences;

  bool _isLoading = true;

  bool _isButtonEnabled=false;

  void initState() {
    super.initState();
    //itemsList = [LicensesPage(index: 0)];

    _initializePreferences();
  }

  _initializePreferences() async {
    _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey("user")) {
      setState(() {
        userDTOModel =
            BlocProvider.of<LoginBloc>(context).userDTOModel;
        int length = userDTOModel.certificateDetails.isEmpty
            ? 0
            : userDTOModel.certificateDetails.length;
        for (int i = 0; i < length; i++) {
          CertificationInfoDTOModel model = userDTOModel.certificateDetails[i];
          /*itemsList.add(LicensesPage(
            index: i,
          ));*/
          itemModels[i] = new CertificationInfoDTOModel(
              name: model.name,
              fileUrl: model.fileUrl,
              credentialId: model.credentialId,
              credentialUrl: model.credentialUrl,
              organization: model.organization);
        }
        _initializeList();
      });
    }
  }

  _getItemWidgets() {
    setState(() {
      itemWidgetFields = [];

      for (int i = 0; i < itemModels.length; i++) {
        itemWidgetFields.add(LicensesPage(
          index: i,
          licenseModel: itemModels[i]!,
          addCallback: (newIndex) {
            setState(() {
              //itemsList.add(LicensesPage(index: newIndex));
              itemModels[newIndex] = new CertificationInfoDTOModel(
                  name: "",
                  credentialId: "",
                  credentialUrl: "",
                  organization: "");

              _getItemWidgets();
            });
          },
          removeCallback: (index) {
            if(index==0){
              _scaffoldKey.currentState!.
              showSnackBar(SnackBar(content: Text("At least One License will be there"),));
            }else {
              //itemsList.removeAt(index);
              itemModels.remove(index);
              _getItemWidgets();
            }
          },
          addFirstTimeLoadCallback: (){
            setState(() {
              _isButtonEnabled=true;
            });
          },
        ));
      }
    });
  }

  void dispose() {
    super.dispose();
  }

  _initializeList() {
    setState(() {
      _getItemWidgets();
      _isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    return _isLoading ?Text("Loading"):Form(
              key: _formKey,
              child: Column(children: itemWidgetFields),
            );
  }
}
