import 'package:bloc/bloc.dart';
import 'package:user_shop/domain/models/user.dart';
import 'package:user_shop/domain/repositories/cart_repository.dart';
import 'package:user_shop/presentation/Bloc/events/cart_events.dart';

class CartBloc extends Bloc<CartEvents, User> {
  CartBloc(User user) : super(user) {
    on<CartEvent>((event, emit) async {
      final result = await CartRepository.editCart(event.prodId, event.task);
      if (result['status'] == 201) {
        emit(result['data']);
      }
    });
  }
}
