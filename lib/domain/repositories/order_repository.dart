import 'dart:convert';

import 'package:http/http.dart';
import 'package:user_shop/data/remote/remote_data.dart';

class OrderRepository {
  static payment({
    required String amount,
    required String currency,
    required String object,
    required String cardNumber,
    required String expMonth,
    required String expYear,
    required String cvc,
  }) async {
    Map<String, String> body = {
      'amount': amount,
      'currency': currency,
      'object': object,
      'cardNumber': cardNumber,
      'expMonth': expMonth,
      'expYear': expYear,
      'cvc': cvc,
    };
    Response response = await DataProvider.postData('payment', body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {'data': data, 'status': 200};
    }
  }
}
