abstract class OrderEvents {}

class PaymentEvent extends OrderEvents {
  String amount;
  String currency;
  String object;
  String cardNumber;
  String expMonth;
  String expYear;
  String cvc;
  PaymentEvent({
    required this.amount,
    required this.currency,
    required this.object,
    required this.cardNumber,
    required this.expMonth,
    required this.expYear,
    required this.cvc,
  });
}
