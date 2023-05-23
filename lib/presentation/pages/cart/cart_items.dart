import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:user_shop/domain/models/product.dart';
import 'package:user_shop/domain/models/user.dart';
import 'package:user_shop/presentation/Bloc/bloc/cart_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/user_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/user_events.dart';
import 'package:user_shop/presentation/widgets/products/products_helper.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, required this.isPushed});
  final bool isPushed;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isEmpty = false;
  List<Color> gradColors = [const Color(0xff2f3542), const Color(0xffced6e0), const Color(0xff2f3542)];

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(AlreadyAuthEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<CartBloc, User>(
            builder: (context, cartState) {
              List products = cartState.cart?['items'] ?? [];
              return BlocBuilder<UserBloc, User>(
                builder: (context, state) {
                  if (cartState.cart?['number'] == 0 && state.cart?['number'] != 0) {
                    isEmpty = true;
                    context.read<UserBloc>().add(AlreadyAuthEvent());
                  }
                  products = cartState.cart == null && state.cart?['items'] != null ? state.cart!['items'] : products;
                  return products.isEmpty || isEmpty
                      ? Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Your Cart is empty!'),
                            Lottie.asset(
                              'assets/73388-empty-cart.json',
                              width: 400,
                              height: 300,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(height: 10),
                            const Text('Add items to Cart'),
                          ],
                        ))
                      : DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradColors.reversed.toList(),
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              stops: const [0.2, 0.5, 0.99],
                            ),
                          ),
                          child: SafeArea(
                            child: Column(
                              children: [
                                Card(
                                  elevation: 50,
                                  color: Colors.white.withOpacity(0.2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Total Price : ₹ ${cartState.cart?['total'] ?? state.cart?['total']}',
                                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: products.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 200,
                                              child: Card(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                color: Colors.white.withOpacity(0.2),
                                                elevation: 50,
                                                margin: const EdgeInsets.all(10.0),
                                                child: InkWell(
                                                  onTap: () => Navigator.of(context).pushNamed('/product', arguments: Product.fromMap(products[index]['id'])),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                          height: 150,
                                                          child: Row(
                                                            children: [
                                                              ProductImage(products: products, index: index, cart: true),
                                                              CartProductOverview(products: products, index: index),
                                                            ],
                                                          )),
                                                      const Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(Icons.info_outline_rounded),
                                                          Text('Tap to View Product Details', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10)),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(onPressed: () => Navigator.of(context).pushNamed('/order'), child: const Text('Order Now')),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        );
                },
              );
            },
          ),
          widget.isPushed
              ? Positioned(
                  top: 20,
                  left: 5,
                  child: Card(
                    color: Colors.white.withOpacity(0.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 40,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Theme.of(context).primaryColor,
                      iconSize: 35,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
