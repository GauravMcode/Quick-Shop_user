import 'package:user_shop/domain/models/user.dart';
import 'package:user_shop/presentation/Bloc/bloc/auth_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/cart_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/product_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/auth_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_shop/presentation/pages/cart/cart_items.dart';
import 'package:user_shop/presentation/pages/product/products.dart';

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
  }

  int _currentIndex = 0;
  List<Widget> pages = [
    const ProductsPage(),
    const ProductsPage(),
    const CartPage(),
    const ProductsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, User>(
      builder: (context, userState) {
        return BlocBuilder<ProductListBloc, Map>(
          builder: (context, state) {
            return SafeArea(
              child: Scaffold(
                  appBar: AppBar(
                    title: const Text('User App'),
                    actions: [
                      BlocBuilder<CartBloc, User>(
                        builder: (context, cartState) {
                          final number = cartState.cart?['number'] ?? userState.cart?['number'];
                          return Stack(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => {Navigator.of(context).pushNamed('/cart')},
                                icon: const Icon(Icons.shopping_cart_outlined),
                                label: const Text('View Cart    '),
                              ),
                              number == null || number == 0
                                  ? const SizedBox.shrink()
                                  : Positioned(
                                      right: 2,
                                      top: 11,
                                      child: CircleAvatar(
                                        radius: 12,
                                        child: Text("$number"),
                                      ),
                                    )
                            ],
                          );
                        },
                      )
                    ],
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (value) {
                      setState(() {
                        _currentIndex = value;
                      });
                    },
                    items: const [
                      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                      BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
                      BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'My Cart'),
                      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Profile'),
                    ],
                  ),
                  // drawer: Drawer(
                  //   child: ListView(
                  //     children: [
                  //       DrawerHeader(
                  //           child: Text(
                  //         userState.name.toUpperCase(),
                  //         style: const TextStyle(
                  //           fontSize: 30,
                  //         ),
                  //       )),
                  //       const ListTile(
                  //         title: Text('Profile', style: TextStyle(fontSize: 20)),
                  //         leading: Icon(Icons.person),
                  //       ),
                  //       ListTile(
                  //         title: const Text('My Products', style: TextStyle(fontSize: 20)),
                  //         leading: const Icon(Icons.sell),
                  //         onTap: () => Navigator.of(context).popAndPushNamed('/'),
                  //       ),
                  //       const ListTile(
                  //         title: Text('Sales Report', style: TextStyle(fontSize: 20)),
                  //         leading: Icon(Icons.show_chart_sharp),
                  //       ),
                  //       const ListTile(
                  //         title: Text('Settings', style: TextStyle(fontSize: 20)),
                  //         leading: Icon(Icons.settings),
                  //       ),
                  //       const SizedBox(height: 100),
                  //       ListTile(
                  //         title: const Text('Sign out', style: TextStyle(fontSize: 20)),
                  //         leading: const Icon(Icons.logout),
                  //         onTap: () {
                  //           context.read<AuthStatusBloc>().add(SignOutEvent());
                  //           context.read<AuthStatusBloc>().add(AuthStateEvent());
                  //           Navigator.of(context).pushReplacementNamed('/sign-in');
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  body: pages[_currentIndex]),
            );
          },
        );
      },
    );
  }
}
