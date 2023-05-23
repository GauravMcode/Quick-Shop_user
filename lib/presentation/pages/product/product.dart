import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:user_shop/domain/models/product.dart';
import 'package:user_shop/domain/models/user.dart';
import 'package:user_shop/domain/repositories/product_repository.dart';
import 'package:user_shop/presentation/Bloc/bloc/cart_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/user_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/cart_events.dart';
import 'package:user_shop/presentation/Bloc/events/user_events.dart';
import 'package:user_shop/presentation/widgets/products/horizontal_scroll_list.dart';
import 'package:user_shop/presentation/widgets/products/product_helper.dart';
part 'package:user_shop/presentation/widgets/cart/cart_animation.dart';

ValueNotifier<bool> _showCart = ValueNotifier<bool>(false);

class ProductPage extends StatefulWidget {
  final Product product;
  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState(product: product);
}

class _ProductPageState extends State<ProductPage> {
  Product product;
  _ProductPageState({required this.product});

  @override
  void initState() {
    super.initState();
    _showCart.value = false;
    context.read<UserBloc>().add(AlreadyAuthEvent());
    ProductRepository.updateMetrics(widget.product.id!);
  }

  @override
  void dispose() {
    super.dispose();
    _showCart.value = false;
  }

  List<Color> gradColors = [const Color(0xff2f3542), const Color(0xffffa502)];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<ProductBloc, Map>(
      builder: (context, state) {
        product = context.read<ProductBloc>().state['data'] != null && context.read<ProductBloc>().state['data']?.id == product.id ? context.read<ProductBloc>().state['data'] : product;
        return BlocBuilder<CartBloc, User>(
          builder: (context, cartState) {
            return BlocBuilder<UserBloc, User>(
              builder: (context, state) {
                return SafeArea(
                  child: ValueListenableBuilder(
                      valueListenable: _showCart,
                      builder: (context, value, child) {
                        return Stack(
                          children: [
                            Scaffold(
                              body: CustomScrollView(
                                slivers: <Widget>[
                                  SliverAppBar(
                                    backgroundColor: Theme.of(context).primaryColorDark,
                                    expandedHeight: 300,
                                    floating: true,
                                    flexibleSpace: Hero(
                                      tag: '${product.id}',
                                      child: CachedNetworkImage(
                                        key: UniqueKey(),
                                        imageUrl: product.imageUrl,
                                        fit: BoxFit.scaleDown,
                                        progressIndicatorBuilder: (context, url, progress) => Center(
                                          child: Lottie.asset('assets/143310-loader.json', width: 150, height: 100),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: gradColors,
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          stops: const [0.5, 0.99],
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(product.title, style: const TextStyle(fontSize: 25)),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Text('Avg Rating :', style: TextStyle(fontSize: 18)),
                                              RatingBarIndicator(
                                                itemBuilder: (context, _) => const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                rating: product.averageRating,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          const Align(alignment: Alignment.centerLeft, child: Text('Description: ', style: TextStyle(fontSize: 18))),
                                          Description(product: product),
                                          const SizedBox(height: 10),
                                          Text('Price: ₹ ${product.price}', style: Theme.of(context).textTheme.bodyLarge),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 175,
                                                child: ElevatedButton.icon(
                                                    onPressed: () {
                                                      _showCart.value = true;
                                                      context.read<CartBloc>().add(CartEvent(prodId: product.id!, task: "add"));
                                                    },
                                                    icon: const Icon(Icons.shopping_cart_checkout_rounded),
                                                    label: const Text('Add To Cart', textAlign: TextAlign.center)),
                                              ),
                                              SizedBox(
                                                width: 175,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    context.read<CartBloc>().add(CartEvent(prodId: product.id!, task: "add"));
                                                    await Future.delayed(Duration.zero);
                                                    Navigator.of(context).pushReplacementNamed('/cart');
                                                  },
                                                  child: const Text('Buy Now!', textAlign: TextAlign.center),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                            Builder(builder: (context) {
                                              List<Product> products = context.read<UserBloc>().state.wishList!.map((e) => Product.fromMap(e)).toList();
                                              return products.contains(product)
                                                  ? Row(
                                                      children: [
                                                        const Text('"With'),
                                                        FavIcon(prodId: product.id!),
                                                        const Text(' In Your Wish List"'),
                                                      ],
                                                    )
                                                  : Row(
                                                      children: [
                                                        const Text('"Add'),
                                                        FavIcon(prodId: product.id!),
                                                        const Text(' To Your Wish-List"'),
                                                      ],
                                                    );
                                            }),
                                          ]),
                                          const SizedBox(height: 10),
                                          Divider(color: Theme.of(context).primaryColorLight, thickness: 1),
                                          const SizedBox(height: 10),
                                          const Text('Check Estimate delievery time :'),
                                          const SizedBox(height: 10),
                                          const EstimateDelivery(),
                                          const SizedBox(height: 10),
                                          Divider(color: Theme.of(context).primaryColorLight, thickness: 1),
                                          const SizedBox(height: 10),
                                          Rating(prodId: product.id!),
                                          const SizedBox(height: 20),
                                          const SizedBox(height: 10),
                                          Divider(color: Theme.of(context).primaryColorLight, thickness: 1),
                                          const SizedBox(height: 10),
                                          const Text('See All Reviews : '),
                                          product.reviews.isEmpty
                                              ? const Padding(
                                                  padding: EdgeInsets.all(15.0),
                                                  child: Center(
                                                      child: Text('No Reviews for this product exist 😓',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.normal,
                                                          ))),
                                                )
                                              : SizedBox(
                                                  height: 300,
                                                  child: Scrollbar(
                                                    thickness: 10,
                                                    child: ListView.builder(
                                                      itemCount: product.reviews.length,
                                                      itemBuilder: (context, index) => Column(
                                                        children: [
                                                          Text(
                                                            product.reviews[index]['name'],
                                                            style: TextStyle(color: Theme.of(context).primaryColor),
                                                          ),
                                                          SizedBox(
                                                            height: 30,
                                                            child: RatingBarIndicator(
                                                              itemBuilder: (context, _) => const Icon(
                                                                Icons.star,
                                                                color: Colors.amber,
                                                              ),
                                                              rating: product.reviews[index]['rating'].toDouble(),
                                                            ),
                                                          ),
                                                          Text(
                                                            product.reviews[index]['review'],
                                                            style: const TextStyle(fontWeight: FontWeight.normal), //color: Color(0xff2f3542)
                                                          ),
                                                          Divider(thickness: 1, color: Theme.of(context).primaryColorLight),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _showCart.value == true && cartState.cart != null ? AnimationPage(size: size, image: product.imageUrl, cartState: cartState) : const SizedBox.shrink()
                          ],
                        );
                      }),
                );
              },
            );
          },
        );
      },
    );
  }
}
