import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/util_events.dart';

class SizeBloc extends Bloc<UtilEvents, Size> {
  SizeBloc() : super(const Size(0, 0)) {
    on<SizeEvents>((event, emit) {});
  }
}
