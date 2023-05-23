part of 'package:user_shop/presentation/pages/order/order_details.dart';

bool isCurrentLocation = false;
final GlobalKey<FormState> _personalKey = GlobalKey<FormState>();
TextEditingController name = TextEditingController();
TextEditingController mobile = TextEditingController();

class AddressStep extends StatefulWidget {
  const AddressStep({super.key});

  @override
  State<AddressStep> createState() => _AddressStepState();
}

class _AddressStepState extends State<AddressStep> {
  @override
  void initState() {
    context.read<AddressMapBloc>().add(GetAddressEvent(context.read<LocationMapBloc>().state));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _personalKey,
          child: Column(
            children: [
              Row(
                children: [
                  FormFieldInput('Full Name', false, name, inputType: TextInputType.name, width: 175, padding: const EdgeInsets.all(8.0)),
                  const SizedBox(height: 10),
                  FormFieldInput('Mobile number', false, mobile, inputType: TextInputType.phone, width: 180, padding: const EdgeInsets.all(8.0)),
                ],
              ),
            ],
          ),
        ),
        Container(margin: const EdgeInsets.all(10), child: Divider(color: Theme.of(context).primaryColorLight, thickness: 1)),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text('Address : ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Theme.of(context).primaryColorLight)),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: AddressList(),
        ),
        Stack(
          children: [
            Container(margin: const EdgeInsets.all(10), child: Divider(color: Theme.of(context).primaryColorLight, thickness: 1)),
            Container(margin: const EdgeInsets.only(bottom: 10, left: 175), child: const CircleAvatar(child: Text('OR'))),
          ],
        ),
        ElevatedButton.icon(
            onPressed: () {
              if (_personalKey.currentState!.validate()) {
                context.read<AddressBloc>().add(SetAddressEvent(name: name.text, mobile: mobile.text));
                isCurrentLocation = true;
                final position = _controller.position.minScrollExtent;
                _controller.animateTo(position, duration: const Duration(microseconds: 1), curve: Curves.linear);
                Navigator.of(context).pushNamed('/map');
              }
            },
            icon: const Icon(Icons.location_on_outlined),
            label: const Text('Use Current Location')),
        const SizedBox(height: 20),
        Stack(
          children: [
            Container(margin: const EdgeInsets.all(10), child: Divider(color: Theme.of(context).primaryColorLight, thickness: 1)),
            Container(margin: const EdgeInsets.only(bottom: 10, left: 175), child: const CircleAvatar(child: Text('OR'))),
          ],
        ),
        DecoratedBox(
          decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, width: 4)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('Add a New Address : ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Theme.of(context).primaryColorLight)),
          ),
        ),
        const SizedBox(height: 20),
        const NewAddress(),
        const SizedBox(height: 20),
      ],
    );
  }
}

class AddressList extends StatefulWidget {
  const AddressList({super.key});

  @override
  State<AddressList> createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: 300,
      textStyle: TextStyle(color: Theme.of(context).primaryColorLight),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColorLight), borderRadius: const BorderRadius.all(Radius.circular(30))),
      ),
      initialSelection: 0,
      onSelected: (value) {
        if (_personalKey.currentState!.validate()) {
          var add = context.read<UserBloc>().state.addressList![value!];
          context.read<AddressBloc>().add(SetAddressEvent(
                name: name.text,
                mobile: mobile.text,
                line1: add['line1'],
                line2: add['line2'],
                city: add['city'],
                state: add['state'],
                country: add['country'],
              ));
          final position = _controller.position.minScrollExtent;
          _controller.animateTo(position, duration: const Duration(microseconds: 1), curve: Curves.linear);
          _currentStep.value = 1;
        }
        FocusManager.instance.primaryFocus?.unfocus();
      },
      label: Text(
        'Select from Saved Address',
        style: TextStyle(color: Theme.of(context).primaryColorLight),
      ),
      dropdownMenuEntries: List.generate(context.read<UserBloc>().state.addressList!.length, (index) {
        var address = context.read<UserBloc>().state.addressList![index];
        return DropdownMenuEntry(
            style: const ButtonStyle(
              elevation: MaterialStatePropertyAll(20),
              textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 20)),
            ),
            leadingIcon: const Icon(Icons.location_on_outlined),
            value: index,
            label: '${address['line1'] + ',\n' + address['line2'] + ',\n' + address['city'] + ', ' + address['state'] + '\n' + address['country']}');
      }),
    );
  }
}

class NewAddress extends StatefulWidget {
  const NewAddress({super.key});

  @override
  State<NewAddress> createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  String country = '';
  String state = '';
  String city = '';
  final GlobalKey<FormState> _addressKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _cscKey = GlobalKey<FormState>();

  TextEditingController line1 = TextEditingController();
  TextEditingController line2 = TextEditingController();
  @override
  void dispose() {
    line1.text = '';
    line2.text = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CSCPicker(
            key: _cscKey,
            selectedItemStyle: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 16),
            dropdownItemStyle: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 15),
            dropdownHeadingStyle: TextStyle(color: Theme.of(context).primaryColorDark),
            showStates: true,
            showCities: true,
            onCountryChanged: (value) {
              setState(() {
                country = value;
              });
            },
            onStateChanged: (value) {
              setState(() {
                state = value ?? '';
              });
            },
            onCityChanged: (value) {
              setState(() {
                city = value ?? '';
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        Form(
            key: _addressKey,
            child: Column(
              children: [
                const SizedBox(height: 15),
                FormFieldInput('Flat, House No., Building, Company, Apartment', false, line1, inputType: TextInputType.multiline, width: 375, padding: const EdgeInsets.all(0)),
                const SizedBox(height: 10),
                FormFieldInput('Area, Street, Sector, Village', false, line2, inputType: TextInputType.multiline, width: 375, padding: const EdgeInsets.all(0)),
              ],
            )),
        const SizedBox(height: 20),
        SizedBox(
            width: 350,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_personalKey.currentState!.validate() && _addressKey.currentState!.validate()) {
                  if (country == '' || state == '' || city == '') {
                    ScaffoldMessenger.of(context).showMaterialBanner(
                      MaterialBanner(content: const Text('Select Country/State/City first'), actions: [
                        TextButton(
                          onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                          child: const Text('Dismiss'),
                        )
                      ]),
                    );
                  } else {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _saveAddress();
                    context.read<AddressBloc>().add(SetAddressEvent(
                          name: name.text,
                          mobile: mobile.text,
                          line1: line1.text,
                          line2: line2.text,
                          city: city,
                          state: state,
                          country: country,
                        ));
                    final position = _controller.position.minScrollExtent;
                    _controller.animateTo(position, duration: const Duration(microseconds: 1), curve: Curves.linear);
                    _currentStep.value = 1;
                  }
                } else {
                  ScaffoldMessenger.of(context).showMaterialBanner(
                    MaterialBanner(content: const Text('Fill Name/Mobile No. & Address details first'), actions: [
                      TextButton(
                        onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                        child: const Text('Dismiss'),
                      )
                    ]),
                  );
                }
              },
              child: const Text('Save Address and continue'),
            )),
        const SizedBox(height: 30),
      ],
    );
  }

  _saveAddress() {
    User user = context.read<UserBloc>().state;
    Map address = {
      "name": name.text,
      "line1": line1.text,
      "line2": line2.text,
      "city": city,
      "state": state,
      "country": country,
    };
    user.addressList!.add(address);
    context.read<UserBloc>().add(UpdateUserEvent(user));
  }
}
