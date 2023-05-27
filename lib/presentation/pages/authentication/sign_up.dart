import 'package:lottie/lottie.dart';
import 'package:user_shop/presentation/Bloc/bloc/auth_bloc.dart';
import 'package:user_shop/presentation/Bloc/bloc/util_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/auth_events.dart';
import 'package:user_shop/presentation/Bloc/events/util_events.dart';
import 'package:user_shop/presentation/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  List<Color> gradColors = [const Color.fromARGB(255, 40, 48, 57), const Color(0xff2f3542)];

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    context.read<SizeBloc>().add(SizeEvents(size: size));
    return BlocBuilder<AuthBloc, Map>(
      builder: (context, state) {
        if (state['status'] == 201) {
          WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false));
        }
        return WillPopScope(
          onWillPop: () async {
            context.read<AuthBloc>().add(ResetAuthEvent());
            return true;
          },
          child: Scaffold(
            body: SizedBox(
              width: size.width,
              height: size.height,
              child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: DecoratedBox(
                      decoration: BoxDecoration(gradient: LinearGradient(colors: gradColors.reversed.toList(), begin: Alignment.topLeft, end: Alignment.bottomCenter, stops: const [0.2, 0.7])),
                      child: Stack(
                        children: [
                          Opacity(
                            opacity: 0.4,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 200.0),
                              child: Lottie.asset(
                                'assets/81256-e-commerce.json',
                                width: size.width,
                                height: size.height * 0.4,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Column(children: [
                            const SizedBox(height: 10),
                            SafeArea(
                              child: Text('Welcome,\nJoin and Start\nShopping', style: Theme.of(context).textTheme.labelLarge),
                            ),
                            const SizedBox(height: 180),
                            FormFieldInput('Name', false, _nameController),
                            const SizedBox(height: 20),
                            FormFieldInput(
                              'Email',
                              false,
                              _emailController,
                              validator: ((value) {
                                if (value == null || value.isEmpty || !value.contains('@') || !value.contains('.com')) {
                                  return "Please enter valid Email";
                                }
                                return null;
                              }),
                            ),
                            const SizedBox(height: 20),
                            FormFieldInput(
                              'Password',
                              true,
                              _passwordController,
                              validator: ((value) {
                                if (value.length < 5) {
                                  return "minimum 5 characters";
                                }
                                return null;
                              }),
                            ),
                            const SizedBox(height: 20),
                            state['status'] != 201 && state['message'] != null
                                ? Text(
                                    'Error: "${state['message']}"',
                                    style: const TextStyle(color: Colors.red, fontSize: 15),
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(height: 20),
                            ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(SignUpEvent(_nameController.text, _emailController.text, _passwordController.text));
                                  }
                                },
                                child: const Text('Sign-Up')),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 80),
                              child: Row(
                                children: [
                                  const Text('Already Have Account?'),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).popAndPushNamed('sign-in');
                                    },
                                    child: const Text('Log-In'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                          ])
                        ],
                      ),
                    )),
              ),
            ),
          ),
        );
      },
    );
  }
}
