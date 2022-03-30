/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/model/query_model.dart';
class EbRangeFilter extends StatefulWidget{
  double startRange,endRange;
  final String categoryName;
  EbRangeFilter({required this.categoryName,required this.startRange,required this.endRange});
  EbRangeFilterState createState()=>EbRangeFilterState();
}
class EbRangeFilterState extends State<EbRangeFilter>{
  late QueryModel queryModel;

  @override
  Widget build(BuildContext context) {
    if(BlocProvider.of<LandingBloc>(context)
        .queryModel==null) {
      BlocProvider
          .of<LandingBloc>(context)
          .queryModel = new QueryModel(
          languages: {}, skills: {}, profileTitle: {},countries: {},experiences: {},ratings: {});
      queryModel=BlocProvider.of<LandingBloc>(context).queryModel;
    }
    else {
      queryModel = BlocProvider
          .of<LandingBloc>(context)
          .queryModel;
      switch(widget.categoryName){
        case "experience":
          if(queryModel.experiences.isNotEmpty){
            widget.startRange=queryModel.experienceStartVal.toDouble();
            widget.endRange=queryModel.experienceEndVal.toDouble();
          }
          break;
      }
    }
    // TODO: implement build
    return frs.RangeSlider(
      min: 0,
      max: widget.endRange,
      lowerValue: widget.startRange.toDouble(),
      upperValue: widget.endRange.toDouble(),
      divisions: 1,
      showValueIndicator: true,
      valueIndicatorMaxDecimals: 1,
      onChanged: (double newLowerValue, double newUpperValue) {
        setState(() {
          widget.startRange = newLowerValue;
          widget.endRange = newUpperValue;
        });
      },
      onChangeStart:
          (double startLowerValue, double startUpperValue) {
        print(
            'Started with values: $startLowerValue and $startUpperValue');
      },
      onChangeEnd: (double newLowerValue, double newUpperValue) {
        setState(() {
          widget.startRange=newLowerValue;
          widget.endRange=newUpperValue;
        });
        QueryModel queryModel;
        if(BlocProvider.of<LandingBloc>(context)
            .queryModel==null) {
          BlocProvider
              .of<LandingBloc>(context)
              .queryModel = new QueryModel(
              languages: {}, skills: {}, profileTitle: {});
          queryModel=BlocProvider.of<LandingBloc>(context).queryModel;
        }
        queryModel=BlocProvider.of<LandingBloc>(context).queryModel;
        switch(BlocProvider.of<LandingBloc>(context).selectedFilterCategory){
          case "experience":
            queryModel.experienceStartVal=newLowerValue.toInt();
            queryModel.experienceEndVal=newUpperValue.toInt();
            queryModel.experiences.add("1");
            break;
          case "rating":
            queryModel.ratingStartVal=newLowerValue;
            queryModel.ratingEndVal=newUpperValue;
            queryModel.ratings.add("1");
        }
        //BlocProvider.of<LandingBloc>(context).add(UpdateSearchListingFilterEvent(queryModel: queryModel,categoryValues: state.categoryValues));

      },
    );
  }

}

class RangeSliderData {
  double min;
  double max;
  double lowerValue;
  double upperValue;
  int divisions;
  bool showValueIndicator;
  int valueIndicatorMaxDecimals;
  bool forceValueIndicator;
  Color overlayColor;
  Color activeTrackColor;
  Color inactiveTrackColor;
  Color thumbColor;
  Color valueIndicatorColor;
  Color activeTickMarkColor;

  static const Color defaultActiveTrackColor = const Color(0xFF0175c2);
  static const Color defaultInactiveTrackColor = const Color(0x3d0175c2);
  static const Color defaultActiveTickMarkColor = const Color(0x8a0175c2);
  static const Color defaultThumbColor = const Color(0xFF0175c2);
  static const Color defaultValueIndicatorColor = const Color(0xFF0175c2);
  static const Color defaultOverlayColor = const Color(0x290175c2);

  RangeSliderData({
    this.min=0,
    this.max=5,
    this.lowerValue=0.0,
    this.upperValue=5.0,
    this.divisions=1,
    this.showValueIndicator: true,
    this.valueIndicatorMaxDecimals: 1,
    this.forceValueIndicator: false,
    this.overlayColor: defaultOverlayColor,
    this.activeTrackColor: defaultActiveTrackColor,
    this.inactiveTrackColor: defaultInactiveTrackColor,
    this.thumbColor: defaultThumbColor,
    this.valueIndicatorColor: defaultValueIndicatorColor,
    this.activeTickMarkColor: defaultActiveTickMarkColor,
  });
}*/
