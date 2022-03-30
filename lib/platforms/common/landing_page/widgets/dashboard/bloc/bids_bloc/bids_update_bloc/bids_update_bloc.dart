
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/bids_bloc/bids_update_bloc/bids_update_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/bids_bloc/bids_update_bloc/bids_update_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/repo/landing_repo.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class BidsDashboardUpdateBloc extends Bloc<BidsDashboardUpdateEvent, BidsDashboardUpdateState> {
  final LandingRepo landingRepo;

  BidsDashboardUpdateBloc(this.landingRepo) : super(BidsDashboardUpdateLoadedState());


  @override
  Stream<BidsDashboardUpdateState> mapEventToState(
      BidsDashboardUpdateEvent event,) async* {
    if(event is UpdateBidEvent){
      yield UpdateBidInProgressState();
      try {
        updateBid(event.bidId, event.userId, event.freelancerId, event.type);
        yield UpdateBidState(isUpdated: true);
      }
      catch(e){
        yield UpdateBidState(isUpdated: false);
      }
    }

  }

  updateBid(String bidId,String userId,String freelancerId,String type) async {
    await this.landingRepo.updateBid(bidId,userId,freelancerId,type);
  }


  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}