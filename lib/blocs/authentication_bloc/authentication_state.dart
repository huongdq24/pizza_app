part of 'authentication_bloc.dart';

enum AuthenticationStatus { authenticated, unauthenticated,unknown }

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final MyUser? user;

  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user,
  });

  const AuthenticationState.authenticated(MyUser myUser)
      : this._(status: AuthenticationStatus.authenticated, user: myUser);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);
      
  const AuthenticationState.unknown()
      : this._();

  @override
  List<Object?> get props => [status, user];
}