import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:user_shop/domain/models/product.dart';
import 'package:user_shop/presentation/Bloc/bloc/product_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/user_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/product_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/user_events.dart';
import 'package:user_shop/presentation/widgets/products/curved_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:user_shop/presentation/widgets/products/horizontal_scroll_list.dart';
import 'package:user_shop/presentation/widgets/products/products_helper.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  int itemsInPage = 8;
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(AlreadyAuthEvent());
    context.read<ProductListBloc>().add(GetAllProductsEvent(page: 0, limit: itemsInPage, category: _selectedCategory));
  }

  Future<Uint8List> loadUiImage(String url) async {
    final response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  final TextEditingController searchController = TextEditingController();
  String _selectedCategory = categories[0];
  List<Color> gradColors = [const Color(0xffced6e0), const Color(0xff2f3542)];
  List<Color> colors = [const Color(0xffffa502), const Color.fromARGB(255, 239, 232, 232)];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ProductListBloc, Map>(
      builder: (context, state) {
        List<Product> products = state['data'] ?? [];
        int count = state['count'] ?? 0;
        return state.isEmpty
            ? Center(
                child: Lottie.asset('assets/143310-loader.json'),
              )
            : DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(colors: gradColors, center: Alignment.center, stops: const [0.2, 0.99]),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      height: size.height,
                      width: size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 130),
                            SizedBox(
                              height: 120,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: List.generate(
                                  categories.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      splashColor: Theme.of(context).primaryColor,
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory = categories[index];
                                        });
                                        context.read<ProductListBloc>().add(GetAllProductsEvent(page: 0, limit: itemsInPage, category: _selectedCategory));
                                      },
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                              radius: 40,
                                              backgroundColor: _selectedCategory == categories[index] ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark,
                                              child: Image.asset(
                                                'assets/categories/${categories[index]}.png',
                                                fit: BoxFit.scaleDown,
                                              )),
                                          ShaderMask(
                                            shaderCallback: (bounds) => RadialGradient(colors: _selectedCategory == categories[index] ? colors.reversed.toList() : gradColors).createShader(bounds),
                                            child: Text(
                                              categories[index],
                                              style: TextStyle(color: _selectedCategory == categories[index] ? colors[0] : gradColors[1]),
                                            ),
                                          ),
                                          // Text(categories[index])
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            HorizontalScrollList(products: products),
                            const SizedBox(height: 10),
                            StaggeredGrid.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              children: List.generate(
                                  products.length,
                                  (index) => InkWell(
                                        onTap: () => Navigator.of(context).pushNamed('/product', arguments: products[index]),
                                        child: Card(
                                          elevation: 40,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          child: Column(
                                            children: [
                                              ProductImage(products: products, index: index),
                                              ProductOverview(products: products, index: index),
                                            ],
                                          ),
                                        ),
                                      )),
                            ),
                            SizedBox(
                              height: 20,
                              child: PaginationSegment(pages: count, limit: itemsInPage, selectedCategory: _selectedCategory),
                            ),
                            const SizedBox(height: 20)
                          ],
                        ),
                      ),
                    ),
                    CurvedAppBar(size: size, searchController: searchController),
                  ],
                ),
              );
      },
    );
  }
}

final List<String> categories = ['All', 'Electronics', 'Clothing', 'Books', 'Jwellery', 'Household', 'Office', 'Shoes'];
