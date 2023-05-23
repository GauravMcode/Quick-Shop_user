import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/order_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/order_events.dart';
import 'package:user_shop/presentation/pages/order/order_details.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(GetOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, List>(
      builder: (context, state) {
        final List orders = state.reversed.toList();
        return Scaffold(
            appBar: AppBar(
              title: Text('My Orders', style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 20, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            body: state.isEmpty
                ? const Center(child: Text('No Orders yet'))
                : ListView(
                    children: List.generate(
                      orders.length,
                      (index1) => Padding(
                        padding: const EdgeInsets.only(bottom: 15.0, top: 5),
                        child: Card(
                          elevation: 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(child: Text('Order Total : ₹${orders[index1]['details']['total']}', style: TextStyle(color: Theme.of(context).primaryColor))),
                              const SizedBox(height: 10),
                              InteractiveViewer(
                                child: FittedBox(
                                  child: DataTable(
                                    decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColorLight)),
                                    border: TableBorder.all(),
                                    columns: [
                                      DataColumn(
                                          label:
                                              Padding(padding: const EdgeInsets.only(left: 100), child: Text('Product', style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColorLight)))),
                                      DataColumn(label: Text('unit price', style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColorLight))),
                                      DataColumn(label: Text('quantity', style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColorLight))),
                                      DataColumn(label: Text('Price', style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColorLight)))
                                    ],
                                    rows: List.generate(orders[index1]['details']['items'].length, (index2) {
                                      var product = orders[index1]['details']['items'][index2];
                                      return DataRow(cells: [
                                        DataCell(
                                          Row(
                                            children: [
                                              CircleAvatar(backgroundImage: NetworkImage(product['id']['imageUrl'])),
                                              const SizedBox(width: 10),
                                              SizedBox(width: 200, child: Text(product['id']['title'], overflow: TextOverflow.ellipsis, style: const TextStyle())),
                                            ],
                                          ),
                                        ),
                                        DataCell(Text('₹${product['id']['price']}', style: const TextStyle())),
                                        DataCell(Text('${product['quantity']}', style: const TextStyle())),
                                        DataCell(Text('₹${product['id']['price'] * product['quantity']}', style: const TextStyle())),
                                      ]);
                                    }),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              InvoiceWidget(url: orders[index1]['invoiceLink']),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
      },
    );
  }
}
