import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:user_shop/domain/repositories/order_repository.dart';
import 'package:user_shop/presentation/Bloc/events/order_events.dart';

class OrderBloc extends Bloc<OrderEvents, Map> {
  OrderBloc() : super({}) {
    on<PaymentEvent>((event, emit) async {
      Map data = await OrderRepository.payment();
      if (data['status'] == 200) {
        emit(data);
      }
    });
  }
}
