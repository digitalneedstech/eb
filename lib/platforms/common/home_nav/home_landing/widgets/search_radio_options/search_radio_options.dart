import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/listing_page.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
class SearchRadioOptions extends StatefulWidget{
  SearchRadioOptionsState createState()=>SearchRadioOptionsState();
}
class SearchRadioOptionsState extends State<SearchRadioOptions>{
  String searchByParameterName="person";
  TextEditingController _controller=new TextEditingController(text: "");
  bool isSearchByFreelancer=true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: RadioListTile(
                groupValue: isSearchByFreelancer,
                value: true,
                onChanged: (val) {
                  setState(() {
                    isSearchByFreelancer=true;
                    searchByParameterName="person";
                  });
                },
                title: Text("Search By Freelancer",style: TextStyle(
                  fontSize: 14.0
                ),),
              ),
            ),
            Expanded(child: RadioListTile(
              groupValue: isSearchByFreelancer,
              value: false,
              onChanged: (val) {
                setState(() {
                  isSearchByFreelancer=false;
                  searchByParameterName="skill";
                });
              },
              title: Text("Search By Skill",style: TextStyle(fontSize: 14.0),),
            ))
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller:_controller,
                  decoration: InputDecoration(
                      labelText: searchByParameterName=="person"?"Search For Freelancers":"Search By Skill",
                      enabledBorder: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              EbRaisedButtonWidget(
                  buttonText: "Search",
                  callback:() {
                    BlocProvider.of<LandingDashboardBloc>(context)
                        .associateNameController.text=_controller.text;
                    if(kIsWeb){
                      Navigator.pushNamed(context, "search/"+searchByParameterName+"/"+_controller.text);
                    }else{
                    Navigator.push(context,MaterialPageRoute(builder: (context) =>
                        ListingPage(isFreelancerAdditionEnabled: false,searchText:_controller.text,
                            searchByParameter: searchByParameterName)));
    }}

              )
            ],
          ),
        ),
      ],
    );
  }
}