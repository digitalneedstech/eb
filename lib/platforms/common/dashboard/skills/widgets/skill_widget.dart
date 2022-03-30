import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_state.dart';
import 'package:flutter_eb/platforms/common/dashboard/skills/skill_info.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/skills/skill_info_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/skills/skill_dto_model.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SkillsWidget extends StatefulWidget {
  SkillsWidgetState createState() => SkillsWidgetState();
}

class SkillsWidgetState extends State<SkillsWidget> {
  //static List<SkillInfo> itemsList = [SkillInfo(index: 0)];
  Map<int, SkillInfoDTOModel> itemModels = {
    0: new SkillInfoDTOModel(
        skill: "", achievement: "", yearsOfExperience: 0)
  };
  SkillDTOModel skills = SkillDTOModel(skills: []);
  List<SkillInfo> itemWidgetFields = [];
  late UserDTOModel userDTOModel;
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late SharedPreferences _preferences;

  bool _isLoading = true;

  bool _isButtonEnabled=true;

  void initState() {
    super.initState();
    //itemsList = [SkillInfo(index: 0)];
    _initializePreferences();
  }

  _initializePreferences() async {
    _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey("user")) {
      setState(() {
        userDTOModel =
            BlocProvider.of<LoginBloc>(context).userDTOModel;
        int length =
        userDTOModel.skills.isEmpty ? 0 : userDTOModel.skills.length;
        for (int i = 0; i < length; i++) {
          SkillInfoDTOModel model = userDTOModel.skills[i];
          /*itemsList.add(SkillInfo(
            index: i,
          ));*/
          itemModels[i] = SkillInfoDTOModel(
              skill: model.skill,
              achievement: model.achievement,
              yearsOfExperience: model.yearsOfExperience);
        }
        _initializeList();
      });
    }
  }

  _getItemWidgets() {
    setState(() {
      itemWidgetFields = [];

      for (int i = 0; i < itemModels.length; i++) {
        itemWidgetFields.add(SkillInfo(
          index: i,
          skillInfoDTOModel: itemModels[i]!,
          addSkillCallback: (newIndex) {
            setState(() {
              //itemsList.add(SkillInfo(index: newIndex));

              itemModels[newIndex] = new SkillInfoDTOModel(
                  skill: "", achievement: "", yearsOfExperience: 0);

              _getItemWidgets();
            });
          },
          removeSkillCallback: (index) {
            //itemsList.removeAt(index);
            itemModels.remove(index);
            _getItemWidgets();
          },
          onChangeCallBack: (int index,SkillInfoDTOModel skill){
            itemModels[index]=skill;
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
    return _isLoading ?Text("Loading"): Form(
                key: _formKey,
                child: Column(
                    children:
                    itemWidgetFields));
  }
}
