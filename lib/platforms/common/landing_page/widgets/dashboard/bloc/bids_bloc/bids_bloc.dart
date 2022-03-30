
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/bids_bloc/bids_event.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/bids_bloc/bids_state.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/repo/landing_repo.dart';
import 'package:flutter_eb/platforms/common/login/data/login_repository.dart';
import 'package:flutter_eb/shared/constants/constants.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class BidsDashboardBloc extends Bloc<BidsDashboardEvent, BidsDashboardState> {
  final LandingRepo landingRepo;
  final LoginRepository loginRepository;
  BidsDashboardBloc(this.landingRepo,this.loginRepository) : super(BidsDashboardLoadedState());
  TextEditingController _associateNameController=TextEditingController();
  List<String> dateFilters=["All","Last 7 Days","Last Month","Today"];
  int selectedFiter=0;

  TextEditingController get associateNameController => _associateNameController;

  set associateNameController(TextEditingController value) {
    _associateNameController = value;
  }

  bool _isUserRole=true;


  bool get isUserRole => _isUserRole;

  set isUserRole(bool value) {
    _isUserRole = value;
  }

  @override
  Stream<BidsDashboardState> mapEventToState(
      BidsDashboardEvent event,) async* {

    if (event is FetchBidsMadeEvent) {
      yield LoadingState();
      List<BidModel> bids=[];
      if(event.userType==Constants.CUSTOMER){
        QuerySnapshot snapshot=await loginRepository.getAcceptedResourcesList(event.userId);
        for(DocumentSnapshot doc in snapshot.docs){
          if(doc.exists) {
            Map<String,dynamic> data=doc.data() as Map<String,dynamic>;
            DocumentSnapshot docSnapshot=await loginRepository.getUserByUid(data["id"]);
            if(docSnapshot.exists) {
              QuerySnapshot snapshot = await getBidsList(
                  docSnapshot.id, event.associateName,
                  event.fieldTypeToBeSearched, event.dateFilter);
              bids.addAll(snapshot.docs.map((e) =>
                  BidModel.fromJson(e.data() as Map<String, dynamic>, e.id))
                  .toList());
            }
          }
        }
      }
      else {
        QuerySnapshot snapshot = await getBidsList(
            event.userId, event.associateName, event.fieldTypeToBeSearched,
            event.dateFilter);
        bids = snapshot.docs.map((e) =>
            BidModel.fromJson(e.data() as Map<String,dynamic>, e.id)).toList();
      }
      yield FetchBidsMadeState(bidModels: bids);
    }


  }

  Future<QuerySnapshot> getBidsList(String userId,[String associateName="",
    String associateType="",int dateFilter=3]) async {
    return await this.landingRepo.getBids(userId,associateName,associateType,dateFilter);
  }


  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}