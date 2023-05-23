part of 'package:user_shop/presentation/pages/order/order_details.dart';

class OrderPlacedStep extends StatefulWidget {
  const OrderPlacedStep({super.key});

  @override
  State<OrderPlacedStep> createState() => _OrderPlacedStepState();
}

class _OrderPlacedStepState extends State<OrderPlacedStep> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, Map>(
      builder: (context, state) {
        return state['status'] == 0
            ? Center(
                child: Lottie.asset('assets/143310-loader.json'),
              )
            : DefaultTextStyle(
                style: TextStyle(color: Theme.of(context).primaryColorLight, shadows: const [Shadow(blurRadius: 15.0, color: Color(0xff2f3542), offset: Offset(4.0, 4.0))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Thank You for shopping! ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                    const SizedBox(height: 10),
                    const Text('Your order has been placed and will reach you in 3 days ', style: TextStyle(fontSize: 15), textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    VerticalDivider(color: Theme.of(context).primaryColorLight, thickness: 3, width: 3),
                    InvoiceWidget(url: state['invoice']),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          context.read<UserBloc>().add(AlreadyAuthEvent());
                          context.read<CartBloc>().add(ResetCartEvent());
                          context.read<OrderBloc>().add(ResetPaymentEvent());
                          context.read<AddressBloc>().add(ResetAddressEvent());
                          Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                        },
                        child: const Text('Continue Shopping'))
                  ],
                ),
              );
      },
    );
  }
}

class InvoiceWidget extends StatefulWidget {
  const InvoiceWidget({
    super.key,
    required this.url,
  });
  final String url;

  @override
  State<InvoiceWidget> createState() => _InvoiceWidgetState();
}

class _InvoiceWidgetState extends State<InvoiceWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColorLight, width: 3)),
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Here is the invoice :', style: TextStyle(fontSize: 15)),
            VerticalDivider(
              color: Theme.of(context).primaryColorLight,
              thickness: 3,
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  openFile(url: widget.url, fileName: 'Invoice.pdf');
                },
                child: Row(
                  children: [
                    const Text('Download Invoice', style: TextStyle(decoration: TextDecoration.underline)),
                    _isLoading
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColorLight,
                                  backgroundColor: Theme.of(context).primaryColor,
                                )),
                          )
                        : const SizedBox.shrink(),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Future openFile({required String url, required String fileName}) async {
    File? file = await downloadFile(url, fileName);

    if (file == null) return;
    setState(() {
      _isLoading = false;
    });

    //opens the file if it is not null
    OpenFile.open(file.path);
  }
}

// Future openFile({required String url, required String fileName}) async {
//   File? file = await downloadFile(url, fileName);

//   if (file == null) return;

//   //opens the file if it is not null
//   OpenFile.open(file.path);
// }

//downloads file and write it to a local file with fileName
Future<File?> downloadFile(String url, String fileName) async {
  final appStorage = await getExternalStorageDirectory();
  final file = File('${appStorage!.path}/$fileName');

  try {
    final response = await http.get(Uri.parse(url));

    file.writeAsBytesSync(response.bodyBytes);

    return file;
  } catch (e) {
    rethrow;
  }
}
