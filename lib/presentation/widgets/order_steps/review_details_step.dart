part of 'package:user_shop/presentation/pages/order/order_details.dart';

ValueNotifier<bool> _isPaying = ValueNotifier<bool>(false);

class ReviewOrder extends StatefulWidget {
  const ReviewOrder({super.key});

  @override
  State<ReviewOrder> createState() => _ReviewOrderState();
}

class _ReviewOrderState extends State<ReviewOrder> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _isPaying,
        builder: (context, value, child) {
          return value
              ? BlocBuilder<OrderBloc, Map>(
                  builder: (context, state) {
                    if (state['status'] == 200) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // context.read<OrdersBloc>().add(GetOrdersEvent());
                        final position = _controller.position.minScrollExtent;
                        _controller.animateTo(position, duration: const Duration(microseconds: 1), curve: Curves.linear);
                        _currentStep.value = 2;
                        _isPaying.value = false;
                      });
                    }
                    return const ProgressIndicator();
                  },
                )
              : BlocBuilder<AddressBloc, Map>(
                  builder: (context, state) {
                    return BlocBuilder<UserBloc, User>(
                      builder: (context, userState) {
                        return DefaultTextStyle(
                          style: TextStyle(color: Theme.of(context).primaryColorLight),
                          child: Column(
                            children: [
                              const Text('Shipped To: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 100,
                                width: double.infinity,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColorLight)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(state['line1'] + ',', style: const TextStyle(fontSize: 15)),
                                        Text(state['line2'] + ',', style: const TextStyle(fontSize: 15)),
                                        Text('${state['city'] + ','}', style: const TextStyle(fontSize: 15)),
                                        Text(state['state'] + ', ' + state['country'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text('Customer details : ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 80,
                                width: double.infinity,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColorLight)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('name : ${state['name']},', style: const TextStyle(fontSize: 15)),
                                        Text('mobile : ${state['mobile']},', style: const TextStyle(fontSize: 15)),
                                        Text('email : ${context.read<UserBloc>().state.email},', style: const TextStyle(fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text('Order details : ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                              const SizedBox(height: 10),
                              InteractiveViewer(
                                child: FittedBox(
                                  child: DataTable(
                                    border: TableBorder.all(color: Theme.of(context).primaryColorLight),
                                    columns: const [
                                      DataColumn(label: Padding(padding: EdgeInsets.only(left: 100), child: Text('Product', style: TextStyle(color: Colors.white, fontSize: 20)))),
                                      DataColumn(label: Text('unit price', style: TextStyle(color: Colors.white, fontSize: 20))),
                                      DataColumn(label: Text('quantity', style: TextStyle(color: Colors.white, fontSize: 20))),
                                      DataColumn(label: Text('Price', style: TextStyle(color: Colors.white, fontSize: 20)))
                                    ],
                                    rows: List.generate(userState.cart!['items'].length, (index) {
                                      var product = userState.cart!['items'][index];
                                      return DataRow(cells: [
                                        DataCell(
                                          Row(
                                            children: [
                                              CircleAvatar(backgroundImage: NetworkImage(product['id']['imageUrl'])),
                                              const SizedBox(width: 10),
                                              SizedBox(width: 200, child: Text(product['id']['title'], overflow: TextOverflow.ellipsis, style: TextStyle(color: Theme.of(context).primaryColorLight))),
                                            ],
                                          ),
                                        ),
                                        DataCell(Text('₹${product['id']['price']}', style: TextStyle(color: Theme.of(context).primaryColorLight))),
                                        DataCell(Text('${product['quantity']}', style: TextStyle(color: Theme.of(context).primaryColorLight))),
                                        DataCell(Text('₹${product['id']['price'] * product['quantity']}', style: TextStyle(color: Theme.of(context).primaryColorLight))),
                                      ]);
                                    }),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text('Total Price : ₹ ${userState.cart!['total']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  _isPaying.value = true;
                                },
                                child: const Text('Proceed to Payment'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
        });
  }
}

class ProgressIndicator extends StatefulWidget {
  const ProgressIndicator({
    super.key,
  });

  @override
  State<ProgressIndicator> createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    final Map addressState = context.read<AddressBloc>().state;

    Future<bool?> hasSucceed = handlingPayment();
    return FutureBuilder(
        future: hasSucceed,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.data == true) {
            context.read<OrderBloc>().add(PaymentEvent(
                  name: addressState['name'],
                  mobile: addressState['mobile'],
                  email: context.read<UserBloc>().state.email,
                  line1: addressState['line1'],
                  line2: addressState['line2'],
                  city: addressState['city'],
                  state: addressState['state'],
                  country: addressState['country'].contains('      ') ? addressState['country'].split(' ')[0] : addressState['country'],
                ));
          }
          return Center(
              child: Column(
            children: [
              const SizedBox(height: 100),
              Lottie.asset('assets/84762-payment-process.json'),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Processing Paymnet'),
              ),
            ],
          ));
        });
  }

  Future<bool?> handlingPayment() async {
    final jwt = await JwtProvider.getJwt();
    final response = await DataProvider.getData('payment/user', jwt: jwt);
    final data = json.decode(response.body);
    if (data['success'] == true) {
      return await paymentWidget(data);
    }
    return null;
  }

  Future<bool?> paymentWidget(data) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: data['paymentIntent'],
            merchantDisplayName: 'Flutter Shop',
            customerId: data['customer'],
            customerEphemeralKeySecret: data['ephemeralKey'],
            style: ThemeMode.dark,
            googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'IN', currencyCode: 'INR', testEnv: true)),
      );

      await Stripe.instance.presentPaymentSheet();

      return true;
    } catch (e) {
      if (e is StripeException) {
        _isPaying.value = false;
        return false;
      }
    }
    return null;
  }
}
