import 'dart:convert';

import 'package:http/http.dart';
import 'package:user_shop/data/local/local_data.dart';
import 'package:user_shop/data/remote/remote_data.dart';

class OrderRepository {
  static payment() async {
    final jwt = await JwtProvider.getJwt();
    Response response = await DataProvider.getData('payment', jwt: jwt);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {'data': data, 'status': 200};
    }
  }
}
