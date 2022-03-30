import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/model/query_model.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/filter_search/check_box_filter.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/filter_search/range_filter/eb_range_filter.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/listing_page.dart';
import 'package:flutter_eb/shared/widgets/loading_shimmer/loading_shimmer.dart';

class FilterSearch extends StatefulWidget {
  FilterSearchState createState()=>FilterSearchState();
}
class FilterSearchState extends State<FilterSearch>{
  Map<String,String> categoriesMap={
    "languages":"string",
    "skills":"string",
    "profileTitle":"string",
    "country":"countryDropdown",
    "industry":"string"
  };
  Map<String,bool> selectedFilterCategoryValues={};
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LandingBloc>(context)
        .add(LoadSearchFilterValuesEvent(categoryName: "languages",categoryType: "string"));
    return BlocListener<LandingBloc,LandingState>(
      listener: (context,state){
        if(state is ClearSearchListingFilterState){
          BlocProvider.of<LandingBloc>(context)
              .add(LoadSearchFilterValuesEvent(categoryName: "languages",categoryType: "string"));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back),
          onPressed: ()=>Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ListingPage(isFreelancerAdditionEnabled: false)))),
          title: Center(
            child: Text("Filters"),
          ),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ListingPage(isFreelancerAdditionEnabled: false)));
                  },
                  child: Text("Submit",style: TextStyle(color: Colors.blue),),
                )
              ],
            ),
            SizedBox(width: 5.0,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    BlocProvider.of<LandingBloc>(context)
                        .add(ClearSearchListingFilterEvent());
                  },
                  child: Text("Clear",style: TextStyle(color: Colors.blue),),
                )
              ],
            )
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, int index) {
                      List<String> categories=categoriesMap.keys.toList();
                      String value=categoriesMap[categories[index]]!;
                      return ListTile(
                        onTap: () {
                          BlocProvider.of<LandingBloc>(context).add(
                              LoadSearchFilterValuesEvent(
                                  categoryName: categories[index],categoryType: value));
                        },
                        title: Text(categories[index]),
                      );
                    },
                    itemCount: categoriesMap.keys.length),
              ),
              Expanded(
                flex: 3,
                child: BlocBuilder<LandingBloc, LandingState>(builder: (context, state) {
                  if (state is LoadSearchFilterValuesState) {
                    if(state.categoryType=="range"){
                      return Container();/*
                      if(state.categoryName=="experience")
                        return EbRangeFilter(categoryName: state.categoryName,
                            startRange: 0,endRange: 50);
                      else if(state.categoryName=="rating")
                        return EbRangeFilter(categoryName: state.categoryName,
                            startRange: 0.0,endRange: 5.0);*/
                    }
                    else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, int index) {
                          List<String> keys = state.categoryValues.keys
                              .toList();
                          switch (state.categoryType) {
                            case "string":
                            case "countryDropdown":
                              return CheckBoxFilter(index: index,
                                  categoryName: state.categoryName,
                                  keys: keys);
                            default:
                              return Container();
                          }
                        },
                        itemCount: state.categoryValues.length,
                      );
                    }
                  }
                  return LoadingShimmerWidget();
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
