import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/auth_services.dart';
import '../../admin/screens/admin_dashboard.dart';
import '../../plumber/screens/plumber_dashboard.dart';
import '../../worker/screens/worker_dashboard.dart';
import '../../field_executive/screens/executiveUI.dart';
import '../../distributor/screens/distributorsUI.dart';
import '../../accountant_app/screens/acc_home_screen.dart';
import '../../sales_manager/screens/sales_manager_dashboard.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/logo_widget.dart';
import '../widgets/gradient_background.dart';
import '../config/app_theme.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(); // registration
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController(); // registration
  final _roleController = TextEditingController(); // registration
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isRegister = true; // Start in register mode

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final dio =
        Dio(BaseOptions(baseUrl: 'https://frontman-backend-2.onrender.com/'));

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      Response response;
      if (_isRegister) {
        final name = _nameController.text.trim();
        final phone = _phoneController.text.trim();
        final role =
            _roleController.text.trim(); // must match backend role keys

        response = await dio.post('/auth/register', data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'role': role,
        });

        print('Register response: ${response.data}');
        setState(() => _isRegister = false);
        _showDialog('Registration successful! Please login.');
      } else {
        response = await dio.post('/auth/login', data: {
          'email': email,
          'password': password,
        });

        print('Login response: ${response.data}');
        final token = response.data['token'];
        final user = response.data['user'];

        AuthService().setToken(token, user);

        final savedToken = await AuthService().getToken();
        final savedUser = await AuthService().getUser();
        print("🔎 Retrieved token: $savedToken");
        print("🔎 Retrieved user: $savedUser");

        Widget homeScreen;
        switch (user['role']) {
          case 'Admin':
            homeScreen = const AdminDashboardScreen();
            break;
          case 'Plumber':
            homeScreen = const PlumberDashboardScreen();
            break;
          case 'Worker':
            homeScreen = const WorkerDashboardScreen();
            break;
          case 'FieldExecutive':
            homeScreen = const FieldExecutiveUI();
            break;
          case 'Distributor':
            homeScreen = const DistributorHomePage();
            break;
          case 'Accountant':
            homeScreen = const AccountantHomeScreen();
            break;
          case 'SalesManager':
            homeScreen = const SalesManagerDashboardScreen();
            break;
          default:
            throw Exception('Unknown role: ${user['role']}');
        }

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => homeScreen),
          );
        }
      }
    } on DioException catch (e) {
      String errorMessage = 'Operation failed';
      if (e.response != null) {
        print('Dio error response: ${e.response?.data}');
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        print('Dio error: $e');
        errorMessage = 'Operation failed: ${e.message}';
      }
      _showDialog(errorMessage);
    } catch (e) {
      print('Unexpected error: $e');
      _showDialog('Unexpected error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isRegister ? 'Register' : 'Login'),
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
                    if (_isRegister)
                      CustomTextField(
                        label: 'Name',
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        prefixIcon: const Icon(Icons.person_outline),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Enter your name';
                          return null;
                        },
                      ),
                    if (_isRegister) const SizedBox(height: 16),
                    if (_isRegister)
                      CustomTextField(
                        label: 'Phone',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.phone),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Enter your phone';
                          return null;
                        },
                      ),
                    if (_isRegister) const SizedBox(height: 16),
                    if (_isRegister)
                      CustomTextField(
                        label: 'Role',
                        controller: _roleController,
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(Icons.badge_outlined),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Enter your role';
                          return null;
                        },
                      ),
                    if (_isRegister) const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Enter your email';
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) return 'Enter a valid email';
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
                        icon: Icon(_obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Enter your password';
                        if (value.length < 6)
                          return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: _isRegister ? 'Register' : 'Login',
                      onPressed: _handleSubmit,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () =>
                          setState(() => _isRegister = !_isRegister),
                      child: Text(_isRegister
                          ? 'Already have an account? Login'
                          : 'Don\'t have an account? Sign up'),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
