// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

part of 'package:user_shop/presentation/pages/order/order_details.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<LocationMapBloc, LatLng>(
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              SizedBox(
                height: height,
                child: GoogleMap(
                  markers: {Marker(markerId: const MarkerId('Selected'), position: state)},
                  initialCameraPosition: CameraPosition(
                    target: state,
                    zoom: 16.5,
                  ),
                  myLocationButtonEnabled: true,
                  padding: const EdgeInsets.only(top: 20.0),
                  myLocationEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  onTap: (argument) async {
                    context.read<LocationMapBloc>().add(SetLocationEvent(argument));
                    context.read<AddressMapBloc>().add(GetAddressEvent(argument));
                  },
                ),
              ),
              context.read<AddressMapBloc>().state.name == null ? const SizedBox.shrink() : const MapAddressCard(),
            ],
          ),
        );
      },
    );
  }
}

class MapAddressCard extends StatefulWidget {
  const MapAddressCard({super.key});

  @override
  State<MapAddressCard> createState() => _MapAddressCardState();
}

class _MapAddressCardState extends State<MapAddressCard> {
  @override
  void initState() {
    context.read<AddressMapBloc>().add(GetAddressEvent(context.read<LocationMapBloc>().state));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressMapBloc, Placemark>(
      builder: (context, addressState) {
        return Positioned(
          bottom: 0,
          child: SizedBox(
            width: 300,
            child: Card(
              elevation: 50,
              margin: const EdgeInsets.only(left: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Your address  : ', style: TextStyle(color: Colors.red, fontSize: 12), textAlign: TextAlign.left),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(addressState.street!, style: const TextStyle(color: Colors.orange, fontSize: 18)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${addressState.locality!}, ${addressState.subAdministrativeArea!}\n${addressState.administrativeArea!}, ${addressState.isoCountryCode!}',
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<AddressBloc>().add(SetAddressEvent(
                              line1: addressState.street,
                              line2: addressState.locality,
                              city: addressState.subAdministrativeArea,
                              state: addressState.administrativeArea,
                              country: addressState.country,
                            ));
                        Navigator.of(context).pop();
                        _currentStep.value = 1;
                        isCurrentLocation = false;
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Confirm Address'),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
