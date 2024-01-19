import 'dart:math';

import 'package:crypto_screen/domain/entities/cur_info/entity_cur_info.dart';

abstract class ConverterCoinlayer {
  static List<EntityCurInfo> c(dynamic data) {
    List<dynamic> generalInfoList = data[0]["crypto"].values.toList();

    List<EntityCurInfo> entities = [];
    for (Map<String, dynamic> info in generalInfoList) {
      entities.add(
        EntityCurInfo(
          name: info["name"],
          shortName: info["symbol"],
          iconUrl: info["icon_url"],
          price: 0,
          delta: 0,
          graph: [],
        ),
      );
    }

    for (int i = 1; i < data.length; i++) {
      Map<String, dynamic> rateMap = data[i];

      for (String key in rateMap["rates"].keys) {
        //TODO: remove randomizer
        Random rand = Random();
        int randomV = rand.nextInt(30) + 70;

        //TODO: remove randomizer
        double rate = rateMap["rates"][key].toDouble() * randomV / 100;
        EntityCurInfo entity = entities.firstWhere(
          (e) => e.shortName == key,
        );

        if (i == 1) {
          entity.price = rate;
        }

        entity.graph.add(rate);

        if (i == 2) {
          entity.delta = entity.price - rate;
        }
      }
    }

    return entities;
  }
}
