import 'package:user_shop/domain/models/product.dart';
import 'package:user_shop/presentation/Bloc/bloc/product_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/product_events.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_shop/presentation/widgets/input_field.dart';

class ProductPage extends StatefulWidget {
  Product product;
  ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState(product: product);
}

class _ProductPageState extends State<ProductPage> {
  Product product;
  _ProductPageState({required this.product});

  @override
  Widget build(BuildContext context) {
    TextEditingController pincodeController = TextEditingController();
    TextEditingController reviewController = TextEditingController();
    return BlocBuilder<ProductBloc, Map>(
      builder: (context, state) {
        product = context.read<ProductBloc>().state['data'] != null && context.read<ProductBloc>().state['data']?.id == product.id ? context.read<ProductBloc>().state['data'] : product;
        return WillPopScope(
          onWillPop: () async {
            // context.read<ProductListBloc>().add(GetAllProductsEvent(page: 1, limit: 3));
            return true;
          },
          child: Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 300,
                  floating: true,
                  flexibleSpace: Hero(
                    tag: '${product.id}',
                    child: Image.network(product.imageUrl),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Text(product.title, style: const TextStyle(fontSize: 25)),
                      const SizedBox(height: 10),
                      Text(product.description, style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      Text('Price: \$ ${product.price}'),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                              onPressed: () => Navigator.of(context).pushNamed('/add-product', arguments: product),
                              child: const SizedBox(
                                width: 150,
                                child: Text('Add To Cart', textAlign: TextAlign.center),
                              )),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    String title = product.title;
                                    String? id = product.id;
                                    return DeleteAlertDialog(
                                      title: title,
                                      id: id,
                                      url: product.imageUrl,
                                    );
                                  });
                            },
                            child: const SizedBox(width: 150, child: Text('Buy Now!', textAlign: TextAlign.center)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('Check Estimate delievery time :'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          FormFieldInput('Pincode', false, pincodeController, width: 100, height: 50),
                          const SizedBox(width: 10),
                          IconButton(onPressed: () {}, icon: const Icon(Icons.location_on_outlined)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('Rating'),
                      //Rating indicator
                      const SizedBox(height: 20),
                      const Text('Write a Review'),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          FormFieldInput('Your Review', false, reviewController, width: 200, height: 200),
                          IconButton(onPressed: () {}, icon: const Icon(Icons.location_on_outlined)),
                        ],
                      ),
                      const Text('Reviews : ')
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DeleteAlertDialog extends StatefulWidget {
  String title;
  String? id;
  String url;
  DeleteAlertDialog({super.key, required this.title, required this.id, required this.url});

  @override
  State<DeleteAlertDialog> createState() => _DeleteAlertDialogState(title: title, id: id, url: url);
}

class _DeleteAlertDialogState extends State<DeleteAlertDialog> {
  String title;
  String? id;
  String url;

  _DeleteAlertDialogState({required this.title, required this.id, required this.url});
  @override
  Widget build(BuildContext context) {
    Reference storage = FirebaseStorage.instance.refFromURL(url);
    return AlertDialog(
      insetPadding: const EdgeInsets.all(0),
      icon: const Icon(Icons.delete),
      title: Text('Delete $title'),
      content: const SizedBox(height: 100, width: 200, child: Center(child: Text('Do you want to delete all units of this product?'))),
      actions: [
        ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        const SizedBox(width: 20),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // context.read<ProductListBloc>().add(GetAllProductsEvent(1));
              Navigator.of(context).pop();
              storage.delete();
            },
            child: const Text('Delete')),
      ],
    );
  }
}
