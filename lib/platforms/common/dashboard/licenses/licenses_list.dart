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

class LicensesList extends StatefulWidget {
  LicensesListState createState() => LicensesListState();
}

class LicensesListState extends State<LicensesList> with FileOperations {
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
  final ScrollController _controller = ScrollController();

// This is what you're looking for!
  void _scrollDown() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  void initState() {
    super.initState();
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
      child: Scaffold(
        bottomNavigationBar:Container(
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
                  userDTOModel.certificateDetails = [];
                  for (int i = 0; i < itemModels.length; i++) {
                    if (itemModels[i]!.file != null) {
                      String fileUrl =
                      await uploadImageToFirebaseAndShareDownloadUrl(
                          itemModels[i]!.file,
                          "images/license_${DateTime.now().millisecondsSinceEpoch}${path.extension(itemModels[i]!.file.path)}");
                      itemModels[i]!.fileUrl=fileUrl;
                    }
                    else {
                      itemModels[i]!.fileUrl = "";
                    }
                    userDTOModel.certificateDetails.add(itemModels[i]!);
                  }
                  BlocProvider.of<ProfileBloc>(context)
                      .add(UserProfileSaveStarted(userModel: userDTOModel));
                }:(){})),

        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Licenses"),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: getScreenWidth(context)>800 ? MediaQuery.of(context).size.width*0.6:
            MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: _isLoading
                  ? Text("Loading")
                  : ListView(controller:_controller,children: itemWidgetFields),
            ),
          ),
        ),
      ),
    );
  }
}
