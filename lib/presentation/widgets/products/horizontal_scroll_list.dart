import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:user_shop/domain/models/product.dart';
import 'package:user_shop/domain/models/user.dart';
import 'package:user_shop/presentation/Bloc/bloc/user_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/user_events.dart';

class HorizontalScrollList extends StatefulWidget {
  const HorizontalScrollList({
    super.key,
    required this.products,
  });

  final List<Product> products;

  @override
  State<HorizontalScrollList> createState() => _HorizontalScrollListState();
}

class _HorizontalScrollListState extends State<HorizontalScrollList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Builder(builder: (context) {
        final shuffledProducts = widget.products.reversed.toList();
        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            Product product = shuffledProducts[index];
            return InkWell(
              onTap: () => Navigator.of(context).pushNamed('/product', arguments: product),
              child: DecoratedBox(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    children: [
                      ShaderMask(
                        blendMode: BlendMode.srcATop,
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.1, 0.2, 0.3, 0.9],
                          ).createShader(bounds);
                        },
                        child: Card(
                          elevation: 40,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: CachedNetworkImage(
                                key: UniqueKey(),
                                imageUrl: product.imageUrl,
                                fit: BoxFit.scaleDown,
                                progressIndicatorBuilder: (context, url, progress) {
                                  return Center(
                                    child: Lottie.asset('assets/143310-loader.json', width: 150, height: 100),
                                  );
                                }),
                          ),
                        ),
                      ),
                      Positioned(top: 5, left: 10, child: FavIcon(prodId: shuffledProducts[index].id!)),
                      Positioned(
                          bottom: 30,
                          left: 10,
                          right: 10,
                          child: SizedBox(
                            height: 20,
                            child: Text(
                              product.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          )),
                      Positioned(
                          bottom: 10,
                          left: 50,
                          right: 50,
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 20,
                              child: Text(
                                '₹ ${product.price}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: widget.products.length,
          scrollDirection: Axis.horizontal,
        );
      }),
    );
  }
}

class FavIcon extends StatefulWidget {
  const FavIcon({
    super.key,
    required this.prodId,
  });
  final String prodId;

  @override
  State<FavIcon> createState() => _FavIconState();
}

class _FavIconState extends State<FavIcon> {
  final ValueNotifier<bool> _selectState = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, User>(
      builder: (context, wishState) {
        if (wishState.wishList!.isEmpty) {
          _selectState.value = false;
        }
        for (var i = 0; i < wishState.wishList!.length; i++) {
          if (wishState.wishList![i]['_id'] == widget.prodId) {
            _selectState.value = true;
            break;
          } else if (i == wishState.wishList!.length - 1 && wishState.wishList![i]['_id'] != widget.prodId) {
            _selectState.value = false;
          }
        }
        return ValueListenableBuilder(
            valueListenable: _selectState,
            builder: (context, value, child) {
              return wishState.loading == 'wishlist'
                  ? Padding(
                      padding: const EdgeInsets.only(left: 4.0, top: 8),
                      child: LottieBuilder.asset(
                        'assets/67843-swinging-heart.json',
                        height: 40,
                        width: 40,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        if (wishState.wishList!.isEmpty) {
                          context.read<UserBloc>().add(WishListEvent(prodId: widget.prodId, action: 'add'));
                          setState(() {});
                          // _selectState.value = !_selectState.value;
                          return;
                        }
                        for (var i = 0; i < wishState.wishList!.length; i++) {
                          if (wishState.wishList![i]['_id'] == widget.prodId) {
                            context.read<UserBloc>().add(WishListEvent(prodId: widget.prodId, action: 'delete'));
                            setState(() {});

                            return;

                            // _selectState.value = !_selectState.value;
                          } else if (i == wishState.wishList!.length - 1 && wishState.wishList![i]['_id'] != widget.prodId) {
                            context.read<UserBloc>().add(WishListEvent(prodId: widget.prodId, action: 'add'));
                            setState(() {});

                            // _selectState.value = !_selectState.value;
                          }
                        }
                      },
                      icon: Icon(
                        Icons.favorite_rounded,
                        size: 35,
                        color: _selectState.value ? const Color.fromARGB(255, 169, 72, 65) : Colors.white,
                      ));
            });
      },
    );
  }
}

// Image.network(
//                               product.imageUrl,
//                               fit = BoxFit.scaleDown,
//                               loadingBuilder = (context, child, loadingProgress) {
//                                 if (loadingProgress == null) return child;
//                                 return Center(
//                                     child: CircularProgressIndicator(
//                                   value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
//                                   color: Theme.of(context).primaryColor,
//                                 ));
//                               },
//                             ),