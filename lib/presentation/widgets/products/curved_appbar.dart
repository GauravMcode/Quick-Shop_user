import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_shop/domain/models/user.dart';
import 'package:user_shop/presentation/Bloc/bloc/cart_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/product_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/user_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/product_events.dart';
import 'package:user_shop/presentation/widgets/input_field.dart';

class CurvedAppBar extends StatelessWidget {
  const CurvedAppBar({
    super.key,
    required this.size,
    required this.searchController,
  });

  final Size size;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, User>(
      builder: (context, userState) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: BlocBuilder<SearchProductsBloc, Map>(
            builder: (context, searchState) {
              if (searchController.text == '') {
                context.read<SearchProductsBloc>().add(ResetSearchProductsEvent());
              }
              return ClipPath(
                clipper: TopClipper(searchState['data']),
                child: AnimatedContainer(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 100),
                  width: size.width,
                  height: 180 + 70 * (searchState['data'].length as int).toDouble(),
                  child: Material(
                    shadowColor: const Color.fromARGB(255, 195, 173, 133), //0xffffa502
                    color: Theme.of(context).primaryColor,
                    elevation: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Hi, ${userState.name}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const Spacer(flex: 1),
                            CircleAvatar(
                              child: CachedNetworkImage(
                                imageUrl: 'https://st.depositphotos.com/1005920/1471/i/950/depositphotos_14713611-stock-photo-shopping-cart-icon.jpg',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const Spacer(flex: 1),
                            BlocBuilder<CartBloc, User>(
                              builder: (context, cartState) {
                                final number = cartState.cart?['number'] ?? userState.cart?['number'];
                                return Stack(
                                  children: [
                                    IconButton(
                                      onPressed: () => Navigator.of(context).pushNamed('/cart'),
                                      icon: const Icon(Icons.shopping_cart_outlined),
                                    ),
                                    number == null || number == 0
                                        ? const SizedBox.shrink()
                                        : Positioned(
                                            right: 2,
                                            top: 6,
                                            child: CircleAvatar(
                                              radius: 7,
                                              child: Text(
                                                "$number",
                                                style: const TextStyle(fontSize: 10),
                                              ),
                                            ),
                                          )
                                  ],
                                );
                              },
                            )
                          ],
                        ),
                        Expanded(
                            child: SizedBox(
                          height: 100 + 50 * (searchState['data'].length as int).toDouble(),
                          child: SearchPage(
                            state: searchState,
                            searchController: searchController,
                          ),
                        )),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key, required this.state, required this.searchController});
  final Map state;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormFieldInput('Search for products', false, searchController, onChanged: (value) => context.read<SearchProductsBloc>().add(SearchProductsEvent(search: searchController.text))),
        const SizedBox(height: 10),
        Flexible(
            child: ListView.builder(
          itemCount: state['data']?.length ?? 0,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  title: Text(state['data'][index].title, overflow: TextOverflow.ellipsis),
                  subtitle: Text(state['data'][index].description, overflow: TextOverflow.ellipsis),
                  leading: Hero(tag: state['data'][index].id, child: Image.network(state['data'][index].imageUrl)),
                  trailing: Text('₹ ${state['data'][index].price}'),
                  onTap: () => Navigator.of(context).pushNamed('/product', arguments: state['data'][index]),
                ),
              ],
            );
          },
        ))
      ],
    );
  }
}

class TopClipper extends CustomClipper<Path> {
  List search;
  TopClipper(this.search);
  @override
  getClip(Size size) {
    Path path1 = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..quadraticBezierTo(size.width * 0.85, size.height * 0.75, size.width * 0.5, size.height * 0.8)
      ..lineTo(size.width * 0.3, size.height * 0.8)
      ..quadraticBezierTo(-15, size.height * 0.8, 0, 0); //control pont and end point; control point -> controls the degree and orientation of curve, endpoint means to which point the curve should go

    Path path2 = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..quadraticBezierTo(size.width * 0.9, size.height * 0.95, size.width * 0.8, size.height * 0.96)
      ..lineTo(size.width * 0.2, size.height * 0.96)
      ..quadraticBezierTo(-150, size.height * 0.9, 0, 0);

    return search.isEmpty ? path1 : path2;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}
