import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_state.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/bloc/wishlist_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/bloc/wishlist_event.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/bloc/wishlist_state.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/widgets/wishlist_widget.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/filter/filter.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/search_associate/search_associate.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/search/search_skill.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/animate_list/animate_list.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
class WishListPage extends StatefulWidget {
  WishListPageState createState()=>WishListPageState();
}
class WishListPageState extends State<WishListPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController _text=TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    UserDTOModel ownerDtoModel =
        BlocProvider.of<LoginBloc>(context).userDTOModel;
    BlocProvider.of<WishListBloc>(context).add(FetchWishListUsers(
        userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId));

    return BlocListener<LandingBloc, LandingState>(
      listener: (context, state) {
        if (state is AddUserToGroupState) {
          _scaffoldKey.currentState!.showSnackBar(SnackBar(
            content: Text("Added to group"),
            backgroundColor: Colors.green,
          ));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: getScreenWidth(context)>800 ? Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),

                  width: MediaQuery.of(context).size.width*0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: SearchSkill(
                        searchQuery:
                        BlocProvider.of<LandingDashboardBloc>(context)
                            .associateNameController
                            .text,
                        searchPlaceholder:  "Search By Name",
                        callback: (String searchQuery) {
                          BlocProvider.of<WishListBloc>(context).add(FetchWishListUsers(
                              userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId,
                              userName: BlocProvider.of<LandingDashboardBloc>(context)
                                  .associateNameController
                                  .text));
                        },
                      )),
                    ],
                  ),
                ),

                getWishlistWidget(context,ownerDtoModel)
              ],
            )
          ):Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            //border: Border.all(color: Colors.grey,width: 2.0),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: TextFormField(

                            decoration: new InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              suffixIcon: IconButton(
                                onPressed: (){
                                  BlocProvider.of<WishListBloc>(context).add(FetchWishListUsers(
                                      userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId,
                                      userName: _text.text));
                                },
                                icon: Icon(Icons.check),
                              ),
                              hintText: "Search By Name"
                            ),
                            controller: _text,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                getWishlistWidget(context,ownerDtoModel)
              ],
            ),
          ),
        ),
      ),
    );
  }

  getWishlistWidget(BuildContext context,UserDTOModel ownerDtoModel){
    return BlocBuilder<WishListBloc, WishListState>(
      builder: (context, state) {
        if (state is LoadingWishListState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Loading")],
            ),
          );
        } else if (state is FetchWishListUsersState) {
          List<UserDTOModel> user = state.wishListIds;
          if (user.isEmpty) {
            return NoDataFound();
          }
          return Container(
            width: getScreenWidth(context)> 800?MediaQuery.of(context).size.width*0.8:MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            height: MediaQuery.of(context).size.height * 0.75,
            child: AnimationLimiter(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, int index) {
                  return getScreenWidth(context)>800 ?Wrap(
                    children: [WishListWidget(
                      callback: () {
                        _scaffoldKey.currentState!.showSnackBar(SnackBar(
                          content:
                          Text("Group Has Been Created. Thanks"),
                          backgroundColor: Colors.green,
                        ));
                      },
                      userDTOModel: user[index],
                      ownerDTOModel: ownerDtoModel,
                    )],
                  ):
                  AnimateList(index:index,widget:WishListWidget(
                    callback: () {
                      _scaffoldKey.currentState!.showSnackBar(SnackBar(
                        content:
                        Text("Group Has Been Created. Thanks"),
                        backgroundColor: Colors.green,
                      ));
                    },
                    userDTOModel: user[index],
                    ownerDTOModel: ownerDtoModel,
                  ));
                },
                itemCount: user.length,
                padding: const EdgeInsets.all(5.0),
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
