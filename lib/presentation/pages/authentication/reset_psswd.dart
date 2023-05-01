import 'package:user_shop/presentation/Bloc/bloc/auth_bloc.dart';
import 'package:user_shop/presentation/Bloc/events/auth_events.dart';
import 'package:user_shop/presentation/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({super.key});

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isVisible = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, Map>(
      builder: (context, state) {
        print(state);
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
                    const SizedBox(height: 10),
                    isVisible
                        ? const SizedBox.shrink()
                        : ElevatedButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(ResetOtpEvent(_emailController.text));
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            child: const Text('Submit e-mail to generate OTP'),
                          ),
                    const SizedBox(height: 30),
                    !isVisible
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              FormFieldInput('Enter OTP', false, _otpController),
                              const SizedBox(height: 20),
                              FormFieldInput('New Password', false, _passwordController),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthBloc>().add(ResetEvent(_emailController.text, _otpController.text, _passwordController.text));
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Submit')),
                              const SizedBox(height: 100),
                            ],
                          )
                  ],
                )),
          ),
        );
      },
    );
  }
}