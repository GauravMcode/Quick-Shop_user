import 'dart:convert';

import 'package:http/http.dart';
import 'package:user_shop/data/local/local_data.dart';
import 'package:user_shop/data/remote/remote_data.dart';
import 'package:user_shop/domain/models/user.dart';

class CartRepository {
  static Future<Map> editCart(String prodId, String task) async {
    final jwt = await JwtProvider.getJwt();
    Map<String, String> body = {"type": "user", "prodId": prodId, "task": task};
    Response response = await DataProvider.postData('cart', json.encode(body), jwt: jwt);
    final result = json.decode(response.body);
    if (response.statusCode == 201) {
      return {
        'data': User.fromMap(result['data']),
        'status': 201,
      };
    }
    return {'status': response.statusCode, 'message': result['message']};
  }

  // static Future<Map> getCart() async {
  //   final jwt = await JwtProvider.getJwt();
  //   final Response response = await DataProvider.getData('cart', jwt: jwt);
  //   final body = json.decode(response.body);
  //   final List products = body['data'];
  //   final int total = body['total'];
  //   final int number = body['number'];
  //   final List<Product> data = products.map((e) => Product.fromMap(e)).toList();
  //   return {'data': data, 'total': total, 'number': number, 'status': response.statusCode};
  // }
}
