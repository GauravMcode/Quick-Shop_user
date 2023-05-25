import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:user_shop/config/routes/route_generator.dart';
import 'package:user_shop/config/theme/theme.dart';
import 'package:user_shop/data/local/local_data.dart';
import 'package:user_shop/domain/models/product.dart';
import 'package:user_shop/domain/models/user.dart';
import 'package:user_shop/presentation/Bloc/bloc/auth_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/cart_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/map_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/order_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/product_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/user_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/util_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/user_events.dart';

import 'firebase_options.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  Stripe.publishableKey = dotenv.env['STRIPE_PUBLIC_KEY']!;

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  String auth = await JwtProvider.getJwt();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(UserApp(authState: auth));

// whenever your initialization is completed, remove the splash screen:
  FlutterNativeSplash.remove();
}

class UserApp extends StatelessWidget {
  const UserApp({super.key, required this.authState});
  final String authState;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (BuildContext context) => AuthBloc()),
        BlocProvider<AuthStatusBloc>(create: (BuildContext context) => AuthStatusBloc(authState != '')),
        BlocProvider<ProductBloc>(create: (BuildContext context) => ProductBloc(const Product('', '', '', 0, 0, '', '', 0.0, []).toMap())),
        BlocProvider<ProductListBloc>(create: (BuildContext context) => ProductListBloc()),
        BlocProvider<UserBloc>(create: (BuildContext context) => UserBloc(User('', '', '', '', const {}, const [], const []))),
        BlocProvider<CartBloc>(create: (BuildContext context) => CartBloc(User('', '', ''))),
        BlocProvider<OrderBloc>(create: (BuildContext context) => OrderBloc()),
        BlocProvider<LocationMapBloc>(create: (BuildContext context) => LocationMapBloc()),
        BlocProvider<AddressMapBloc>(create: (BuildContext context) => AddressMapBloc()),
        BlocProvider<AddressBloc>(create: (BuildContext context) => AddressBloc()),
        BlocProvider<SearchProductsBloc>(create: (BuildContext context) => SearchProductsBloc()),
        BlocProvider<SizeBloc>(create: (BuildContext context) => SizeBloc()),
        BlocProvider<OrdersBloc>(create: (BuildContext context) => OrdersBloc()),
      ],
      child: BlocBuilder<AuthStatusBloc, bool>(
        builder: (context, state) {
          if (state) {
            context.read<UserBloc>().add(AlreadyAuthEvent());
          }

          return MaterialApp(
            initialRoute: state && authState.isNotEmpty ? '/' : '/start',
            onGenerateRoute: RouteGenerator.generateRoute,
            debugShowCheckedModeBanner: false,
            theme: themeData(),
          );
        },
      ),
    );
  }
}

//orange : orange : ffa502
//Prestige (dark grey) : 2f3542
//twinkle (not much white) : ced6e0

// class MyColor extends MaterialStateColor {
//   const MyColor() : super(_defaultColor);

//   static const int _defaultColor = 0xcaffa502;
//   static const int _pressedColor = 0xdeced6e0;

//   @override
//   Color resolve(Set<MaterialState> states) {
//     if (states.contains(MaterialState.pressed)) {
//       return const Color(_pressedColor);
//     }
//     return const Color(_defaultColor);
//   }
// }
