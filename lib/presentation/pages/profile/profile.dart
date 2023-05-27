import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:user_shop/domain/models/user.dart';
import 'package:user_shop/presentation/Bloc/bloc/auth_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/user_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/auth_events.dart';
import 'package:user_shop/presentation/Bloc/events/user_events.dart';

File? _file;
String _imageUrl = '';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Color> gradColors = [const Color(0xffced6e0), const Color(0xff2f3542)];
  final _storageref = FirebaseStorage.instance.ref('profiles');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, User>(
      builder: (context, userState) {
        return SafeArea(
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  actions: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.camera_enhance_outlined),
                    )
                  ],
                  backgroundColor: Theme.of(context).primaryColorDark,
                  expandedHeight: 300,
                  floating: true,
                  flexibleSpace: PickImage(
                    _storageref,
                    recievedUrl: userState.imageUrl,
                    user: userState,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradColors, stops: const [0.2, 0.99]),
                      ),
                      child: DefaultTextStyle(
                        style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 20, fontWeight: FontWeight.bold),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text('Name :'),
                                    const SizedBox(width: 50),
                                    Text(
                                      userState.name,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text('Email :'),
                                    const SizedBox(width: 50),
                                    Text(
                                      userState.email,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColorDark,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width, child: ElevatedButton(onPressed: () => Navigator.of(context).pushNamed('/orders'), child: const Text('View My Orders'))),
                                const SizedBox(height: 25),
                                const Text('"My Saved  Addresses" :'),
                                const SizedBox(height: 20),
                                AddressList(userState: userState),
                                const SizedBox(height: 25),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.logout),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      onPressed: () {
                                        context.read<AuthStatusBloc>().add(SignOutEvent());
                                        context.read<AuthStatusBloc>().add(AuthStateEvent());
                                        Navigator.of(context).pushReplacementNamed('/start');
                                      },
                                      label: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold)),
                                    )),
                                const SizedBox(height: 25),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddressList extends StatelessWidget {
  const AddressList({
    super.key,
    required this.userState,
  });
  final User userState;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(userState.addressList!.length, (index) {
        return Dismissible(
          resizeDuration: const Duration(seconds: 1),
          background: Container(
            color: Colors.red,
            child: const Icon(Icons.delete),
          ),
          key: UniqueKey(),
          onDismissed: (direction) {
            userState.addressList!.removeAt(index);
            context.read<UserBloc>().add(UpdateUserEvent(userState));
          },
          child: DefaultTextStyle(
            style: TextStyle(color: Theme.of(context).primaryColorLight),
            child: Card(
              color: Colors.white.withOpacity(0.1),
              elevation: 30,
              child: SizedBox(
                height: 120,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Text(userState.addressList![index]['name']),
                    Text(userState.addressList![index]['line1']),
                    Text(userState.addressList![index]['line2'] + ', ' + userState.addressList![index]['city']),
                    Text(userState.addressList![index]['state'] + ', ' + userState.addressList![index]['country']),
                    const SizedBox(height: 10),
                    const Text('<--- Swipe to delete --->', style: TextStyle(fontSize: 10))
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

//to pick the image of product
class PickImage extends StatefulWidget {
  final Reference _storageref;
  final String? recievedUrl;
  final User user;
  const PickImage(this._storageref, {super.key, this.recievedUrl, required this.user});

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
        task = await _storageref.child(widget.user.id.substring(0, 14)).putFile(_file!).then((p0) async {
          _imageUrl = await _storageref.child(widget.user.id.substring(0, 14)).getDownloadURL();
          setState(() {});
          return p0;
        }).then((value) {
          widget.user.imageUrl = _imageUrl;
          context.read<UserBloc>().add(UpdateUserEvent(widget.user));
          return value;
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
    return Center(
      child: _file == null && recievedUrl == null
          ? ClipOval(child: ElevatedButton.icon(onPressed: () => showSheet(), icon: const Icon(Icons.image), label: const Text('Pick an Image')))
          : _imageUrl == '' && recievedUrl == null
              ? Lottie.asset('assets/143310-loader.json', width: 150, height: 100)
              : GestureDetector(
                  child: CachedNetworkImage(
                    key: UniqueKey(),
                    imageUrl: '${recievedUrl != null && _imageUrl == '' ? recievedUrl : _imageUrl}',
                    fit: BoxFit.scaleDown,
                    progressIndicatorBuilder: (context, url, progress) => Center(
                      child: Lottie.asset('assets/143310-loader.json', width: 150, height: 100),
                    ),
                  ),
                  onTap: () => showSheet(),
                ),
    );
  }
}
