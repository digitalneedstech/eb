import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/model/query_model.dart';

class CheckBoxFilter extends StatefulWidget{
  final List<String> keys;
  final int index;
  final String categoryName;
  CheckBoxFilter({required this.categoryName,required this.keys,required this.index});
  CheckBoxFilterState createState()=>CheckBoxFilterState();
}
class CheckBoxFilterState extends State<CheckBoxFilter>{
  late QueryModel queryModel;
  bool isChecked=false;
  @override
  Widget build(BuildContext context) {
    queryModel = BlocProvider
          .of<LandingBloc>(context)
          .queryModel;
      switch(widget.categoryName){
        case "languages":
          if(queryModel.languages.contains(widget.keys[widget.index])){
            isChecked=true;
          }
          break;
        case "skills":
          if(queryModel.skills.contains(widget.keys[widget.index])){
            isChecked=true;
          }
          break;
        case "profileTitle":
          if(queryModel.profileTitle.contains(widget.keys[widget.index])){
            isChecked=true;
          }
          break;
        case "country":
          if(queryModel.countries.contains(widget.keys[widget.index])){
            isChecked=true;
          }
          break;
        case "industry":
          if(queryModel.industry.contains(widget.keys[widget.index])){
            isChecked=true;
          }
          break;
      }

    return CheckboxListTile(
        title: Text(widget.keys[widget.index]),
        value: isChecked,
        onChanged: (bool? onChange) {
          setState(() {
            isChecked=onChange!;

          });
          QueryModel queryModel;
          queryModel=BlocProvider.of<LandingBloc>(context).queryModel;
          switch(widget.categoryName){
            case "country":
              if(isChecked){
                List<String> langs=queryModel.countries.toList(growable: true);
                langs.add(widget.keys[widget.index]);
                queryModel.countries=langs.toSet();
              }
              else{
                if(queryModel.countries.contains(widget.keys[widget.index])){
                  List<String> langs=queryModel.countries.toList(growable: true);
                  langs.remove(widget.keys[widget.index]);
                  queryModel.countries=langs.toSet();
                }
              }
              break;
            case "skills":
              if(isChecked){
                List<String> langs=queryModel.skills.toList(growable: true);
                langs.add(widget.keys[widget.index]);
                queryModel.skills=langs.toSet();
              }
              else{
                if(queryModel.skills.contains(widget.keys[widget.index])){
                  List<String> langs=queryModel.skills.toList(growable: true);
                  langs.remove(widget.keys[widget.index]);
                  queryModel.skills=langs.toSet();
                }
              }
              break;
            case "languages":
              if(isChecked){
                List<String> langs=queryModel.languages.toList(growable: true);
                langs.add(widget.keys[widget.index]);
                queryModel.languages=langs.toSet();
              }
              else{
                if(queryModel.languages.contains(widget.keys[widget.index])){
                  List<String> langs=queryModel.languages.toList(growable: true);
                  langs.remove(widget.keys[widget.index]);
                  queryModel.languages=langs.toSet();
                }
              }
              break;
            case "industry":
              if(isChecked){
                List<String> industries=queryModel.industry.toList(growable: true);
                industries.add(widget.keys[widget.index]);
                queryModel.industry=industries.toSet();
              }
              else{
                if(queryModel.profileTitle.contains(widget.keys[widget.index])){
                  List<String> langs=queryModel.profileTitle.toList(growable: true);
                  langs.remove(widget.keys[widget.index]);
                  queryModel.profileTitle=langs.toSet();
                }
              }
              break;
            case "profileTitle":
              if(isChecked){
                List<String> langs=queryModel.profileTitle.toList(growable: true);
                langs.add(widget.keys[widget.index]);
                queryModel.profileTitle=langs.toSet();
              }
              else{
                if(queryModel.profileTitle.contains(widget.keys[widget.index])){
                  List<String> langs=queryModel.profileTitle.toList(growable: true);
                  langs.remove(widget.keys[widget.index]);
                  queryModel.profileTitle=langs.toSet();
                }
              }
              break;

          }
          for(String language in queryModel.languages){
            BlocProvider.of<LandingBloc>(context).selectedFilterCategoryValues[language]=true;
          }

          for(String skill in queryModel.skills){
            BlocProvider.of<LandingBloc>(context).selectedFilterCategoryValues[skill]=true;
          }

          for(String profileTitle in queryModel.profileTitle){
            BlocProvider.of<LandingBloc>(context).selectedFilterCategoryValues[profileTitle]=true;
          }

          for(String country in queryModel.countries){
            BlocProvider.of<LandingBloc>(context).selectedFilterCategoryValues[country]=true;
          }

          for(String industry in queryModel.industry){
            BlocProvider.of<LandingBloc>(context).selectedFilterCategoryValues[industry]=true;
          }
          //BlocProvider.of<LandingBloc>(context).add(UpdateSearchListingFilterEvent(queryModel: queryModel,categoryValues: state.categoryValues));


        });
  }
}