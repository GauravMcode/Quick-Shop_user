import 'dart:convert';

import 'package:http/http.dart';
import 'package:user_shop/data/local/local_data.dart';
import 'package:user_shop/data/remote/remote_data.dart';
import 'package:user_shop/domain/models/user.dart';

class UserRepository {
  static Future<Map> getUser() async {
    final jwt = await JwtProvider.getJwt();
    Response response = await DataProvider.getData('user/user', jwt: jwt);
    final result = json.decode(response.body);
    if (response.statusCode == 200) {
      await UserIdProvider.saveId(result['data']['_id']);
      return {
        'data': User.fromMap(result['data']),
        'status': 200,
      };
    }
    return {'status': response.statusCode, 'message': result['message']};
  }

  static Future<Map> updateUser(User user) async {
    final jwt = await JwtProvider.getJwt();
    final updatedUser = user.toJson();
    Response response = await DataProvider.postData('user-update/user', updatedUser, jwt: jwt);
    final result = json.decode(response.body);
    if (response.statusCode == 200) {
      await UserIdProvider.saveId(result['data']['_id']);
      return {
        'data': User.fromMap(result['data']),
        'status': 200,
      };
    }
    return {'status': response.statusCode, 'message': result['message']};
  }

  static Future<Map> wishList(String action, String prodId) async {
    final jwt = await JwtProvider.getJwt();
    Map<String, dynamic> body = {
      'prodId': prodId,
    };
    Response response = await DataProvider.postData('wishlist/$action/user', json.encode(body), jwt: jwt);
    final result = json.decode(response.body);
    if (response.statusCode == 200) {
      await UserIdProvider.saveId(result['data']['_id']);
      return {
        'data': User.fromMap(result['data']),
        'status': 200,
      };
    }
    return {'status': response.statusCode, 'message': result['message']};
  }
}
