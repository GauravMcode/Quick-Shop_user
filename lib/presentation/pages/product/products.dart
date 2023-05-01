import 'package:user_shop/domain/models/product.dart';
import 'package:user_shop/presentation/Bloc/bloc/cart_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/product_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/cart_events.dart';
import 'package:user_shop/presentation/Bloc/events/product_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_shop/presentation/widgets/products_helper.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductListBloc>().add(GetAllProductsEvent(page: 1, limit: 3));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListBloc, Map>(
      builder: (context, state) {
        List<Product> products = state['data'] ?? [];
        int count = state['count'] ?? 0;
        return state.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
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
                                      ProductImage(products: products, index: index),
                                      ProductOverview(products: products, index: index),
                                    ],
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    context.read<CartBloc>().add(CartEvent(prodId: products[index].id!, task: "add"));
                                  },
                                  icon: const Icon(Icons.shopping_cart_checkout_rounded),
                                  label: const Text('Add to Cart'),
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
                      index == products.length - 1 ? const SizedBox(height: 20) : const SizedBox.shrink(),
                      index == products.length - 1 ? PaginationSegment(pages: count) : const SizedBox.shrink(),
                    ],
                  );
                },
              );
      },
    );
  }
}
