import 'package:bloc/bloc.dart';
import 'package:user_shop/domain/repositories/order_repository.dart';
import 'package:user_shop/presentation/Bloc/events/order_events.dart';

class OrderBloc extends Bloc<OrderEvents, Map> {
  OrderBloc() : super({'status': 0}) {
    on<PaymentEvent>((event, emit) async {
      Map data = await OrderRepository.payment(
        name: event.name,
        mobile: event.mobile,
        email: event.email,
        line1: event.line1,
        line2: event.line2,
        city: event.city,
        state: event.state,
        country: event.country,
      );
      emit(data);
    });

    on<ResetPaymentEvent>((event, emit) async {
      emit({'status': 0});
    });
  }
}

class OrdersBloc extends Bloc<OrderEvents, List> {
  OrdersBloc() : super([]) {
    on<GetOrdersEvent>((event, emit) async {
      Map data = await OrderRepository.fetchOrders();
      if (data['data'] != null) {
        emit(data['data']);
      }
    });
  }
}
