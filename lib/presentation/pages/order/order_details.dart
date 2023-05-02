import 'package:flutter/material.dart';

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
        children: [
          const Spacer(),
          ElevatedButton(onPressed: () => Navigator.of(context).pushNamed('/payment'), child: const Text('Proceed to Payment')),
        ],
      ),
    );
  }
}
