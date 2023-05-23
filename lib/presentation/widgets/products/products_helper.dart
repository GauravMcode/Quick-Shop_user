import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:user_shop/presentation/Bloc/bloc/cart_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/product_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/cart_events.dart';
import 'package:user_shop/presentation/Bloc/events/product_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

int currentPage = 1;
int limit = 2;

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.products,
    required this.index,
    this.cart = false,
  });
  final bool cart;
  final List products;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PhysicalModel(
          elevation: 40,
          color: const Color.fromARGB(255, 0, 30, 44).withOpacity(0.1),
          shadowColor: const Color.fromARGB(255, 188, 176, 176),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Hero(
              tag: '${cart ? products[index]['id']['_id'] : products[index].id}',
              child: CachedNetworkImage(
                  key: UniqueKey(),
                  imageUrl: cart ? products[index]['id']['imageUrl'] : products[index].imageUrl,
                  fit: BoxFit.contain,
                  progressIndicatorBuilder: (context, url, progress) => Center(
                        child: Lottie.asset('assets/143310-loader.json', width: 150, height: 100),
                      )),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductOverview extends StatelessWidget {
  const ProductOverview({super.key, required this.products, required this.index, this.cart = false});

  final List products;
  final int index;
  final bool cart;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          cart ? products[index]['id']['title'] : products[index].title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        // const SizedBox(height: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 35.0),
              child: SizedBox(
                height: 20,
                width: 200,
                child: RatingBarIndicator(
                  itemSize: 20,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  rating: products[index].averageRating,
                ),
              ),
            ),
            Chip(
                backgroundColor: Theme.of(context).primaryColor,
                label: Text(
                  'Price : ₹ ${cart ? products[index]['id']['price'] : products[index].price}',
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
          ],
        ),
      ],
    );
  }
}

class CartProductOverview extends StatelessWidget {
  const CartProductOverview({super.key, required this.products, required this.index});

  final List products;
  final int index;

  @override
  Widget build(BuildContext context) {
    int? quant = products[index]?['quantity'];
    int? price = products[index]['id']?['price'];
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            products[index]['id']['title'],
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chip(avatar: const Icon(Icons.monetization_on_outlined), label: Text('Price: ${products[index]['id']['price']}')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => context.read<CartBloc>().add(CartEvent(prodId: products[index]['id']['_id'], task: 'delete')),
                icon: const Icon(Icons.remove_circle_outline, color: Color(0xffffa502)),
              ),
              Text(
                'Quantity : ${products[index]['quantity']}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => context.read<CartBloc>().add(CartEvent(prodId: products[index]['id']['_id'], task: 'add')),
                icon: const Icon(Icons.add_box_outlined, color: Color(0xffffa502)),
              ),
            ],
          ),
          Text(
            'Price : ₹ ${quant != null && price != null ? quant * price : 0}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class PaginationSegment extends StatefulWidget {
  const PaginationSegment({super.key, required this.pages, required this.limit, required this.selectedCategory});
  final int pages;
  final int limit;
  final String selectedCategory;
  @override
  State<PaginationSegment> createState() => _PaginationSegmentState(pages);
}

class _PaginationSegmentState extends State<PaginationSegment> {
  int pageCount;
  _PaginationSegmentState(this.pageCount);
  int middlePage = 2;

  @override
  Widget build(BuildContext context) {
    if (currentPage == 1 || currentPage == pageCount) {
      middlePage = 2;
    } else {
      middlePage = currentPage;
    }
    return pageCount == 1
        ? SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 1, label: Text('1')),
            ],
            selected: <int>{currentPage},
            onSelectionChanged: (Set<int> value) {
              setState(() {
                currentPage = value.first;
                context.read<ProductListBloc>().add(GetAllProductsEvent(page: currentPage - 1, limit: widget.limit, category: widget.selectedCategory));
              });
            },
          )
        : pageCount == 2
            ? SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 1, label: Text('1')),
                  ButtonSegment(value: 2, label: Text('2')),
                ],
                selected: <int>{currentPage},
                onSelectionChanged: (Set<int> value) {
                  setState(() {
                    currentPage = value.first;
                    context.read<ProductListBloc>().add(GetAllProductsEvent(page: currentPage - 1, limit: widget.limit, category: widget.selectedCategory));
                  });
                },
              )
            : SegmentedButton<int>(
                segments: [
                  const ButtonSegment(value: 1, label: Text('1')),
                  ButtonSegment(value: middlePage, label: Text('$middlePage')),
                  ButtonSegment(
                      value: currentPage == pageCount ? pageCount - 1 : middlePage + 1,
                      label: Text('${currentPage == pageCount ? '..' : middlePage + 1 == pageCount ? '..' : middlePage + 1}')),
                  ButtonSegment(value: pageCount, label: Text('$pageCount')),
                ],
                selected: <int>{currentPage},
                onSelectionChanged: (Set<int> value) {
                  setState(() {
                    currentPage = value.first;
                    if (currentPage == 1 || currentPage == pageCount) {
                      middlePage = 2;
                    } else {
                      middlePage = currentPage;
                    }
                    context.read<ProductListBloc>().add(GetAllProductsEvent(page: currentPage - 1, limit: widget.limit, category: widget.selectedCategory));
                  });
                },
              );
  }
}
