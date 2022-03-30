import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_state.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/custom_text_field/custom_text_field.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagesWidget extends StatefulWidget {
  LanguagesWidgetState createState() => LanguagesWidgetState();
}

class LanguagesWidgetState extends State<LanguagesWidget> {
  TextEditingController _languages = TextEditingController(text: "");
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late SharedPreferences _preferences;
  late UserDTOModel userDTOModel;
  List<String> languagesChip=[];
  bool _isLoading=true;
  void initState() {
    super.initState();
    _initializePreferences();
    /*_languages.addListener(() {
      if(_languages.text.endsWith(",")){
        List<String> languages=_languages.text.split(",");
        setState(() {
          for(int i=0;i<languages.length;i++){
            if(languages[i]!=null)
              languagesChip.add(languages[i]);
          }
        });
      }
    });*/
  }

  _initializePreferences() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      userDTOModel =
          BlocProvider.of<LoginBloc>(context).userDTOModel;
      if (userDTOModel.languages.isNotEmpty) {
        var languages=userDTOModel.languages;
        String languagesSelected="";
        for(int i=0;i<languages.length;i++){
          languagesSelected=languagesSelected+languages[i]+",";
        }
        _languages = TextEditingController(text: languagesSelected);
      }
      else{
        userDTOModel.languages=[];
      }
      _isLoading = false;
    });
  }

  void dispose() {
    super.dispose();
    _languages.dispose();
  }

  Widget build(BuildContext context) {
    return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFieldForSave(
                            (val) {
                          userDTOModel.languages=[];
                          if(!val.toString().contains(",")){
                            userDTOModel.languages.add(val);
                          }
                          else {
                            var languages = val.toString().split(",");
                            for (int i = 0; i < languages.length; i++) {
                              userDTOModel.languages.add(languages[i]);
                            }
                          }

                        },
                        controller: _languages,
                        labelText: "Select Language",
                        hintText: "Eg: English,Hindi",
                        helperText: "Can Select Multiple Languages",

                      ),
                      //_getLanguageChip()
                    ],
                  ),
                );
  }

  Wrap _getLanguageChip(){
    return Wrap(children: languagesChip.map((e){
      return Chip(label: Text(e));
    }).toList());
  }
}
