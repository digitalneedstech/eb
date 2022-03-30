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

class SkillsPage extends StatefulWidget {
  SkillsPageState createState() => SkillsPageState();
}

class SkillsPageState extends State<SkillsPage> {
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

      for (int i = 0; i <= itemModels.length; i++) {
        if(itemModels[i]!=null) {
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
            onChangeCallBack: (int index, SkillInfoDTOModel skill) {
              itemModels[index] = skill;
            },
          ));
        }
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
                  List<String> skillsCheck = itemModels.values.map((e) => e.skill)
                      .toList();
                  if (skillsCheck.contains("")) {
                    _scaffoldKey.currentState!.showSnackBar(new SnackBar(
                      content: Text("Please Enter Skill For All"),
                      backgroundColor: Colors.red,
                    ));
                  }
                  else {
                    for (int i = 0; i < itemModels.length; i++) {
                      if(itemModels[i]!=null)
                        skills.skills.add(itemModels[i]!);
                    }
                    userDTOModel.skills = skills.skills;

                    BlocProvider.of<ProfileBloc>(context)
                        .add(UserProfileSaveStarted(userModel: userDTOModel));
                  }
                }
                :(){})),

        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Skills"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
                key: _formKey,
                child: Column(
                    children:
                        _isLoading ? [Text("Loading")] : itemWidgetFields)),
          ),
        ),
      ),
    );
  }
}
