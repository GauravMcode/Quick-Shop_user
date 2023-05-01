import 'package:flutter/material.dart';
import 'package:user_shop/domain/models/product.dart';
import 'package:user_shop/presentation/Bloc/bloc/product_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/product_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

int currentPage = 1;
int limit = 2;

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.products,
    required this.index,
  });

  final List<Product> products;
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
                tag: '${products[index].id}',
                child: Image.network(
                  products[index].imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ));
  }
}

class ProductOverview extends StatelessWidget {
  const ProductOverview({super.key, required this.products, required this.index});

  final List<Product> products;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            products[index].title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Chip(avatar: const Icon(Icons.monetization_on_outlined), label: Text('Price: ${products[index].price}')),
            ],
          ),
        ],
      ),
    );
  }
}

class PaginationSegment extends StatefulWidget {
  PaginationSegment({super.key, required this.pages});
  int pages;

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
              // print(value);
              setState(() {
                currentPage = value.first;
                context.read<ProductListBloc>().add(GetAllProductsEvent(page: currentPage - 1, limit: limit));
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
                  // print(value);
                  setState(() {
                    currentPage = value.first;
                    context.read<ProductListBloc>().add(GetAllProductsEvent(page: currentPage - 1, limit: limit));
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
                  // print(value);
                  setState(() {
                    currentPage = value.first;
                    if (currentPage == 1 || currentPage == pageCount) {
                      middlePage = 2;
                    } else {
                      middlePage = currentPage;
                    }
                    // print('current page : $currentPage');
                    context.read<ProductListBloc>().add(GetAllProductsEvent(page: currentPage - 1, limit: limit));
                  });
                },
              );
  }
}
