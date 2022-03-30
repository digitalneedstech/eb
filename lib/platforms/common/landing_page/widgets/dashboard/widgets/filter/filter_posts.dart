import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/filter/filter_dropdown.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/filter/filter_posts_dropdown.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/filter_search/filter_search.dart';
class FilterPostPage extends StatefulWidget {

  Function callback;
  FilterPostPage({required this.callback});
  FilterPostPageState createState()=>FilterPostPageState();
}
class FilterPostPageState extends State<FilterPostPage>{
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
            showDialog(context: context,builder: (context){
              return FilterPostsDropDown(
                callback: (val){
                  setState(() {
                    filterName=_getSelectedFilterName(val);
                  });
                  widget.callback(filterName);

                },
              );
            });
          },),
          //SizedBox(width: 10.0,),
          Text(filterName)

        ],
      ),
    );
  }

  _getSelectedFilterName(int index){
    switch(index){
      case 1:
        return "Applied";
      case 2:
        return "Not Applied";
      default:
        return "All";
    }
  }
}