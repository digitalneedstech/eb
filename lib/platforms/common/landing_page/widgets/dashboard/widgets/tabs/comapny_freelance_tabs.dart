import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/bids/bids_made.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/calls_made.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/contract_bids.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/overview_tab.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/widgets/scheduled_calls.dart';

class CompanyFreelanceTabsWidget extends StatelessWidget{
  final bool isUserRole;
  CompanyFreelanceTabsWidget({required this.isUserRole});
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        OverviewTab(isUserRole: isUserRole),
        CallsMade(
          isFreelancer: !isUserRole,
        ),
        ScheduledCallsMade(isFreelancer: !isUserRole),

      ],
    );
  }
}