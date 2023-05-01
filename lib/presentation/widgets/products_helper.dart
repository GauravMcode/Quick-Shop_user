import 'package:flutter/material.dart';
import 'package:user_shop/presentation/Bloc/bloc/cart_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/product_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/cart_events.dart';
import 'package:user_shop/presentation/Bloc/events/product_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

int currentPage = 1;
int limit = 2;

class ProductImage extends StatelessWidget {
  ProductImage({
    super.key,
    required this.products,
    required this.index,
    this.cart = false,
  });
  bool cart;
  final List products;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 150,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PhysicalModel(
            elevation: 20,
            color: const Color.fromARGB(255, 0, 30, 44).withOpacity(0.1),
            shadowColor: const Color.fromARGB(255, 217, 213, 213),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Hero(
                tag: '${cart ? products[index]['id']['_id'] : products[index].id}',
                child: Image.network(
                  cart ? products[index]['id']['imageUrl'] : products[index].imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ));
  }
}

class ProductOverview extends StatelessWidget {
  ProductOverview({super.key, required this.products, required this.index, this.cart = false});

  final List products;
  final int index;
  bool cart;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            cart ? products[index]['id']['title'] : products[index].title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Chip(avatar: const Icon(Icons.monetization_on_outlined), label: Text('Price: ${cart ? products[index]['id']['price'] : products[index].price}')),
            ],
          ),
        ],
      ),
    );
  }
}

class CartProductOverview extends StatelessWidget {
  const CartProductOverview({super.key, required this.products, required this.index});

  final List products;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            products[index]['id']['title'],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Chip(avatar: const Icon(Icons.monetization_on_outlined), label: Text('Price: ${products[index]['id']['price']}')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: () => context.read<CartBloc>().add(CartEvent(prodId: products[index]['id']['_id'], task: 'delete')), icon: const Icon(Icons.remove_circle_outline)),
              Text(
                'Quantity : ${products[index]['quantity']}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              IconButton(onPressed: () => context.read<CartBloc>().add(CartEvent(prodId: products[index]['id']['_id'], task: 'add')), icon: const Icon(Icons.add_box_outlined)),
            ],
          )
        ],
      ),
    );
  }
}

class PaginationSegment extends StatefulWidget {
  PaginationSegment({super.key, required this.pages, required this.limit});
  int pages;
  int limit;
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
                context.read<ProductListBloc>().add(GetAllProductsEvent(page: currentPage - 1, limit: widget.limit));
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
                    context.read<ProductListBloc>().add(GetAllProductsEvent(page: currentPage - 1, limit: widget.limit));
                  });
                },
              )
            : SegmentedButton<int>(
                segments: [
                  const ButtonSegment(value: 1, label: Text('1')),
                  ButtonSegment(value: middlePage, label: Text('$middlePage')),
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
                    context.read<ProductListBloc>().add(GetAllProductsEvent(page: currentPage - 1, limit: widget.limit));
                  });
                },
              );
  }
}
