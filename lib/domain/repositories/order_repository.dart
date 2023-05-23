import 'dart:convert';

import 'package:http/http.dart';
import 'package:user_shop/data/local/local_data.dart';
import 'package:user_shop/data/remote/remote_data.dart';

class OrderRepository {
  static payment(
      {required String name, required String mobile, required String email, required String line1, required String line2, required String city, required String state, required String country}) async {
    final jwt = await JwtProvider.getJwt();
    final body = {
      "name": name,
      "mobile": mobile,
      "email": email,
      "line1": line1,
      "line2": line2,
      "city": city,
      "state": state,
      "country": country,
    };
    Response response = await DataProvider.postData('payment/user', json.encode(body), jwt: jwt);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {'invoice': data['invoice'], 'status': 200};
    } else {
      return {'status': 0};
    }
  }

  static fetchOrders() async {
    final jwt = await JwtProvider.getJwt();
    Response response = await DataProvider.getData('orders/user', jwt: jwt);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {'data': data['orders'], 'status': 200};
    } else {
      return {'status': 0};
    }
  }
}
