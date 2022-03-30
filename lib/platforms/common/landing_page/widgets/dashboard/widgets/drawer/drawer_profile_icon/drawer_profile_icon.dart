import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_state.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';

class DrawerProfileIconWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc,LoginState>(
      builder: (context,state){
        if(state is UpdateUserState){
          UserDTOModel userDTOModel=state.userDTOModel;
          Color color;
          switch(userDTOModel.userAvailabilityStatus){
            case "offline":
              color=Colors.grey;
              break;
            case "available":
              color=Colors.green;
              break;
            default:
              color=Colors.orange;
              break;
          }
          return Container(
            width: 20.0,
            height: 20.0,
            decoration: ShapeDecoration(
                color:color,
                shape: CircleBorder()
            ),
          );
        }
        return Container(
          width: 20.0,
          height: 20.0,
          decoration: ShapeDecoration(
              color:Colors.green,
              shape: CircleBorder()
          ),
        );
      },
    );
  }
}