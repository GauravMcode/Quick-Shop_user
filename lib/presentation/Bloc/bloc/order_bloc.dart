import 'package:bloc/bloc.dart';
import 'package:user_shop/domain/repositories/order_repository.dart';
import 'package:user_shop/presentation/Bloc/events/order_events.dart';

class OrderBloc extends Bloc<OrderEvents, Map> {
  OrderBloc() : super({}) {
    on<PaymentEvent>((event, emit) async {
      Map data = await OrderRepository.payment(
        amount: event.amount,
        currency: event.currency,
        object: event.object,
        cardNumber: event.cardNumber,
        expMonth: event.expMonth,
        expYear: event.expYear,
        cvc: event.cvc,
      );
      emit(data);
    });
  }
}
