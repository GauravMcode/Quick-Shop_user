import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/order_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/order_events.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          ElevatedButton(onPressed: () => context.read<OrderBloc>().add(PaymentEvent()), child: const Text('Proceed to Payment')),
        ],
      ),
    );
  }
}
