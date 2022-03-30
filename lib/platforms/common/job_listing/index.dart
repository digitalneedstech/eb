import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/job_listing/widgets/job_list.dart';
import 'package:flutter_eb/platforms/common/job_listing/widgets/search_job/search_job.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/filter/filter_posts.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/post_bloc.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/post_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/filter/filter.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/search_associate/search_associate.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/eb_web_app_bar/eb_web_appbar.dart';
class JobListingPage extends StatelessWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PostBloc>(context).add(FetchPostsAndFilterMyJobsEvent(
      jobTitle: BlocProvider.of<LandingDashboardBloc>(context).associateNameController.text,dateFilter: 0,
        userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId));
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey.shade200,
        appBar: getScreenWidth(context)>800 ?PreferredSize(
            preferredSize: Size.fromHeight(0.0), // here the desired height
            child: AppBar(
              automaticallyImplyLeading: false,
            )
        ): AppBar(
          title: Text("Job Listing"),
        ),
        body: getScreenWidth(context)>800 ?Container(
          child:Center(
            child: ListView(
              children: [
                EbWebAppBarWidget(),
                Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    margin: getScreenWidth(context)>800 ?EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width*0.05,
                      vertical: MediaQuery.of(context).size.height*0.05
                    ):EdgeInsets.all(10.0),
                    child:Row(
                      children: [
                        Expanded(
                          flex:3,
                          child: SearchAssociate(
                            searchPlaceholder: "Search Jobs",
                            callback: (String? val) {
                              getPosts(context,val!);
                            },
                          ),
                        ),
                        FilterPostPage(
                          callback: () {
                            getPosts(context,null);
                          },
                        ),
                      ],
                    )),
                getJobListing(context)
              ],
            ),
          ),
        ):Container(
          child:ListView(
            children: [
              Container(
                  margin: EdgeInsets.all(10),
                  child:Row(
                    children: [
                      Expanded(
                        flex:3,
                        child: SearchJob(
                          searchPlaceholder: "Search Jobs",
                          callback: (String? val) {
                            getPosts(context,val!);
                          },
                        ),
                      ),
                      FilterPostPage(
                        callback: (String name) {
                          getPosts(context,null);
                        },
                      ),
                    ],
                  )),
              getJobListing(context)
            ],
          ),
        )

    );
  }

  getJobListing(BuildContext context){
    return JobListWidget(callback: () {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Thanks. You have applied for job"),
        backgroundColor: Colors.green,
      ));

      BlocProvider.of<PostBloc>(context).add(FetchPostsAndFilterMyJobsEvent(
          dateFilter: 0,jobTitle: BlocProvider.of<LandingDashboardBloc>(context)
          .associateNameController
          .text,
          userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId));
    });
  }
  getPosts(BuildContext context,String? val){
    BlocProvider.of<LandingDashboardBloc>(context).associateNameController.text=val!=null?val:"";
    BlocProvider.of<PostBloc>(context).add(FetchPostsAndFilterMyJobsEvent(
        dateFilter: BlocProvider.of<LandingDashboardBloc>(context)
            .selectedFiter,
        jobTitle: val!=null?val:"",
        userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId));
  }
}
