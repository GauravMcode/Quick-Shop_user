// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? imageUrl;
  final Map? cart;

  const User(this.id, this.name, this.email, [this.imageUrl = '', this.cart]);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'cart': cart,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(map['_id'] as String, map['name'] as String, map['email'] as String, map['imageUrl'] as String?, map['cart'] as Map?);
  }

  //Json serialization
  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [id, name, email, imageUrl, cart];
}
