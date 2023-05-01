import 'package:http/http.dart' as http;

String url = 'http://10.0.2.2:3000';

class DataProvider {
  static postData(String endpoint, body, {jwt = ""}) async {
    final http.Response response = await http.post(Uri.parse('$url/$endpoint'), headers: {"Content-Type": "application/json", "Authorization": jwt}, body: body);
    return response;
  }

  static getData(String endpoint, {jwt = ""}) async {
    final http.Response response = await http.get(Uri.parse('$url/$endpoint'), headers: {"Content-Type": "application/json", "Authorization": jwt});
    return response;
  }

  static deleteData(String endpoint, String id, {jwt = ""}) async {
    final http.Response response = await http.delete(Uri.parse('$url/$endpoint/$id'), headers: {"Content-Type": "application/json", "Authorization": jwt});
    return response;
  }
}
