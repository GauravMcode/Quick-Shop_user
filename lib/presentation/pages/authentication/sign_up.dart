import 'package:user_shop/presentation/Bloc/bloc/auth_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/auth_events.dart';
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

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, Map>(
      builder: (context, state) {
        if (state['status'] == 201) {
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
                    FormFieldInput('Name', false, _nameController),
                    const SizedBox(height: 50),
                    FormFieldInput('Email', false, _emailController),
                    const SizedBox(height: 50),
                    FormFieldInput('Password', false, _passwordController),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(SignUpEvent(_nameController.text, _emailController.text, _passwordController.text));
                          }
                        },
                        child: const Text('Sign-Up')),
                    const SizedBox(height: 10),
                    const ElevatedButton(onPressed: null, child: Text('Sign-Up with Google')),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.only(left: 100),
                      child: Row(children: [
                        const Text('Already Have Account?'),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Sign-In'),
                        ),
                      ]),
                    )
                  ],
                )),
          ),
        );
      },
    );
  }
}
