import 'package:crypto_screen/domain/entities/cur_info/entity_cur_info.dart';
import 'package:crypto_screen/domain/repositories_i/i_repository_cur_data.dart';

class ProviderCurData {
  ProviderCurData({required this.repository, required this.convert});

  final IRepositoryCurData repository;
  final Function(dynamic) convert;

  Future<List<EntityCurInfo>> getData() async {
    return convert.call(await repository.getData());
  }
}
