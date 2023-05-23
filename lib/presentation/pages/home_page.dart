import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:user_shop/presentation/Bloc/bloc/auth_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/map_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/order_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/util_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/auth_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/map_events.dart';
import 'package:user_shop/presentation/Bloc/events/order_events.dart';
import 'package:user_shop/presentation/Bloc/events/util_events.dart';
import 'package:user_shop/presentation/pages/cart/cart_items.dart';
import 'package:user_shop/presentation/pages/product/products.dart';
import 'package:user_shop/presentation/pages/product/wishlist.dart';
import 'package:user_shop/presentation/pages/profile/profile.dart';

int currentPage = 1;
int limit = 2;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthStatusBloc>().add(AuthStateEvent());
    context.read<LocationMapBloc>().add(GetLocationEvent());
    context.read<OrdersBloc>().add(GetOrdersEvent());
  }

  int currentIndex = 0;
  List<Widget> pages = [
    const ProductsPage(),
    const WishListPage(),
    const CartPage(isPushed: false),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    context.read<SizeBloc>().add(SizeEvents(size: size));
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        initialActiveIndex: 0,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 40,
        style: TabStyle.flip,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          TabItem(icon: Icon(Icons.home), title: 'Home'),
          TabItem(icon: Icon(Icons.favorite), title: 'WishList'),
          TabItem(icon: Icon(Icons.shopping_cart), title: 'My Cart'),
          TabItem(icon: Icon(Icons.person), title: 'My Profile'),
        ],
      ),
      body: SafeArea(child: pages[currentIndex]),
      extendBody: true,
    );
  }
}

// BottomNavigationBar(
//         type: BottomNavigationBarType.shifting,
//         elevation: 20,
//         backgroundColor: const Color(0xff2f3542), //black : 0xff2f3542
//         unselectedItemColor: const Color(0xff2f3542), //orange -> 0xffffa502
//         selectedItemColor: const Color(0xffffa502), //white -> 0xffced6e0
//         currentIndex: currentIndex,
//         onTap: (value) {
//           setState(() {
//             currentIndex = value;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'My WishList'),
//           BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'My Cart'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Profile'),
//         ],
//       ),