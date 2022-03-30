import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/listing_page_filter/listing_page_filter.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/group_detail_page/group_detail_page.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_operations_bloc/landing_update_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_operations_bloc/landing_update_event.dart'
    as landingEvent;
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_operations_bloc/landing_update_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/model/query_model.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/search/search_skill.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/search_tile/search_tile.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/eb_web_app_bar/eb_web_appbar.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ListingPage extends StatelessWidget {
  final bool isFreelancerAdditionEnabled;
  final String groupId;
  final String searchText;
  final String searchByParameter;
  ListingPage(
      {this.groupId = "",
      this.searchByParameter = "person",
      this.searchText = "",
      this.isFreelancerAdditionEnabled = false});
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    filterLogic(context, BlocProvider.of<LandingBloc>(context).queryModel);
    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state is AddUserToGroupState) if (state.isUserRequested)
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Added The User To Group"),
            backgroundColor: Colors.green,
          ));
        else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Server Error. While Adding User"),
              backgroundColor: Colors.red));
      },
      child: BlocListener<LandingBloc, LandingState>(
        listener: (context, state) {
          if (state is ClearSearchListingFilterState)
            filterLogic(
                context, BlocProvider.of<LandingBloc>(context).queryModel);
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade200,
          appBar:getScreenWidth(context)>800 ?PreferredSize(
              preferredSize: Size.fromHeight(0.0), // here the desired height
              child: AppBar(
                automaticallyImplyLeading: false,
              )
          ): AppBar(
            title: Text("Search Listing"),
            actions: [
              BlocListener<LandingUpdateBloc, LandingUpdateState>(
                listener: (context, state) {
                  if (state is AddUsersToGroupState) {
                    if (state.isAdded) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.isAdded
                            ? "Added Successfully."
                            : "Could not be added"),
                        backgroundColor:
                            state.isAdded ? Colors.green : Colors.red,
                      ));
                      Future.delayed(Duration(seconds: 2), () {
                        if (kIsWeb) {
                          Navigator.pushNamed(
                              context, "group/" + groupId + "/null/true");
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroupDetailPage(
                                        groupId: groupId,
                                        isScheduleEnabled: true,
                                      )));
                        }
                      });
                    }
                  }
                  if (state is AddUsersToGroupInProgressState) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Adding...")));
                  }
                },
                child: BlocBuilder<LandingUpdateBloc, LandingUpdateState>(
                  builder: (context, state) {
                    if (state is AddOrRemoveFreelancerToGroupState) {
                      if (state.userIds.isNotEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                BlocProvider.of<LandingUpdateBloc>(context).add(
                                    landingEvent.AddUsersToGroupEvent(
                                        groupId: groupId,
                                        ownerId: getUserDTOModelObject(context)
                                            .userId));
                              },
                              child: Text("Add To group"),
                            ),
                          ],
                        );
                      }
                    }
                    return Container();
                  },
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child:getScreenWidth(context)>800 ?
                Center(
                  child: Column(
                    children: [
                      EbWebAppBarWidget(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          child: Row(
                            children: [
                              Expanded(child: Text("Search Results")),
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(color: Colors.grey,width: 2.0)
                                ),
                                child: Text("Sort By"),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: Container(width: MediaQuery.of(context).size.width*0.1,height: MediaQuery.of(context).size.height*0.1,color: Colors.white,),flex: 1,),
                            Expanded(child: getListingWidget(context),flex: 3,)
                          ],
                        ),
                      ),
                    ],
                  ),
                ):
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SearchSkill(
                          searchQuery:
                              BlocProvider.of<LandingDashboardBloc>(context)
                                  .associateNameController
                                  .text,
                          searchPlaceholder: searchByParameter == "person"
                              ? "Search By Freelancer"
                              : "Search By Skill",
                          callback: (String searchQuery) {
                            filterLogic(
                                context,
                                BlocProvider.of<LandingBloc>(context)
                                    .queryModel);
                          },
                        ),
                        Expanded(
                          flex: 1,
                          child: ListingFilterPage(),
                        ),
                      ],
                    ),
                  ),
                  getListingWidget(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void filterLogic(BuildContext context, QueryModel queryModel) {
    BlocProvider.of<LandingBloc>(context).add(
        FetchSearchListingFromFirestoreForQueryEvent(
            queryModel: queryModel,
            searchParameterType: searchByParameter,
            searchQuery: BlocProvider.of<LandingDashboardBloc>(context)
                .associateNameController
                .text));
  }

  getListingWidget(BuildContext context){
    return BlocBuilder<LandingBloc, LandingState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Loading")],
            ),
          );
        } else if (state is FetchFreelancersListState) {
          if (state.errorMessage != "")
            return Center(
              child: Text(state.errorMessage),
            );
          List<UserDTOModel> user = state.userModel
              .where((element) =>
          element.userId !=
              BlocProvider.of<LoginBloc>(context)
                  .userDTOModel
                  .userId)
              .toList();
          if (user.isEmpty) {
            return NoDataFound();
          }
          return Container(
            width: getScreenWidth(context)>600 ? MediaQuery.of(context).size.width*0.9:
            MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            //height: MediaQuery.of(context).size.height * 0.75,
            child: AnimationLimiter(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, int index) {
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      duration:
                      const Duration(milliseconds: 1000),
                      child: SlideAnimation(
                          horizontalOffset: 1000.0,
                          child: FadeInAnimation(
                              child: SearchTile(
                                  longPress:
                                      (UserDTOModel userDTOModel,
                                      String action) {
                                    if (action == "delete") {
                                      BlocProvider.of<
                                          LandingUpdateBloc>(
                                          context)
                                          .add(landingEvent
                                          .RemoveFreelancerToGroupEvent(
                                          userId:
                                          userDTOModel
                                              .userId));
                                    } else
                                      BlocProvider.of<
                                          LandingUpdateBloc>(
                                          context)
                                          .add(landingEvent
                                          .AddFreelancerToGroupEvent(
                                          userDTOModel:
                                          userDTOModel));
                                  },
                                  callback: (String type) {
                                    if (type == "bid")
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                            "Bid Has Been Placed. Thanks"),
                                        backgroundColor:
                                        Colors.green,
                                      ));
                                    else
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                            "User Has Been Added. Thanks"),
                                        backgroundColor:
                                        Colors.green,
                                      ));
                                  },
                                  userDTOModel: user[index]))));
                },
                itemCount: user.length,
                padding: const EdgeInsets.all(5.0),
                physics: BouncingScrollPhysics(),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

List<Widget> getSkills(UserDTOModel model) {
  return model.skills
      .where(
          (element) => element.skill != "" || element.yearsOfExperience != "")
      .map((e) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Skill",
            style: TextStyle(color: Colors.black54, fontSize: 18.0),
          ),
          Text(
            "2 Yrs",
            style: TextStyle(color: Colors.grey, fontSize: 14.0),
          )
        ],
      ),
    );
  }).toList();
}
