import 'dart:async';

import 'package:aloquei_app/core/models/interest_offer_model.dart';
import 'package:aloquei_app/resources/offers/firestore_offers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../core/models/explore_model.dart';

part 'explore_people_event.dart';
part 'explore_people_state.dart';

class ExplorePeopleBloc extends Bloc<ExplorePeopleEvent, ExplorePeopleState> {
  final ExploreModel exploreModel;
  ExplorePeopleBloc({this.exploreModel}) : super(ExplorePeopleInitial());

  OffersRepository _offersRepository = OffersRepository();

  List<InterestModel> _interestBaseList = [];

  List<InterestModel> _interestList = [];

  List<InterestModel> get interest => _interestList;

  List<InterestModel> _buildFilteredList(String search) {
    List<String> filtro = search.toLowerCase().split(' ');
    List<InterestModel> lista = [];
    for (var i = 0; i < _interestBaseList.length; i++) {
      if ((filtro
          .where((x) =>
              _interestBaseList[i].postUserName.toLowerCase().contains(x))
          .isNotEmpty)) lista.add(_interestBaseList[i]);
    }
    return lista;
  }

  @override
  Stream<ExplorePeopleState> mapEventToState(
    ExplorePeopleEvent event,
  ) async* {
    try {
      if (event is ExploreListStartedEvent) {
        yield LoadingListState();
        _interestBaseList = await _offersRepository.getInterestsFiltered(
            exploreModel.estado.sigla, exploreModel.city.nome);
        _interestList = _interestBaseList;
        yield ShowListState();
      } else if (event is GetMoreItensEvent) {
        yield UpdateListState();
        _interestBaseList += await _offersRepository.getInterestsFilteredMore(
            exploreModel.estado.sigla,
            exploreModel.city.nome,
            _interestBaseList.last.doc);
        _interestList = _interestBaseList;
        yield ShowListState();
      } else if (event is SearchEvent) {
        yield UpdateListState();
        _interestList = _buildFilteredList(event.search);
        if (_interestList.length == 0) {
          _interestList = _interestBaseList;
        }
        yield ShowListState();
      }
    } catch (e) {
      print(e);
      yield FailState(message: e.toString());
    }
  }
}
