import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/login/dto/skills/skill_info_dto_model.dart';
import 'package:flutter_eb/shared/widgets/custom_text_field/custom_text_field.dart';

class SkillInfo extends StatefulWidget {
  SkillInfoDTOModel skillInfoDTOModel;
  int index;
  Function removeSkillCallback, addSkillCallback,onChangeCallBack;
  SkillInfo(
      {required this.skillInfoDTOModel,
      required this.index,
      required this.removeSkillCallback,
      required this.addSkillCallback,required this.onChangeCallBack});
  SkillInfoState createState() => SkillInfoState();
}

class SkillInfoState extends State<SkillInfo> {
  TextEditingController _skillAchievement = TextEditingController(text: "");
  TextEditingController _skill = TextEditingController(text: "");
  TextEditingController _yearsOfExperience = TextEditingController(text: "");
  void initState() {
    super.initState();
    _skillAchievement =
        TextEditingController(text: widget.skillInfoDTOModel.achievement);
    _skill = TextEditingController(text: widget.skillInfoDTOModel.skill);
    _yearsOfExperience=TextEditingController(text: widget.skillInfoDTOModel.yearsOfExperience.toString());
  }

  void dispose() {
    super.dispose();
    _skill.dispose();
    _skillAchievement.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        CustomTextFieldForValidateAndSave(
              (val) {
            widget.skillInfoDTOModel.skill = _skill.text;
          },
          (val){
            if(_skill.text.toString().trim()=="")
              return "Please Enter Skill Name";
            return null;
          },
          onChangeCallBack: (val){
                widget.skillInfoDTOModel.skill=_skill.text.toString();
                widget.onChangeCallBack(widget.index,widget.skillInfoDTOModel);
          },
          controller: _skill,
          labelText: "Skills",
          hintText: "Skills",

        ),
        CustomTextFieldForSave(
              (val) {
            widget.skillInfoDTOModel.yearsOfExperience = int.parse(_yearsOfExperience.text);
          },
          controller: _yearsOfExperience,
          inputType: TextInputType.number,
          labelText: "Experience in Years",
          hintText: "Experience in Years",

          onChangeCallBack: (val){
            widget.skillInfoDTOModel.yearsOfExperience=int.parse(_yearsOfExperience.text.toString());
            widget.onChangeCallBack(widget.index,widget.skillInfoDTOModel);
          },
        ),
        CustomTextFieldForSave(
              (val) {
            widget.skillInfoDTOModel.achievement = _skillAchievement.text;
          },
          controller: _skillAchievement,
          labelText: "Achievements / Experience in this Skill",
          hintText: "Achievements / Experience in this Skill",
          onChangeCallBack: (val){
            widget.skillInfoDTOModel.achievement=_skillAchievement.text;
            widget.onChangeCallBack(widget.index,widget.skillInfoDTOModel);
          },
        ),
        Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.red,
                  onPressed: () {
                    widget.removeSkillCallback(widget.index);
                  },
                  label: Text(
                    "Remove Skill",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    int index = widget.index + 1;
                    widget.addSkillCallback(index);
                  },
                  label: Text(
                    "New Skill",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
