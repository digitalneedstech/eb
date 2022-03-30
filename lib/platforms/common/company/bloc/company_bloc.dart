
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_event.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_state.dart';
import 'package:flutter_eb/platforms/common/company/model/resource_model.dart';
import 'package:flutter_eb/platforms/common/company/repo/company_repo.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final CompanyRepository companyRepository;

  CompanyBloc(this.companyRepository) : super(CompanyLoadedState());

  @override
  Stream<CompanyState> mapEventToState(CompanyEvent event,) async* {
    if (event is FetchResourcesEvent) {
      yield LoadingCompanyState();
      dynamic users=await getResources(event.companyId,event.freelancerSearchText);
      yield FetchResourcesState(resources: users);
    }

  }

  dynamic getResources(String companyId,String freelancerSearchText) async {
    return this.companyRepository.getResources(companyId,freelancerSearchText);
  }


  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }

}