import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_state.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/post_bloc.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/post_event.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/post_state.dart';
import 'package:flutter_eb/platforms/common/posts/model/post.dart';
import 'package:flutter_eb/shared/widgets/custom_text_field/custom_text_field.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
class AddPostButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: () {
          showDialog(context: context,builder: (context){
            return AddPostsDialog();
          });
        },
        child: Center(
          child: Text("Add Post"),
        ));
  }
}

class AddPostsDialog extends StatefulWidget{
  AddPostsDialogState createState()=>AddPostsDialogState();
}
class AddPostsDialogState extends State<AddPostsDialog>{
  TextEditingController _titleController=TextEditingController();
  TextEditingController _industryController=TextEditingController();
  TextEditingController _skillsController=TextEditingController();
  TextEditingController _tenureController=TextEditingController();
  TextEditingController _infoController=TextEditingController();
  GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  PostModel postModel=new PostModel();
  List<String> skillsSelected=[];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("Add Post"),),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.70,
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFieldForValidateAndSave(

                    (val)=>postModel.title=_titleController.text,
                        (val){
                      if(val=="")
                        return "Please Enter Value";
                      return null;
                    },
                    controller: _titleController,
                    labelText: "Title",

                  ),
                  CustomTextFieldForValidateAndSave(
                        (val)=>postModel.industry=_industryController.text,
                    (val){
                      if(val=="")
                        return "Please Enter Value";
                      return null;
                    },

                    controller: _industryController,
                    labelText: "Industry",

                  ),
                  Row(
                    //crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Expanded(
                        child: CustomTextField(

                          controller: _skillsController,
                          labelText: "Skills Required",

                        ),
                      ),
                      SizedBox(width: 10.0,),
                      EbRaisedButtonWidget(buttonText: "Add",callback: (){
                        if(_skillsController.text!="") {
                          setState(() {
                            skillsSelected.add(_skillsController.text);
                            _skillsController.text = "";
                          });
                        }
                      },)
                    ],
                  ),
                  skillsSelected.isEmpty ?Container():Row(children: skillsSelected.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 5.0),
                    child: Text(e),
                  )).toList()),
                  CustomTextFieldForSave(
                    (val)=>postModel.tenure=_tenureController.text,
                    controller: _tenureController,
                    labelText: "Tenure",

                  ),
                  CustomTextFieldForSave(
                    (val)=>postModel.info=_infoController.text,
                    controller: _infoController,
                    labelText: "Additional Info",

                  )
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        BlocBuilder<PostBloc,PostState>(
            builder: (context,state){
              if(state is LoadingGroupState){
                return RaisedButton(onPressed: null
                  ,color: Colors.blue,textColor: Colors.white,child: Text("Loading"),);
              }
              else{
                return RaisedButton(onPressed:(){
                  if(_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    UserDTOModel userDTOModel = BlocProvider
                        .of<LoginBloc>(context)
                        .userDTOModel;
                    postModel.postedBy=userDTOModel.userId;
                    postModel.skills=skillsSelected;
                    BlocProvider.of<PostBloc>(context).add(
                        CreatePostEvent(postModel: postModel));
                    Navigator.pop(context);
                  }
                },color: Colors.blue,textColor: Colors.white,child: Text("Add"),);
              }
            }),
    RaisedButton(onPressed:(){

    Navigator.pop(context);

    },color: Colors.white,textColor: Colors.black,child: Text("Cancel"),)
      ],
    );
  }
}