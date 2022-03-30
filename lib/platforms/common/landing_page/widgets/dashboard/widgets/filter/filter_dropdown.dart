import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/model/date_filter.dart';

class FilterDropDown extends StatefulWidget {
  Function callback;
  FilterDropDown({required this.callback});
  FilterDropDownState createState()=>FilterDropDownState();
}
class FilterDropDownState extends State<FilterDropDown>{
  int selectedFilter=3;
  void initState(){
    super.initState();
    BlocProvider.of<LandingDashboardBloc>(context).selectedFiter=3;
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("Select Date Filter"),),
      content: Container(
        height: MediaQuery.of(context).size.height*0.6,
        width: MediaQuery.of(context).size.width*0.9,
        child: ListView.builder(shrinkWrap:true,itemBuilder: (context,int index){
          return RadioListTile(value: index,
              onChanged: (int? value){
            setState(() {
              selectedFilter=value!;
            });
                BlocProvider.of<LandingDashboardBloc>(context).selectedFiter=selectedFilter;
              },groupValue: selectedFilter,title: Text(BlocProvider.of<LandingDashboardBloc>(context).dateFilters[index]),);
        },itemCount: BlocProvider.of<LandingDashboardBloc>(context).dateFilters.length,),
      ),
      actions: [
        OutlineButton(
            onPressed: () => Navigator.pop(context),
            child: Center(
              child: Text("Cancel"),
            )),
        SizedBox(
          width: 10.0,
        ),RaisedButton(
          onPressed:  () {
            widget.callback(selectedFilter);
            Navigator.pop(context);
          },
          child: Center(
            child: Text("Select Filter"),
          ),
          color: Colors.blue,
          textColor: Colors.white,
        )
      ],
    );
  }
}