import 'package:bloc/bloc.dart';
import 'package:user_shop/domain/models/user.dart';
import 'package:user_shop/domain/repositories/cart_repository.dart';
import 'package:user_shop/domain/repositories/user_repository.dart';
import 'package:user_shop/presentation/Bloc/events/cart_events.dart';

class CartBloc extends Bloc<CartEvents, User> {
  CartBloc(User user) : super(user) {
    on<CartEvent>((event, emit) async {
      final user = state;
      user.loading = event.task;
      emit(user);
      print(state.loading);
      final result = await CartRepository.editCart(event.prodId, event.task);
      if (result['status'] == 201) {
        emit(result['data']);
      }
    });

    on<ResetCartEvent>((event, emit) async {
      final Map data = await UserRepository.getUser();
      emit(data['data']);
    });
  }
}
