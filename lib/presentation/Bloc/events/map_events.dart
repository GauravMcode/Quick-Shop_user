import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapEvents {}

class GetLocationEvent extends MapEvents {}

class SetLocationEvent extends MapEvents {
  LatLng latLng;
  SetLocationEvent(this.latLng);
}

class GetAddressEvent extends MapEvents {
  LatLng latLng;
  GetAddressEvent(this.latLng);
}

abstract class AddressEvents {}

class SetAddressEvent extends AddressEvents {
  String? name;
  String? mobile;
  String? line1;
  String? line2;
  String? city;
  String? state;
  String? country;
  SetAddressEvent({this.name, this.mobile, this.line1, this.line2, this.city, this.state, this.country});
}

class ResetAddressEvent extends AddressEvents {}
