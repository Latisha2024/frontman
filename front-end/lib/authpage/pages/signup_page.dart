import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _fullPhoneNumber = '';
  String? _selectedRole;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isRegister = true;

  // Use a Map to separate display values from backend values
  final Map<String, String> _userRoles = {
    'Admin': 'Admin',
    'SalesManager': 'Sales Manager',
    'Plumber': 'Plumber',
    'Accountant': 'Accountant',
    'Distributor': 'Distributor',
    'FieldExecutive': 'Field Executive',
    'Worker': 'Worker',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final dio = AuthService().dio;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      Response response;
      if (_isRegister) {
        final name = _nameController.text.trim();

        response = await dio.post('/auth/register', data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': _fullPhoneNumber,
          'role': _selectedRole, // This already holds the correct backend value
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

        await AuthService().setToken(token, user);

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
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = 'Operation failed: ${e.message}';
      }
      _showDialog(errorMessage);
    } catch (e) {
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
                          if (value == null || value.isEmpty) {
                            return 'Enter your name';
                          }
                          return null;
                        },
                      ),
                    if (_isRegister) const SizedBox(height: 16),

                    if (_isRegister)
                      IntlPhoneField(
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        initialCountryCode: 'IN',
                        onChanged: (phone) {
                          _fullPhoneNumber = phone.completeNumber;
                        },
                      ),

                    if (_isRegister) const SizedBox(height: 16),

                    if (_isRegister)
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'Select Role',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        items: _userRoles.entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key, // Save the backend value
                            child: Text(entry.value), // Show the display value
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() => _selectedRole = newValue);
                        },
                        validator: (value) =>
                        value == null ? 'Please select a role' : null,
                      ),

                    if (_isRegister) const SizedBox(height: 16),

                    CustomTextField(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Enter a valid email';
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
                        icon: Icon(_obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your password';
                        }
                        final strongPassword = RegExp(
                            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$');
                        if (!strongPassword.hasMatch(value)) {
                          return 'Password must be 8+ chars with upper, lower, number, special';
                        }
                        return null;
                      },
                    ),

                    // Inline password error message (no autovalidate): mirrors Manage Users behavior
                    if (_isRegister)
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _passwordController,
                        builder: (context, value, _) {
                          final pwd = value.text;
                          if (pwd.isEmpty) return const SizedBox.shrink();
                          final ok = RegExp(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$')
                              .hasMatch(pwd);
                          return ok
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    'Password must be 8+ chars with upper, lower, number, special',
                                    style: const TextStyle(color: Colors.red, fontSize: 12),
                                  ),
                                );
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