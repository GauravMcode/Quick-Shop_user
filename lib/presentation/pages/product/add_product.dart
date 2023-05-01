import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:user_shop/data/local/local_data.dart';
import 'package:user_shop/domain/models/product.dart';
import 'package:user_shop/presentation/Bloc/bloc/product_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/product_events.dart';
import 'package:user_shop/presentation/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

File? _file;
String _imageUrl = '';

//TODO : Make it Edit Profile Page

class AddProductPage extends StatefulWidget {
  final Product? recievedProduct;
  const AddProductPage({super.key, this.recievedProduct});

  @override
  State<AddProductPage> createState() => _AddProductPageState(recievedProduct: recievedProduct);
}

class _AddProductPageState extends State<AddProductPage> {
  Product? recievedProduct;
  _AddProductPageState({this.recievedProduct});
  final _storageref = FirebaseStorage.instance.ref('profile').child('${DateTime.now()}');

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _qtyController;

  late String _id;

  getId() async {
    _id = await UserIdProvider.getId();
  }

  @override
  void initState() {
    super.initState();
    getId();
    _titleController = TextEditingController(text: recievedProduct?.title);
    _descriptionController = TextEditingController(text: recievedProduct?.description);
    _priceController = TextEditingController(text: recievedProduct?.price.toString());
    _qtyController = TextEditingController(text: recievedProduct?.quantity.toString());
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    _file = null;
    _imageUrl = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, Map>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            _file = null;
            if (_imageUrl != '') {
              await _storageref.delete();
              _imageUrl = '';
            }
            return true;
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 200, child: PickImage(_storageref, recievedUrl: recievedProduct?.imageUrl)),
                      const SizedBox(height: 50),
                      FormFieldInput('Title', false, _titleController),
                      const SizedBox(height: 50),
                      FormFieldInput('Description', false, _descriptionController, height: 150),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FormFieldInput('Price', false, _priceController, width: 100),
                          const SizedBox(height: 20),
                          FormFieldInput('Quantity', false, _qtyController, width: 100),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final product = Product(
                                _titleController.text,
                                _descriptionController.text,
                                "${_imageUrl == '' && recievedProduct != null ? recievedProduct?.imageUrl : _imageUrl}",
                                int.parse(_priceController.text),
                                int.parse(_qtyController.text),
                                _id,
                                id: recievedProduct?.id,
                              );
                              if (recievedProduct != null) {
                                context.read<ProductBloc>().add(GetProductEvent(recievedProduct?.id as String));
                              }
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(recievedProduct == null ? "Add Product" : "Update Product")),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}

//to pick the image of product
class PickImage extends StatefulWidget {
  final Reference _storageref;
  final String? recievedUrl;
  const PickImage(this._storageref, {super.key, this.recievedUrl});

  @override
  State<PickImage> createState() => _PickImageState(_storageref, recievedUrl: recievedUrl);
}

class _PickImageState extends State<PickImage> {
  late TaskSnapshot task;
  final Reference _storageref;
  String? recievedUrl;
  _PickImageState(this._storageref, {this.recievedUrl});
  getImage(ImageSource source) async {
    Navigator.of(context).pop();
    _imageUrl = '';
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      setState(() {});
      _file = File(image?.path ?? '');
      try {
        task = await _storageref.putFile(_file!).then((p0) async {
          _imageUrl = await _storageref.getDownloadURL();
          setState(() {});
          return p0;
        });
      } on FirebaseException {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  showSheet() {
    showBottomSheet(
        context: context,
        constraints: const BoxConstraints(maxHeight: 150),
        builder: (context) {
          return Center(
            child: SizedBox(
              height: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => getImage(ImageSource.gallery),
                    icon: const Icon(Icons.image_outlined),
                    label: const Text('Gallery'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => getImage(ImageSource.camera),
                    icon: const Icon(Icons.camera),
                    label: const Text('Camera'),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: _file == null && recievedUrl == null
            ? ClipOval(child: ElevatedButton.icon(onPressed: () => showSheet(), icon: const Icon(Icons.image), label: const Text('Pick an Image')))
            : _imageUrl == '' && recievedUrl == null
                ? const CircularProgressIndicator()
                : GestureDetector(
                    child: Image.network('${recievedUrl != null && _imageUrl == '' ? recievedUrl : _imageUrl}'),
                    onTap: () => showSheet(),
                  ),
      ),
    );
  }
}
