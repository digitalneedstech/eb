import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_state.dart';
import 'package:flutter_eb/platforms/common/dashboard/experience/experience.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/experience/experience_info_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExperienceWidget extends StatefulWidget {
  ExperienceWidgetState createState() => ExperienceWidgetState();
}

class ExperienceWidgetState extends State<ExperienceWidget> {
  //static List<Experience> itemsList = [Experience(index: 0)];
  Map<int, ExperienceInfoDTOModel> itemModels = {
    0: new ExperienceInfoDTOModel(
        "", "", "", "", "", false)
  };
  List<Experience> itemWidgetFields = [];
  late UserDTOModel userDTOModel;
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late SharedPreferences _preferences;

  bool _isLoading = true;

  bool _isButtonEnabled=true;

  void initState() {
    super.initState();
    //itemsList = [Experience(index: 0)];

    _initializePreferences();
  }

  _initializePreferences() async {
    _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey("user")) {
      setState(() {
        userDTOModel =
            BlocProvider.of<LoginBloc>(context).userDTOModel;
        int length = userDTOModel.experienceDetails.isEmpty
            ? 0
            : userDTOModel.experienceDetails.length;
        for (int i = 0; i < length; i++) {
          ExperienceInfoDTOModel model = userDTOModel.experienceDetails[i];
          /*itemsList.add(Experience(
            index: i,
          ));*/
          itemModels[i] = ExperienceInfoDTOModel(
              model.company,
              model.description,
              model.designation,
              model.employmentType,
              model.location,
              model.currentlyWorking,
              startDate: model.startDate,
              endDate: model.endDate);
        }
        _initializeList();
      });
    }
  }

  _getItemWidgets() {
    setState(() {
      itemWidgetFields = [];

      for (int i = 0; i < itemModels.length; i++) {
        itemWidgetFields.add(Experience(
          index: i,
          experienceInfoDTOModel: itemModels[i]!,
          addCallback: (newIndex) {
            setState(() {
              //itemsList.add(Experience(index: newIndex));

              itemModels[newIndex] = new ExperienceInfoDTOModel(
                  "", "", "", "", "", false);

              _getItemWidgets();
            });
          },
          removeCallback: (index) {
            //itemsList.removeAt(index);
            itemModels.remove(index);
            _getItemWidgets();
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
    return _isLoading?Text("Loading"): Form(
                key: _formKey,
                child: Column(
                    children:itemWidgetFields));
  }
}
