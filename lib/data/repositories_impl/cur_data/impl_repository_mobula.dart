import 'dart:convert';

import 'package:crypto_screen/domain/repositories_i/i_repository_cur_data.dart';
import 'package:crypto_screen/misc/keys.dart';
import 'package:http/http.dart';

class ImplRepositoryMobula implements IRepositoryCurData {
  @override
  Future getData() async {
    List<Map<String, dynamic>> output = [];

    Request req = Request(
      "GET",
      Uri(
        scheme: "https",
        host: "api.mobula.io",
        path: "api/1/all",
        queryParameters: {
          "fields": "id,symbol,name,logo,price",
        },
      ),
    );

    Response res = await Response.fromStream(await req.send());

    if (res.statusCode < 200 || res.statusCode >= 300) {
      return [];
    }

    List allCurrencies = jsonDecode(res.body)["data"];

    allCurrencies.sort(
      (a, b) {
        if (a["price"] > b["price"]) return -1;
        if (a["price"] < b["price"]) return 1;
        return 0;
      },
    );

    List topCurrencies = allCurrencies
        .where(
          (c) => c["price"] < 100000,
        )
        .take(16)
        .toList();
    topCurrencies.insert(
      0,
      allCurrencies.firstWhere((c) => c["name"] == "Ethereum"),
    );
    topCurrencies.insert(
      0,
      allCurrencies.firstWhere((c) => c["name"] == "Bitcoin"),
    );

    DateTime now = DateTime.now();
    int nowFormatted = now.millisecondsSinceEpoch;
    int startFormatted =
        now.subtract(const Duration(days: 7)).millisecondsSinceEpoch;

    for (var cur in topCurrencies) {
      Request req = Request(
        "GET",
        Uri(
          scheme: "https",
          host: "api.mobula.io",
          path: "api/1/market/history",
          queryParameters: {
            "asset": cur["name"],
            "from": "$startFormatted",
            "to": "$nowFormatted",
          },
        ),
      );

      req.headers.addAll(
        {
          "Authorization": Keys.MOBULA,
        },
      );

      Response res = await Response.fromStream(await req.send());

      if (res.statusCode < 200 || res.statusCode >= 300) {
        continue;
      }

      final Map<String, dynamic> listResult = {
        "name": cur["name"],
        "symbol": cur["symbol"],
        "logo": cur["logo"],
        "price": cur["price"],
        ...jsonDecode(res.body),
      };

      output.add(listResult);
    }

    return output;
  }
}
