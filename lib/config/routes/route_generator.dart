import 'package:user_shop/Presentation/Pages/authentication/sign_in.dart';
import 'package:user_shop/Presentation/Pages/authentication/sign_up.dart';
import 'package:user_shop/config/routes/route_error_page.dart';
import 'package:user_shop/domain/models/product.dart';
import 'package:user_shop/presentation/pages/authentication/reset_psswd.dart';
import 'package:user_shop/presentation/pages/authentication/start.dart';
import 'package:user_shop/presentation/pages/cart/cart_items.dart';
import 'package:user_shop/presentation/pages/home_page.dart';
import 'package:user_shop/presentation/pages/order/order_details.dart';
import 'package:user_shop/presentation/pages/order/orders.dart';
import 'package:user_shop/presentation/pages/product/product.dart';
import 'package:flutter/material.dart';
import 'package:user_shop/presentation/pages/profile/profile.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/start':
        return MaterialPageRoute(builder: (_) => const StartPage());
      case '/sign-in':
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case '/sign-up':
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case '/reset':
        return MaterialPageRoute(builder: (_) => const ResetPage());
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case '/cart':
        return MaterialPageRoute(builder: (_) => const CartPage(isPushed: true));
      case '/order':
        return MaterialPageRoute(builder: (_) => const OrderPage());
      case '/map':
        return MaterialPageRoute(builder: (_) => const MapPage());
      case '/product':
        if (args is Product) {
          return MaterialPageRoute(builder: (_) => ProductPage(product: args));
        }
        return MaterialPageRoute(builder: (_) => const RouteErrorPage());
      case '/orders':
        return MaterialPageRoute(builder: (_) => const OrdersPage());
      default:
        return MaterialPageRoute(builder: (_) => const RouteErrorPage());
    }
  }
}
