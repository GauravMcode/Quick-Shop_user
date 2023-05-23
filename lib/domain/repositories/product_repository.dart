import 'dart:convert';

import 'package:user_shop/data/local/local_data.dart';
import 'package:user_shop/data/remote/remote_data.dart';
import 'package:user_shop/domain/models/product.dart';
import 'package:http/http.dart';

class ProductRepository {
  static Future<Map> getProduct(String id) async {
    final jwt = await JwtProvider.getJwt();
    final Response response = await DataProvider.getData('product/$id/user', jwt: jwt);
    final data = {'data': Product.fromMap(json.decode(response.body)['data']), 'status': response.statusCode};
    return data;
  }

  static Future<Map> getAllProducts(int page, int limit, String category) async {
    final jwt = await JwtProvider.getJwt();
    final Response response = await DataProvider.getData('user-products/$limit/user?page=$page&category=$category', jwt: jwt);
    final body = json.decode(response.body);
    final List products = body['data'];
    final int count = body['count'];
    final List<Product> data = products.map((e) => Product.fromMap(e)).toList();
    return {'data': data, 'count': count, 'status': response.statusCode};
  }

  static Future<Map> searchProducts(String search) async {
    final jwt = await JwtProvider.getJwt();
    final Response response = await DataProvider.getData('products/user/$search', jwt: jwt);
    final body = json.decode(response.body);
    final List products = body['data'];
    final List<Product> data = products.map((e) => Product.fromMap(e)).toList();
    return {'data': data, 'status': response.statusCode};
  }

  static Future<Map> addReview(String prodId, String name, double rating, String review) async {
    final jwt = await JwtProvider.getJwt();
    Map<String, dynamic> body = {
      'prodId': prodId,
      'name': name,
      'rating': rating,
      'review': review,
    };
    final Response response = await DataProvider.postData('review/user', json.encode(body), jwt: jwt);
    final data = {'data': Product.fromMap(json.decode(response.body)['data']), 'status': response.statusCode};
    return data;
  }

  static updateMetrics(String prodId) async {
    final jwt = await JwtProvider.getJwt();
    Map<String, dynamic> body = {
      'prodId': prodId,
    };
    await DataProvider.postData('update-view-metrics/user', json.encode(body), jwt: jwt);
  }
}















//String title, String description, String imageUrl, int price, int quantity, String adminId, {int sales = 0, int views = 0}