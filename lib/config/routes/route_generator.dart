import 'package:user_shop/Presentation/Pages/authentication/sign_in.dart';
import 'package:user_shop/Presentation/Pages/authentication/sign_up.dart';
import 'package:user_shop/config/routes/route_error_page.dart';
import 'package:user_shop/domain/models/product.dart';
import 'package:user_shop/presentation/pages/authentication/reset_psswd.dart';
import 'package:user_shop/presentation/pages/cart/cart_items.dart';
import 'package:user_shop/presentation/pages/home_page.dart';
import 'package:user_shop/presentation/pages/order/order_details.dart';
import 'package:user_shop/presentation/pages/order/payment.dart';
import 'package:user_shop/presentation/pages/product/add_product.dart';
import 'package:user_shop/presentation/pages/product/product.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/sign-in':
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case '/sign-up':
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case '/reset':
        return MaterialPageRoute(builder: (_) => const ResetPage());
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/add-product':
        if (args is Product) {
          return MaterialPageRoute(builder: (_) => AddProductPage(recievedProduct: args));
        }
        return MaterialPageRoute(builder: (_) => const AddProductPage());
      case '/cart':
        return MaterialPageRoute(builder: (_) => const CartPage());
      case '/order':
        return MaterialPageRoute(builder: (_) => const OrderPage());
      case '/payment':
        return MaterialPageRoute(builder: (_) => const PaymentPage());
      case '/product':
        if (args is Product) {
          return MaterialPageRoute(builder: (_) => ProductPage(product: args));
        }
        return MaterialPageRoute(builder: (_) => const RouteErrorPage());
      default:
        return MaterialPageRoute(builder: (_) => const RouteErrorPage());
    }
  }
}
