import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_shop/domain/models/user.dart';
import 'package:user_shop/presentation/Bloc/bloc/auth_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/auth_events.dart';
import 'package:user_shop/presentation/pages/product/products.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(AlreadyAuthEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: BlocBuilder<UserBloc, User>(
        builder: (context, state) {
          print(state);
          return const Center();
        },
      ),
    );
  }
}
