import 'package:user_shop/domain/models/user.dart';
import 'package:user_shop/presentation/Bloc/events/auth_events.dart';
import 'package:user_shop/data/local/local_data.dart';
import 'package:user_shop/domain/repositories/auth_repository.dart';
import 'package:bloc/bloc.dart';

class AuthBloc extends Bloc<AuthEvents, Map> {
  AuthBloc() : super({}) {
    on<SignUpEvent>((event, emit) async {
      final Map data = await AuthRepository.signUp(event.name, event.email, event.password);
      emit(data);
    });

    on<SignInEvent>((event, emit) async {
      final Map data = await AuthRepository.signIn(event.email, event.password);
      emit(data);
    });

    on<ResetOtpEvent>((event, emit) async {
      final Map data = await AuthRepository.generateOtp(event.email);
      emit(data);
    });

    on<ResetEvent>((event, emit) async {
      final Map data = await AuthRepository.resetPassword(event.email, event.otp, event.password);
      emit(data);
    });
  }
}

class AuthStatusBloc extends Bloc<AuthStatusEvents, bool> {
  // bool hasJwt = JwtProvider.getJwt() != '';
  AuthStatusBloc(bool hasJwt) : super(hasJwt) {
    on<AuthStateEvent>(
      (event, emit) async {
        final jwt = await JwtProvider.getJwt();
        jwt != '' ? emit(true) : emit(false);
      },
    );

    on<SignOutEvent>((event, emit) async {
      await JwtProvider.removeJwt();
      emit(false);
    });
  }
}

class UserBloc extends Bloc<AuthEvents, User> {
  UserBloc(User user) : super(user) {
    on<AlreadyAuthEvent>((event, emit) async {
      final Map data = await AuthRepository.getUser();
      emit(data['data']);
    });
  }
}
