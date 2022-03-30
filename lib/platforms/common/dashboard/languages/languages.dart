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

class Languages extends StatefulWidget {
  LanguagesState createState() => LanguagesState();
}

class LanguagesState extends State<Languages> {
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
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is LoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Wait...")));
        } else if (state is SaveCompleted) {
          _preferences.setString("user", jsonEncode(state.userDTOModel));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Navigating to Profile Section...")));
          BlocProvider.of<LoginBloc>(context).userDTOModel=state.userDTOModel;
          Navigator.pop(context);
        } else if (state is ExceptionState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red,
          ));
        }
      },
      child: _isLoading
          ? Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Loading")],
                ),
              ),
            )
          : Scaffold(
              backgroundColor: Colors.white,
              key: _scaffoldKey,
          bottomNavigationBar:Container(
              height: MediaQuery.of(context).size.height*0.1,
              padding: const EdgeInsets.all(10.0),
              color: Colors.white,
              child: EbRaisedButtonWidget(
                  buttonText: "Save",
                  disabledButtontext: "Processing",
                  callback: () async {
                    _formKey.currentState!.save();
                    BlocProvider.of<ProfileBloc>(context).add(
                        UserProfileSaveStarted(userModel: userDTOModel));
                  })),

              appBar: AppBar(
                title: Text("Languages"),
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: getScreenWidth(context)>800 ? MediaQuery.of(context).size.width*0.6:
                    MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Form(
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
                    ),
                  ),
                ),
              )),
    );
  }

  Wrap _getLanguageChip(){
    return Wrap(children: languagesChip.map((e){
      return Chip(label: Text(e));
    }).toList());
  }
}
