import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_shop/domain/repositories/map_repository.dart';
import 'package:user_shop/presentation/Bloc/events/map_events.dart';

class LocationMapBloc extends Bloc<MapEvents, LatLng> {
  LocationMapBloc() : super(const LatLng(0, 0)) {
    on<GetLocationEvent>((event, emit) async {
      print('executing get location event.....');
      Position position = await MapRepository.getLocation();
      emit(LatLng(position.latitude, position.longitude));
    });

    on<SetLocationEvent>((event, emit) async {
      emit(event.latLng);
    });
  }
}

class AddressMapBloc extends Bloc<MapEvents, Placemark> {
  AddressMapBloc() : super(Placemark()) {
    on<GetAddressEvent>((event, emit) async {
      Placemark address = await MapRepository.getAddress(lat: event.latLng.latitude, long: event.latLng.longitude);
      emit(address);
    });
  }
}

class AddressBloc extends Bloc<AddressEvents, Map> {
  AddressBloc()
      : super({
          "name": '',
          "mobile": '',
          "line1": '',
          "line2": '',
          "city": '',
          "state": '',
          "country": '',
        }) {
    on<SetAddressEvent>((event, emit) {
      Map address = {
        "name": event.name ?? state['name'] ?? '',
        "mobile": event.mobile ?? state['mobile'] ?? '',
        "line1": event.line1 ?? state['line1'] ?? '',
        "line2": event.line2 ?? state['line2'] ?? '',
        "city": event.city ?? state['city'] ?? '',
        "state": event.state ?? state['state'] ?? '',
        "country": event.country ?? state['country'] ?? '',
      };
      emit(address);
    });

    on<ResetAddressEvent>((event, emit) {
      emit({
        "name": '',
        "mobile": '',
        "line1": '',
        "line2": '',
        "city": '',
        "state": '',
        "country": '',
      });
    });
  }
}
