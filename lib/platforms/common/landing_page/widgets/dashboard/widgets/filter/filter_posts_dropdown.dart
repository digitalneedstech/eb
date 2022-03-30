import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/model/date_filter.dart';

class FilterPostsDropDown extends StatefulWidget {
  Function callback;
  FilterPostsDropDown({required this.callback});
  FilterPostsDropDownState createState()=>FilterPostsDropDownState();
}
class FilterPostsDropDownState extends State<FilterPostsDropDown>{
  int selectedFilter=0;
  void initState(){
    super.initState();
    BlocProvider.of<LandingDashboardBloc>(context).selectedFiter=3;
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("Select Posts"),),
      content: Container(
        height: MediaQuery.of(context).size.height*0.6,
        width: MediaQuery.of(context).size.width*0.9,
        child: ListView.builder(shrinkWrap:true,
            itemBuilder: (context,int index){
          return RadioListTile(value: index,
            onChanged: (int? value){
              setState(() {
                selectedFilter=value!;
              });
              BlocProvider.of<LandingDashboardBloc>(context).selectedFiter=selectedFilter;
            },
            groupValue: selectedFilter,
            title: Text(BlocProvider.of<LandingDashboardBloc>(context).postFilter[index]),);
        },itemCount: 3),
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