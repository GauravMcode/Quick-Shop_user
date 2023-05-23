abstract class OrderEvents {}

class PaymentEvent extends OrderEvents {
  String name;
  String mobile;
  String email;
  String line1;
  String line2;
  String city;
  String state;
  String country;
  PaymentEvent({
    required this.name,
    required this.mobile,
    required this.email,
    required this.line1,
    required this.line2,
    required this.city,
    required this.state,
    required this.country,
  });
}

class ResetPaymentEvent extends OrderEvents {}

class GetOrdersEvent extends OrderEvents {}
