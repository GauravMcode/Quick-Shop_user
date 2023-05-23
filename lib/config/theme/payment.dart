// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart';
// import 'package:user_shop/data/local/local_data.dart';
// import 'package:user_shop/data/remote/remote_data.dart';

// class PaymentPage extends StatefulWidget {
//   const PaymentPage({super.key});

//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Spacer(),
//           ElevatedButton(
//               onPressed: () async {
//                 final jwt = await JwtProvider.getJwt();
//                 Response response = await DataProvider.getData('payment', jwt: jwt);
//                 final data = json.decode(response.body);
//                 if (data['success'] == true) {
//                   paymentWidget(data);
//                 }
//               },
//               child: const Text('Proceed to Payment')),
//         ],
//       ),
//     );
//   }

//   Future<void> paymentWidget(data) async {
//     try {
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//             paymentIntentClientSecret: data['paymentIntent'],
//             merchantDisplayName: 'Flutter Shop',
//             customerId: data['customer'],
//             customerEphemeralKeySecret: data['ephemeralKey'],
//             style: ThemeMode.dark,
//             googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'IN', currencyCode: 'INR', testEnv: true)),
//       );

//       await Stripe.instance.presentPaymentSheet();

//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment succesfull'), duration: Duration(seconds: 1)));
//     } catch (e) {
//       if (e is StripeException) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment failed'), duration: Duration(seconds: 1)));
//       }
//     }
//   }
// }
