abstract class AuthEvents {}

abstract class AuthStatusEvents {}

class SignInEvent extends AuthEvents {
  String email;
  String password;
  SignInEvent(this.email, this.password);
}

class SignUpEvent extends AuthEvents {
  String email;
  String password;
  String name;
  SignUpEvent(this.name, this.email, this.password);
}

class ResetOtpEvent extends AuthEvents {
  String email;
  ResetOtpEvent(this.email);
}

class ResetEvent extends AuthEvents {
  String email;
  String otp;
  String password;
  ResetEvent(this.email, this.otp, this.password);
}

class AlreadyAuthEvent extends AuthEvents {}

class AuthStateEvent extends AuthStatusEvents {}

class SignOutEvent extends AuthStatusEvents {}
