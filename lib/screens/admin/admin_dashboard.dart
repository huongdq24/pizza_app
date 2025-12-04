import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_repository/pizza_repository.dart';

import 'products_admin_page.dart';
import 'orders_admin_page.dart';
import '../home/blocs/create_pizza/create_pizza_bloc.dart';
import '../../blocs/authentication_bloc/authentication_bloc.dart';
import '../auth/blocs/sign_in_bloc/sign_in_bloc.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Check if user is admin
    final user = context.read<AuthenticationBloc>().state.user;
    if (user == null || !user.isAdmin) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Access Denied',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('You must be an admin to access this page.'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.read<SignInBloc>().add(SignOutRequired());
                },
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      );
    }

    final pages = [
      BlocProvider(
        create: (context) => CreatePizzaBloc(FirebasePizzaRepo()),
        child: const ProductsAdminPage(),
      ),
      const OrdersAdminPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pizza Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              context.read<SignInBloc>().add(SignOutRequired());
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: Colors.grey.shade100,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.fastfood),
                label: Text('Products'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.receipt_long),
                label: Text('Orders'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Content
          Expanded(
            child: pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
