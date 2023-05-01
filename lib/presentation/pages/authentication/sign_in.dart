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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, Map>(
      builder: (context, state) {
        context.read<AuthStatusBloc>().add(AuthStateEvent());
        return BlocBuilder<AuthStatusBloc, bool>(
          builder: (context, authstate) {
            if (authstate) {
              print(context.read<AuthStatusBloc>().state);
              WidgetsBinding.instance.addPostFrameCallback((_) => {Navigator.of(context).pushReplacementNamed('/')});
            }
            return Scaffold(
              body: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 250),
                        FormFieldInput('Email', false, _emailController),
                        const SizedBox(height: 50),
                        FormFieldInput('Password', false, _passwordController),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(SignInEvent(_emailController.text, _passwordController.text));
                              }
                            },
                            child: const Text('Sign-in')),
                        const SizedBox(height: 10),
                        const ElevatedButton(onPressed: null, child: Text('Sign-In with Google')),
                        const SizedBox(height: 20),
                        TextButton(onPressed: () => Navigator.of(context).pushNamed('/reset'), child: const Text('Forgot Password')),
                        const SizedBox(height: 80),
                        ElevatedButton(onPressed: () => Navigator.of(context).pushNamed('/sign-up'), child: const Text('Create an Account'))
                      ],
                    )),
              ),
            );
          },
        );
      },
    );
  }
}
