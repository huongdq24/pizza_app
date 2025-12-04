import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:pizza_app/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';

import 'package:pizza_app/screens/home/blocs/bloc/get_pizza_bloc.dart';
import 'package:pizza_app/screens/home/blocs/create_pizza/create_pizza_bloc.dart';

import 'package:pizza_repository/pizza_repository.dart';
import 'package:cart_repository/cart_repository.dart';
import 'package:order_repository/order_repository.dart';

import 'screens/auth/views/welcome_screen.dart';
import 'screens/home/views/home_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'blocs/cart_bloc/cart_bloc.dart';
import 'blocs/order_bloc/order_bloc.dart';
import 'app_theme.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pizza Delivery',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: ((context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              // Check if running on web and user is admin
              final isAdmin = state.user?.isAdmin ?? false;
              final shouldShowAdminDashboard = kIsWeb && isAdmin;

              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SignInBloc(
                        context.read<AuthenticationBloc>().userRepository),
                  ),
                  BlocProvider(
                    create: (context) =>
                        GetPizzaBloc(FirebasePizzaRepo())..add(GetPizza()),
                  ),
                  BlocProvider(
                    create: (context) => CreatePizzaBloc(FirebasePizzaRepo()),
                  ),
                  BlocProvider(
                    create: (context) => CartBloc(
                      cartRepo: FirebaseCartRepo(),
                      userId: state.user!.userId,
                    ),
                  ),
                  BlocProvider(
                    create: (context) => OrderBloc(
                      orderRepo: FirebaseOrderRepo(),
                    ),
                  ),
                ],
                child: shouldShowAdminDashboard
                    ? const AdminDashboard()
                    : const HomeScreen(),
              );
            } else {
              return const WelcomeScreen();
            }
          }),
        ));
  }
}
