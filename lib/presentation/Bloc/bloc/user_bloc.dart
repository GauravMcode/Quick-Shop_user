import 'package:bloc/bloc.dart';
import 'package:user_shop/domain/models/user.dart';
import 'package:user_shop/domain/repositories/user_repository.dart';
import 'package:user_shop/presentation/Bloc/events/user_events.dart';

class UserBloc extends Bloc<UserEvents, User> {
  UserBloc(User user) : super(user) {
    on<AlreadyAuthEvent>((event, emit) async {
      final Map data = await UserRepository.getUser();
      emit(data['data']);
    });

    on<UpdateUserEvent>((event, emit) async {
      final Map data = await UserRepository.updateUser(event.user);
      emit(data['data']);
    });

    on<WishListEvent>((event, emit) async {
      final user = state;
      user.loading = 'wishlist';
      emit(user);
      final Map data = await UserRepository.wishList(event.action, event.prodId);
      emit(data['data']);
    });
  }
}
