import 'package:crypto_screen/domain/entities/cur_info/entity_cur_info.dart';

abstract class ConverterMobula {
  static List<EntityCurInfo> c(dynamic data) {
    List<EntityCurInfo> output = [];

    for (Map map in data) {
      double price = map["price"];
      double delta = 0;
      List<double> graph = [];

      int index = 0;
      for (List price in map["data"]["price_history"]) {
        if (index % 288 == 0 && price.length == 2) {
          graph.add(double.parse(price[1].toString()));
        }
        index++;
      }

      if (graph.isNotEmpty) {
        delta = price - graph.last;
      }

      output.add(
        EntityCurInfo(
          name: map["name"],
          shortName: map["symbol"],
          iconUrl: map["logo"],
          price: price,
          graph: graph,
          delta: delta,
        ),
      );
    }

    return output;
  }
}
