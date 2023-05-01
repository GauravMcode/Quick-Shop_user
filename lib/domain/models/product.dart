import 'dart:convert';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String? id;
  final String title;
  final String description;
  final String imageUrl;
  final int price;
  final int quantity;
  final String adminId;

  const Product(this.title, this.description, this.imageUrl, this.price, this.quantity, this.adminId, {this.id});

  factory Product.fromMap(Map map) {
    return Product(
      map['title'],
      map['description'],
      map['imageUrl'],
      map['price'],
      map['quantity'],
      map['adminId'],
      id: map['_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'adminId': adminId,
      '_id': id,
    };
  }

  //Json serialization
  factory Product.fromJson(string) {
    return Product.fromMap(json.decode(string));
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [id, title, description, imageUrl, price, quantity, adminId];
}
