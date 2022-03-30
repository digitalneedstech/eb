import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/filter_search/filter_search.dart';
class ListingFilterPage extends StatefulWidget {

  ListingFilterPageState createState()=>ListingFilterPageState();
}
class ListingFilterPageState extends State<ListingFilterPage>{

  @override
  Widget build(BuildContext context) {
    var languageFilterCount=0;
    var skillFilterCount=0;
    var profileTitleCount=0;
    var countryCount=0;
    var experienceCount=0;
    var ratingsCount=0;
    var industryCount=0;
    if(BlocProvider.of<LandingBloc>(context).queryModel.languages.isNotEmpty)
      languageFilterCount=1;
    if(BlocProvider.of<LandingBloc>(context).queryModel.skills.isNotEmpty)
      skillFilterCount=1;
    if(BlocProvider.of<LandingBloc>(context).queryModel.profileTitle.isNotEmpty)
      profileTitleCount=1;

    if(BlocProvider.of<LandingBloc>(context).queryModel.industry.isNotEmpty)
      industryCount=1;
    if(BlocProvider.of<LandingBloc>(context).queryModel.experiences.isNotEmpty)
      experienceCount=1;
    if(BlocProvider.of<LandingBloc>(context).queryModel.ratings.isNotEmpty)
      ratingsCount=1;
    if(BlocProvider.of<LandingBloc>(context).queryModel.countries.isNotEmpty)
      countryCount=1;
    String filterName=(
      languageFilterCount+skillFilterCount+profileTitleCount+experienceCount+ratingsCount+countryCount
    ).toString();
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        border: Border.all(color: Colors.grey,width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(padding: const EdgeInsets.all(0.0),icon: Icon(Icons.filter_alt_outlined),onPressed: (){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FilterSearch()),
            );
          },),
          //SizedBox(width: 10.0,),
          Text(filterName=="0" ?"":filterName)

        ],
      ),
    );
  }
}