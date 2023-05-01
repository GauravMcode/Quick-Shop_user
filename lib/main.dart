import 'package:user_shop/config/routes/route_generator.dart';
import 'package:user_shop/data/local/local_data.dart';
import 'package:user_shop/domain/models/product.dart';
import 'package:user_shop/domain/models/user.dart';
import 'package:user_shop/presentation/Bloc/bloc/auth_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/cart_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/product_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/auth_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String auth = await JwtProvider.getJwt();
  print(auth);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(UserApp(authState: auth));
}

class UserApp extends StatelessWidget {
  UserApp({super.key, required this.authState});
  String authState;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (BuildContext context) => AuthBloc()),
        BlocProvider<AuthStatusBloc>(create: (BuildContext context) => AuthStatusBloc(authState != '')),
        BlocProvider<ProductBloc>(create: (BuildContext context) => ProductBloc(const Product('', '', '', 0, 0, '').toMap())),
        BlocProvider<ProductListBloc>(create: (BuildContext context) => ProductListBloc()),
        BlocProvider<UserBloc>(create: (BuildContext context) => UserBloc(const User('', '', ''))),
        BlocProvider<CartBloc>(create: (BuildContext context) => CartBloc(const User('', '', ''))),
      ],
      child: BlocBuilder<AuthStatusBloc, bool>(
        builder: (context, state) {
          if (state) {
            print('calling user...');
            context.read<UserBloc>().add(AlreadyAuthEvent());
          }
          print('main.dart -> $state');
          return MaterialApp(
            initialRoute: state && authState.isNotEmpty ? '/' : '/sign-in',
            onGenerateRoute: RouteGenerator.generateRoute,
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark(),
          );
        },
      ),
    );
  }
}
