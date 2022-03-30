import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';

UserDTOModel getUserDTOModelObject(BuildContext context){
  return BlocProvider.of<LoginBloc>(context).userDTOModel;
}

String getUserProfileType(BuildContext context){
  return BlocProvider.of<LoginBloc>(context).userProfileType;
}

double getScreenWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
}

double getScreenHeight(BuildContext context){
  return MediaQuery.of(context).size.height;
}