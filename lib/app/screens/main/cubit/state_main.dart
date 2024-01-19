import 'package:crypto_screen/domain/entities/cur_info/entity_cur_info.dart';
import 'package:equatable/equatable.dart';

class StateMain extends Equatable {
  const StateMain({
    this.curList = const [],
    this.searchQuery = "",
  });

  StateMain copyWith({
    List<EntityCurInfo>? curList,
    String? searchQuery,
  }) {
    return StateMain(
      curList: curList ?? this.curList,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  final List<EntityCurInfo> curList;
  final String searchQuery;

  @override
  List<Object?> get props => [
        curList,
        curList.length,
        curList.hashCode,
        searchQuery,
      ];
}
