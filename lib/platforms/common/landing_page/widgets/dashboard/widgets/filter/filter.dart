import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/filter/filter_dropdown.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/filter_search/filter_search.dart';
class FilterPage extends StatefulWidget {

  Function callback;
  bool isDropdown;
  FilterPage({this.isDropdown=true,required this.callback});
  FilterPageState createState()=>FilterPageState();
}
class FilterPageState extends State<FilterPage>{
  String filterName="All";
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        border: Border.all(color: Colors.grey,width: 1.0),
      ),
      child: Row(
        children: [
          IconButton(padding: const EdgeInsets.all(0.0),icon: Icon(Icons.filter_alt_outlined),onPressed: (){
            widget.isDropdown ?showDialog(context: context,builder: (context){
              return FilterDropDown(
                callback: (val){
                  setState(() {
                    filterName=_getSelectedFilterName(val);
                  });
                  widget.callback();

                },
              );
            }):Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FilterSearch()),
            );;
          },),
          //SizedBox(width: 10.0,),
          Text(filterName)

        ],
      ),
    );
  }

  _getSelectedFilterName(int index){
    switch(index){
      case 0:
        BlocProvider.of<LandingDashboardBloc>(context).add(
            FetchCallsMadeEvent(
              fieldTypeToBeSearched: "",
                userId: BlocProvider.of<LoginBloc>(context)
                    .userDTOModel
                    .personalDetails
                    .email));
        return "Today";
        break;
      case 1:
        BlocProvider.of<LandingDashboardBloc>(context).add(
            FetchScheduledCallsMadeEvent(
              fieldTypeToBeSearched: "",
                userId: BlocProvider.of<LoginBloc>(context)
                    .userDTOModel
                    .personalDetails
                    .email));
        return "Last 7 Days";
        break;
      case 2:
        BlocProvider.of<LandingDashboardBloc>(context).add(
            FetchBidsMadeEvent(
              fieldTypeToBeSearched: "",
                userId: BlocProvider.of<LoginBloc>(context)
                    .userDTOModel
                    .personalDetails
                    .email));
        return "Last Month";
        break;
      default:
        BlocProvider.of<LandingDashboardBloc>(context).add(
            FetchContractBidsMadeEvent(
              fieldTypeToBeSearched: "",
                userId: BlocProvider.of<LoginBloc>(context)
                    .userDTOModel
                    .personalDetails
                    .email));
        return "All";
        break;
    }
  }
}