import 'package:lottie/lottie.dart';
import 'package:user_shop/presentation/Bloc/bloc/auth_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/auth_events.dart';
import 'package:user_shop/presentation/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  List<Color> gradColors = [const Color.fromARGB(255, 40, 48, 57), const Color(0xff2f3542)];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<AuthBloc, Map>(
      builder: (context, state) {
        context.read<AuthStatusBloc>().add(AuthStateEvent());
        return BlocBuilder<AuthStatusBloc, bool>(
          builder: (context, authstate) {
            if (authstate) {
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Welcome Back,\nResume Your\nShopping', style: Theme.of(context).textTheme.labelLarge),
                                  ),
                                ),
                                const SizedBox(height: 220),
                                FormFieldInput(
                                  'Email',
                                  false,
                                  _emailController,
                                  inputType: TextInputType.emailAddress,
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
                                  false,
                                  _passwordController,
                                  inputType: TextInputType.visiblePassword,
                                  validator: ((value) {
                                    if (value.length < 5) {
                                      return "Password should be of minimum 5 characters";
                                    }
                                    return null;
                                  }),
                                ),
                                const SizedBox(height: 20),
                                state['status'] != 200 && state['message'] != null
                                    ? Text(
                                        'Error: "${state['message']}"',
                                        style: const TextStyle(color: Colors.red, fontSize: 15),
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(height: 30),
                                SizedBox(
                                  width: 150,
                                  child: ElevatedButton(
                                      style: Theme.of(context).elevatedButtonTheme.style,
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<AuthBloc>().add(SignInEvent(_emailController.text, _passwordController.text));
                                        }
                                      },
                                      child: const Text('Log-in')),
                                ),
                                const SizedBox(height: 20),
                                TextButton(onPressed: () => Navigator.of(context).pushNamed('/reset'), child: const Text('Forgot Password?')),
                                const SizedBox(height: 100),
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
      },
    );
  }
}
