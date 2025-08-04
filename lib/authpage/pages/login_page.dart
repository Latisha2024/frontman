import 'package:flutter/material.dart';
import 'package:role_based_app/admin/screens/admin_dashboard.dart';
import 'package:role_based_app/external_seller/controllers/delivery_report.dart';
import 'package:role_based_app/external_seller/screens/external_seller_dashboard.dart';
import 'package:role_based_app/sales_manager/screens/sales_manager_dashboard.dart';
import 'package:role_based_app/worker/screens/worker_dashboard.dart';
import '../../sales_manager/screens/sales_manager_drawer.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/logo_widget.dart';
import '../widgets/gradient_background.dart';
import '../config/app_theme.dart';
import '../../admin/screens/admin_drawer.dart';
import '../../external_seller/screens/seller_drawer.dart';
import '../../worker/screens/worker_drawer.dart';
import '../../distributor/screens/distributorsUI.dart';
import '../../field_executive/screens/executiveUI.dart';
import '../../accountant_app/screens/acc_home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Demo credentials for different roles
    Widget? homeScreen;
    
    if (email == 'admin@demo.com' && password == 'admin123') {
      homeScreen = const AdminDashboardScreen();
    } else if (email == 'plumber@demo.com' && password == 'plumber123') {
      homeScreen = const ExternalSellerDashboardScreen();
    } else if (email == 'worker@demo.com' && password == 'worker123') {
      homeScreen = const WorkerDashboardScreen();
    } else if (email == 'executive@demo.com' && password == 'executive123') {
      homeScreen = const FieldExecutiveUI();
    } else if (email == 'distributor@demo.com' && password == 'distributor123') {
      homeScreen = const DistributorHomePage();
    } else if (email == 'accountant@demo.com' && password == 'accountant123') {
      homeScreen = const AccountantHomeScreen();
    } else if (email == 'manager@demo.com' && password == 'manager123') {
      homeScreen = const SalesManagerDashboardScreen();
    }

    setState(() {
      _isLoading = false;
    });

    if (homeScreen != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => homeScreen!),
      );
    } else {
      _showErrorDialog('Invalid credentials. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AuthTheme.lightTheme,
      child: Scaffold(
        body: GradientBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    const Center(child: LogoWidget()),
                    const SizedBox(height: 48),
                    CustomTextField(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Password',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: 'Login',
                      onPressed: _handleLogin,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text('Don\'t have an account? Sign up'),
                    ),
                    const SizedBox(height: 32),
                    _buildDemoCredentials(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoCredentials() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demo Credentials:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildCredentialRow('Admin', 'admin@demo.com', 'admin123'),
            _buildCredentialRow('Plumber', 'plumber@demo.com', 'plumber123'),
            _buildCredentialRow('Worker', 'worker@demo.com', 'worker123'),
            _buildCredentialRow('Executive', 'executive@demo.com', 'executive123'),
            _buildCredentialRow('Distributor', 'distributor@demo.com', 'distributor123'),
            _buildCredentialRow('Accountant', 'accountant@demo.com', 'accountant123'),
            _buildCredentialRow('Sales Manager', 'manager@demo.com', 'manager123'),
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialRow(String role, String email, String password) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$role:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              '$email / $password',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
