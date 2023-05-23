import 'package:user_shop/domain/models/user.dart';

abstract class UserEvents {}

class AlreadyAuthEvent extends UserEvents {}

class UpdateUserEvent extends UserEvents {
  User user;
  UpdateUserEvent(this.user);
}

class WishListEvent extends UserEvents {
  String prodId;
  String action;
  WishListEvent({required this.prodId, required this.action});
}
