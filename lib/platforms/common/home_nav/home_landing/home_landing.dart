import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/home_nav/home_landing/widgets/search_radio_options/search_radio_options.dart';
import 'package:flutter_eb/platforms/common/home_nav/widgets/expert_person_widget.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/drawer/drawer.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/listing_page.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_state.dart';
import 'package:flutter_eb/shared/constants/routes.dart';
import 'package:flutter_eb/shared/widgets/animate_list/animate_list.dart';
import 'package:flutter_eb/shared/widgets/eb_raised_button_widget/eb_raised_button_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomeLandingPage extends StatefulWidget {
  HomeLandingPageState createState() => HomeLandingPageState();
}

class HomeLandingPageState extends State<HomeLandingPage> {
  TextEditingController _controller = new TextEditingController(text: "");
  Map<String, String> expertsMap = {
    "assets/images/landing_home_cat1.jpg": "DevOps",
    "assets/images/landing_home_cat2.jpg": "Finance"
  };

  List<String> skills = [
    "SAP ABAP",
    "SAB HANA",
    "Tech - Supp",
    "Customer - Supp"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: DrawerItems(),
      appBar: AppBar(
        title: Text("Dashboard"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 1000),
              childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 1000.0,
                    duration: const Duration(milliseconds: 1000),
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  color: Colors.grey.shade300,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Text("FIND EXPERTS FOR SOS",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.black, fontSize: 26.0)),
                      SizedBox(
                        height: 10.0,
                      ),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text:
                                  "Aggregating Experts | Converging Skills \n",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "SOS Solution Platform With Bid\n",
                                ),
                                TextSpan(
                                  text:
                                      "Your Price (Bid), Your Convenience(Schedule) \n",
                                ),
                                TextSpan(
                                  text: "& \n",
                                ),
                                TextSpan(
                                  text:
                                      "A platform for freelancers to provide service from anywhere",
                                )
                              ])),
                      SizedBox(
                        height: 10.0,
                      ),
                      SearchRadioOptions(),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Popular Searches",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: AnimationLimiter(
                          child: ListView.builder(
                            itemBuilder: (context, int index) {
                              return AnimateList(
                                index: index,
                                widget: InkWell(
                                  onTap: () {
                                    if (kIsWeb) {
                                      Navigator.pushNamed(context,
                                          "search/skill/" + skills[index]);
                                    } else {
                                      BlocProvider.of<LandingDashboardBloc>(context)
                                          .associateNameController
                                          .text=skills[index];
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ListingPage(
                                                    isFreelancerAdditionEnabled:
                                                        false,
                                                    searchText: skills[index],
                                                    searchByParameter: "skill",
                                                  )));
                                    }
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.28,
                                    margin: const EdgeInsets.only(right: 8.0),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFF5FAFF),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Text(
                                        skills[index],
                                        style: TextStyle(
                                            color: Colors.grey.shade600),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: skills.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Our Experts",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                        if (state is FetchFeaturedFreelancersListState) {
                          if (state.userDTOModel.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Top SAP Experts",
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            );
                          }
                        }
                        return Container();
                      }),
                      SizedBox(
                        height: 20.0,
                      ),
                      BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                        if (state is FetchFeaturedFreelancersListState) {
                          return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: AnimationLimiter(
                                child: ListView.builder(
                                  itemBuilder: (context, int index) {
                                    return AnimateList(
                                        index: index,
                                        widget: ExpertPersonWidget(
                                          userDTOModel:
                                              state.userDTOModel[index],
                                        ));
                                  },
                                  itemCount: state.userDTOModel.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                ),
                              ));
                        }
                        return Container();
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Other Experts Freelancer",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                      ),
                      Column(
                          children: expertsMap.entries.map((e) {
                        return ExpertWidget(imageUrl: e.key, catName: e.value);
                      }).toList())
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.grey.shade300,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Column(
                    children: [
                      Text("How It Works",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          )),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text("1. Search a Expert",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.center),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                          "It is a long established fact that a reader will be distracted by the user while "
                          "reading",
                          style: TextStyle(color: Colors.grey.shade600),
                          textAlign: TextAlign.center),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text("2. Get Consultant",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.center),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                          "It is a long established fact that a reader will be distracted by the "
                          "user while reading",
                          style: TextStyle(color: Colors.grey.shade600),
                          textAlign: TextAlign.center),
                    ],
                  ),
                )
              ]),
        ),
      )),
    );
  }
}

class ExpertWidget extends StatelessWidget {
  String imageUrl, catName;
  ExpertWidget({required this.imageUrl, required this.catName});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ListingPage(
                  isFreelancerAdditionEnabled: false, searchText: catName))),
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 5.0),
          padding: const EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              border: Border.all(color: Colors.grey.shade700)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(imageUrl),
              Text(
                catName,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade600,
              )
            ],
          ),
        ),
      ),
    );
  }
}
