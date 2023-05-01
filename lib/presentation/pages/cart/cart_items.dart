import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_shop/domain/models/user.dart';
import 'package:user_shop/presentation/Bloc/bloc/auth_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/cart_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/auth_events.dart';
import 'package:user_shop/presentation/widgets/products_helper.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isEmpty = false;
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(AlreadyAuthEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CartBloc, User>(
        builder: (context, cartState) {
          List products = cartState.cart?['items'] ?? [];
          return BlocBuilder<UserBloc, User>(
            builder: (context, state) {
              if (cartState.cart?['number'] == 0 && state.cart?['number'] != 0) {
                isEmpty = true;
                context.read<UserBloc>().add(AlreadyAuthEvent());
              }
              products = products.isEmpty && state.cart?['items'] != null ? state.cart!['items'] : products;
              return products.isEmpty || isEmpty
                  ? const Center(child: Text('Cart is empty!\n Add items to cart'))
                  : SafeArea(
                      child: Column(
                        children: [
                          Card(
                            elevation: 20,
                            child: Text('Total Price : \$ ${cartState.cart?['total'] ?? state.cart?['total']}', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  int? quant = products[index]?['quantity'];
                                  int? price = products[index]['id']?['price'];
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 300,
                                        child: Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          elevation: 20,
                                          margin: const EdgeInsets.all(10.0),
                                          child: InkWell(
                                            onTap: () => Navigator.of(context).pushNamed('/product', arguments: products[index]),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                    height: 200,
                                                    child: Row(
                                                      children: [
                                                        ProductImage(products: products, index: index, cart: true),
                                                        CartProductOverview(products: products, index: index),
                                                      ],
                                                    )),
                                                Text(
                                                  'Price : ${quant != null && price != null ? quant * price : 0}',
                                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: const [
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
                          const ElevatedButton(onPressed: null, child: Text('Order Now')),
                        ],
                      ),
                    );
            },
          );
        },
      ),
    );
  }
}
