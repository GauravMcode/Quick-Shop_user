import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:user_shop/presentation/Bloc/bloc/auth_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/order_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/order_events.dart';

String masterCard = "https://www.freepnglogos.com/uploads/mastercard-png/mastercard-logo-mastercard-logo-png-vector-download-19.png";
String visa = "https://www.freepnglogos.com/uploads/visa-card-logo-9.png";
String americanExpress = "https://download.logo.wine/logo/American_Express/American_Express-Logo.wine.png";

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _onValidate() async {
      if (formKey.currentState!.validate()) {
        String expMonth = expiryDate.split('/')[0];
        String expYear = expiryDate.split('/')[1];
        try {} catch (e) {
          context.read<OrderBloc>().add(PaymentEvent(
                amount: context.read<UserBloc>().state.cart?['total'],
                currency: 'USD',
                object: 'card',
                cardNumber: cardNumber,
                expMonth: expMonth,
                expYear: expYear,
                cvc: cvvCode,
              ));
        }
      } else {
        print('invalid!');
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [Color.fromARGB(244, 255, 240, 240), Color.fromARGB(0, 15, 9, 21), Colors.black],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CreditCardWidget(
              glassmorphismConfig: Glassmorphism.defaultConfig(),
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
              obscureCardCvv: true,
              isHolderNameVisible: true,
              customCardTypeIcons: [
                CustomCardTypeIcon(cardType: CardType.mastercard, cardImage: Image.network(masterCard, height: 48, width: 48)),
                CustomCardTypeIcon(cardType: CardType.visa, cardImage: Image.network(visa, height: 48, width: 48)),
                CustomCardTypeIcon(cardType: CardType.americanExpress, cardImage: Image.network(americanExpress, height: 48, width: 48)),
              ],
            ),
            const SizedBox(height: 20),
            CreditCardForm(
              formKey: formKey, // Required
              cardHolderName: cardHolderName,
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cvvCode: cvvCode,
              onCreditCardModelChange: onCreditCardModelChange, // Required
              themeColor: Colors.red,
              obscureCvv: true,
              obscureNumber: true,
              isHolderNameVisible: true,
              isCardNumberVisible: true,
              isExpiryDateVisible: true,
              enableCvv: true,
              cardNumberValidator: (String? cardNumber) {
                return null;
              },
              expiryDateValidator: (String? expiryDate) {
                return null;
              },
              cvvValidator: (String? cvv) {
                return null;
              },
              cardHolderValidator: (String? cardHolderName) {
                return null;
              },
              onFormComplete: () {
                // callback to execute at the end of filling card data
              },
              cardNumberDecoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Number',
                hintText: 'XXXX XXXX XXXX XXXX',
                hintStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
              ),
              expiryDateDecoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Expired Date',
                hintText: 'XX/XX',
                hintStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
              ),
              cvvCodeDecoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CVV',
                hintStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
                hintText: 'XXX',
              ),
              cardHolderDecoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Card Holder',
                hintStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: _onValidate,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Colors.white60, Colors.black],
                    begin: Alignment(-1, -4),
                    end: Alignment(1, 4),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text(
                  'Pay',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'halter',
                    fontSize: 14,
                    package: 'flutter_credit_card',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
