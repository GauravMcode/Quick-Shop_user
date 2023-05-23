import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:user_shop/domain/models/product.dart';
import 'package:user_shop/domain/models/user.dart';
import 'package:user_shop/presentation/Bloc/bloc/user_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/user_events.dart';
import 'package:user_shop/presentation/widgets/products/products_helper.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({super.key});

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  List<Color> gradColors = [const Color(0xffced6e0), const Color(0xff2f3542)];
  List<Product> products = [];
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(AlreadyAuthEvent());
    products = context.read<UserBloc>().state.wishList!.map((e) => Product.fromMap(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<UserBloc, User>(
      builder: (context, state) {
        context.read<UserBloc>().add(AlreadyAuthEvent());
        return products.isEmpty
            ? Center(
                child: Stack(
                  children: [
                    Center(
                      child: Lottie.asset('assets/121647-wishlist.json'),
                    ),
                    Center(
                      child: Text(
                        'Your WishList is Empty!',
                        style: TextStyle(color: Theme.of(context).primaryColorDark),
                      ),
                    ),
                  ],
                ),
              )
            : DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradColors, stops: const [0.2, 0.99]),
                ),
                child: SizedBox(
                  height: size.height,
                  width: size.width,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      SizedBox(
                        height: size.height * 0.85,
                        child: ListView(
                          children: List.generate(
                            products.length,
                            (index) => Dismissible(
                              resizeDuration: const Duration(seconds: 1),
                              background: Container(
                                color: Colors.red,
                                child: const Icon(Icons.delete),
                              ),
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                context.read<UserBloc>().add(WishListEvent(prodId: products[index].id!, action: 'delete'));
                                setState(() {
                                  products.removeAt(index);
                                });
                              },
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () => Navigator.of(context).pushNamed('/product', arguments: products[index]),
                                    child: Card(
                                      color: Colors.white.withOpacity(0.2),
                                      elevation: 50,
                                      child: Row(
                                        children: [
                                          ProductImage(products: products, index: index),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 200,
                                                child: Text(
                                                  products[index].title,
                                                  style: const TextStyle(fontSize: 15),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              SizedBox(
                                                height: 20,
                                                width: 200,
                                                child: Center(
                                                  child: RatingBarIndicator(
                                                    itemSize: 25,
                                                    itemBuilder: (context, _) => const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    rating: products[index].averageRating,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Chip(
                                                backgroundColor: Theme.of(context).primaryColor,
                                                label: Text(
                                                  'Price : ₹ ${products[index].price}',
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
      },
    );
  }
}
