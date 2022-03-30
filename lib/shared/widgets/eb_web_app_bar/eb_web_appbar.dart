import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_event.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/constants/routes.dart';
import 'package:flutter_eb/shared/services/router/routers.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/eb_circle_avatar/eb_circle_avatar.dart';

class EbWebAppBarWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle=TextStyle(color: Colors.white);
    return Container(
      color: Color(0xFF23374D),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width*0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Hanatech",style: textStyle,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Home",style: textStyle,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Our Services",style: textStyle,),
                  ),
                  InkWell(
                    onTap: (){
                      UserDTOModel userDTOModel =
                          BlocProvider.of<LoginBloc>(context).userDTOModel;
                      userDTOModel.personalDetails.type = Constants.VENDOR;
                      BlocProvider.of<LoginBloc>(context)
                          .add(UpdateUserEvent(userDTOModel: userDTOModel));
                      BlocProvider.of<LoginBloc>(context)
                          .loginRepository
                          .addorUpdateRecord(userDTOModel);
                      Navigator.pushNamed(context, Routers.DASHBOARD);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Become A Freelancer",style: textStyle,),
                    ),
                  ), 
                ],
              ),
              /*Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.bookmark,color: Colors.white,),
                  ),  
                  *//*InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, Routes.DASHBOARD);
                    },
                    child: Padding(padding: const EdgeInsets.all(10.0),
                    child: EbCircleAvatarWidget(
                      profileImageUrl: getUserDTOModelObject(context).personalDetails.profilePic,
                      radius: 10.0,
                    )),
                  )*//*
                ],
              )*/
              
            ],
          ),
        ),
      )
    );
  }
}