import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/overview_tab_widgets/bid_tab/overview_bid_tab.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/overview_tab_widgets/call_tab/overview_call_tab.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/overview_tab_widgets/scheduled_call_tab/overview_scheduled_call_tab.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/overview_tab_widgets/upcoming_call_tab/overview_upcoming_call_tab.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/sub_widgets/revenue_tab.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class OverviewTab extends StatelessWidget {
  final bool isUserRole;
  OverviewTab({required this.isUserRole});

  @override
  Widget build(BuildContext context) {
    List<ContainerModelData> containerDataModel = [
      ContainerModelData(subTitle: "Revenue", index: 0, title: "Revenue"),
      ContainerModelData(
          title: "Upcoming Calls", subTitle: "Total Calls Scheduled", index: 1),
      ContainerModelData(
          title: "Bids", subTitle: isUserRole ?"Total Bids Sent":"Total Bids Received", index: 2),
      ContainerModelData(
          title: "Calls", subTitle: isUserRole ?"Total Calls":"Total Calls Received", index: 3),
      ContainerModelData(
          title: "Scheduled Calls",
          subTitle: isUserRole ?"Total Scheduled Calls":"Total Scheduled Calls Received",
          index: 4)
    ];
    return AnimationLimiter(
      child: ListView.builder(
          itemCount: containerDataModel.length,
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            return _getContainerWidgets(
                context,
                index,
                containerDataModel[index].title,
                containerDataModel[index].subTitle);
          }),
    );
  }

  _getContainerWidgets(
      BuildContext context, int index, String title, String subtitle) {
    switch(index){
      case 1:
        return OverviewUpcomingCallWidget(isFreelancer: !isUserRole,
            index: index, headerTitle: title, subTitle: subtitle);
        break;
      case 2:
        return OverviewBidWidget(isFreelancer: !isUserRole,
            index: index, headerTitle: title, subTitle: subtitle);
        break;
      case 3:
        return OverviewCallWidget(
            index: index, headerTitle: title, subTitle: subtitle);
        break;
      case 4:
        return OverviewScheduledCallWidget(
            index: index, headerTitle: title, subTitle: subtitle);
      case 0:
        if(getUserDTOModelObject(context).personalDetails.type == Constants.CUSTOMER || (getUserDTOModelObject(context)
            .personalDetails.type ==
            Constants.CLIENT && !isUserRole && getUserDTOModelObject(context)
            .companyId=="")
        || (getUserDTOModelObject(context)
                .personalDetails.type ==
                Constants.VENDOR && !isUserRole && getUserDTOModelObject(context)
                .companyId=="")){
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: RevenueTab(
                  index: index,
                  subTitle: subtitle,
                  headerTitle: title,
                ),
              ),
            ),
          );
        }
        return Container();
        break;


    }
  }
}

class ContainerModelData {
  String title, subTitle;
  int index;
  ContainerModelData({required this.title, required this.subTitle,required this.index});
}
