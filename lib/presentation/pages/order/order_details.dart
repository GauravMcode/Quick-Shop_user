import 'dart:convert';
import 'dart:io';

import 'package:csc_picker/csc_picker.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart' hide Marker;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:user_shop/data/local/local_data.dart';
import 'package:user_shop/data/remote/remote_data.dart';
import 'package:user_shop/domain/models/user.dart';
import 'package:user_shop/presentation/Bloc/bloc/cart_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/map_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/order_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/user_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/cart_events.dart';
import 'package:user_shop/presentation/Bloc/events/map_events.dart';
import 'package:user_shop/presentation/Bloc/events/order_events.dart';
import 'package:user_shop/presentation/Bloc/events/user_events.dart';
import 'package:user_shop/presentation/widgets/input_field.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

part 'package:user_shop/presentation/widgets/order_steps/address_step.dart';
part 'package:user_shop/presentation/widgets/order_steps/review_details_step.dart';
part 'package:user_shop/presentation/widgets/order_steps/order_placed.dart';
part 'package:user_shop/presentation/pages/order/map.dart';

ValueNotifier<int> _currentStep = ValueNotifier<int>(0);
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
ScrollController _controller = ScrollController(initialScrollOffset: 0);

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void dispose() {
    _currentStep.value = 0;
    name.text = '';
    mobile.text = '';
    _isPaying.value = false;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(AlreadyAuthEvent());
  }

  // List<Color> gradColors = [const Color(0xff2f3542).withOpacity(0.7), const Color(0xffced6e0)];

  // List<Color> gradColors = [const Color(0xff2f3542), const Color(0xffced6e0), const Color(0xff2f3542)];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        context.read<UserBloc>().add(AlreadyAuthEvent());
        context.read<CartBloc>().add(ResetCartEvent());
        context.read<OrderBloc>().add(ResetPaymentEvent());
        context.read<AddressBloc>().add(ResetAddressEvent());
        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: SizedBox(
          height: height,
          child: SafeArea(
            child: SingleChildScrollView(
              controller: _controller,
              child: ValueListenableBuilder(
                  valueListenable: _currentStep,
                  builder: (context, stepValue, child) {
                    return Column(
                      children: [
                        const SizedBox(height: 15),
                        EasyStepper(
                          activeStep: _currentStep.value,
                          onStepReached: null,
                          enableStepTapping: false,
                          finishedStepBackgroundColor: Theme.of(context).primaryColor,
                          activeStepBackgroundColor: Colors.white,
                          alignment: Alignment.topCenter,
                          finishedLineColor: Theme.of(context).primaryColor,
                          finishedStepBorderColor: Theme.of(context).primaryColor,
                          internalPadding: 15,
                          lineLength: 60,
                          loadingAnimation: [
                            'assets/92613-processing.json',
                            'assets/74661-checkboard-review-animation.json',
                            'assets/102058-order-completed.json',
                          ][_currentStep.value],
                          steps: const [
                            EasyStep(
                              title: 'Address',
                              topTitle: true,
                              icon: Icon(Icons.home_outlined),
                            ),
                            EasyStep(
                              title: 'Review Order',
                              topTitle: true,
                              icon: Icon(Icons.shopping_bag_outlined),
                            ),
                            EasyStep(
                              title: 'Order Placed',
                              topTitle: true,
                              icon: Icon(Icons.mark_email_read_sharp),
                            ),
                          ],
                        ),
                        IndexedStack(
                          index: _currentStep.value,
                          children: const [
                            AddressStep(),
                            ReviewOrder(),
                            OrderPlacedStep(),
                          ],
                        )
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
