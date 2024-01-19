import 'package:crypto_screen/app/screens/main/cubit/state_main.dart';
import 'package:crypto_screen/domain/entities/cur_info/entity_cur_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CubitMain extends Cubit<StateMain> {
  CubitMain() : super(const StateMain());

  void changeCurList(List<EntityCurInfo> newList) {
    newList.sort(
      (a, b) {
        if (a.price > b.price) return -1;
        if (a.price < b.price) return 1;
        return 0;
      },
    );

    emit(state.copyWith(curList: newList));
  }

  void changeSearchQuery(String newQuery) {
    emit(state.copyWith(searchQuery: newQuery.trim()));
  }
}
