// // import 'package:flutter/material.dart';
// // import 'package:role_based_app/admin/screens/admin_dashboard.dart';
// // import 'package:role_based_app/external_seller/controllers/delivery_report.dart';
// // import 'package:role_based_app/external_seller/screens/external_seller_dashboard.dart';
// // import 'package:role_based_app/sales_manager/screens/sales_manager_dashboard.dart';
// // import 'package:role_based_app/worker/screens/worker_dashboard.dart';
// // import '../../sales_manager/screens/sales_manager_drawer.dart';
// // import '../widgets/custom_text_field.dart';
// // import '../widgets/custom_button.dart';
// // import '../widgets/logo_widget.dart';
// // import '../widgets/gradient_background.dart';
// // import '../config/app_theme.dart';
// // import '../../admin/screens/admin_drawer.dart';
// // import '../../external_seller/screens/seller_drawer.dart';
// // import '../../worker/screens/worker_drawer.dart';
// // import '../../distributor/screens/distributorsUI.dart';
// // import '../../field_executive/screens/executiveUI.dart';
// // import '../../accountant_app/screens/acc_home_screen.dart';

// // class LoginPage extends StatefulWidget {
// //   const LoginPage({Key? key}) : super(key: key);

// //   @override
// //   State<LoginPage> createState() => _LoginPageState();
// // }

// // class _LoginPageState extends State<LoginPage> {
// //   final _formKey = GlobalKey<FormState>();
// //   final _emailController = TextEditingController();
// //   final _passwordController = TextEditingController();
// //   bool _isLoading = false;
// //   bool _obscurePassword = true;

// //   @override
// //   void dispose() {
// //     _emailController.dispose();
// //     _passwordController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _handleLogin() async {
// //     if (!_formKey.currentState!.validate()) return;

// //     setState(() {
// //       _isLoading = true;
// //     });

// //     // Simulate API call
// //     await Future.delayed(const Duration(seconds: 2));

// //     final email = _emailController.text.trim();
// //     final password = _passwordController.text.trim();

// //     // Demo credentials for different roles
// //     Widget? homeScreen;

// //     if (email == 'admin@demo.com' && password == 'admin123') {
// //       homeScreen = const AdminDashboardScreen();
// //     } else if (email == 'plumber@demo.com' && password == 'plumber123') {
// //       homeScreen = const ExternalSellerDashboardScreen();
// //     } else if (email == 'worker@demo.com' && password == 'worker123') {
// //       homeScreen = const WorkerDashboardScreen();
// //     } else if (email == 'executive@demo.com' && password == 'executive123') {
// //       homeScreen = const FieldExecutiveUI();
// //     } else if (email == 'distributor@demo.com' && password == 'distributor123') {
// //       homeScreen = const DistributorHomePage();
// //     } else if (email == 'accountant@demo.com' && password == 'accountant123') {
// //       homeScreen = const AccountantHomeScreen();
// //     } else if (email == 'manager@demo.com' && password == 'manager123') {
// //       homeScreen = const SalesManagerDashboardScreen();
// //     }

// //     setState(() {
// //       _isLoading = false;
// //     });

// //     if (homeScreen != null && mounted) {
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (context) => homeScreen!),
// //       );
// //     } else {
// //       _showErrorDialog('Invalid credentials. Please try again.');
// //     }
// //   }

// //   void _showErrorDialog(String message) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('Login Failed'),
// //         content: Text(message),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text('OK'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Theme(
// //       data: AuthTheme.lightTheme,
// //       child: Scaffold(
// //         body: GradientBackground(
// //           child: SafeArea(
// //             child: SingleChildScrollView(
// //               padding: const EdgeInsets.all(24),
// //               child: Form(
// //                 key: _formKey,
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.stretch,
// //                   children: [
// //                     const SizedBox(height: 40),
// //                     const Center(child: LogoWidget()),
// //                     const SizedBox(height: 48),
// //                     CustomTextField(
// //                       label: 'Email',
// //                       controller: _emailController,
// //                       keyboardType: TextInputType.emailAddress,
// //                       prefixIcon: const Icon(Icons.email_outlined),
// //                       validator: (value) {
// //                         if (value == null || value.isEmpty) {
// //                           return 'Please enter your email';
// //                         }
// //                         if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
// //                           return 'Please enter a valid email';
// //                         }
// //                         return null;
// //                       },
// //                     ),
// //                     const SizedBox(height: 24),
// //                     CustomTextField(
// //                       label: 'Password',
// //                       controller: _passwordController,
// //                       obscureText: _obscurePassword,
// //                       prefixIcon: const Icon(Icons.lock_outlined),
// //                       suffixIcon: IconButton(
// //                         icon: Icon(
// //                           _obscurePassword ? Icons.visibility : Icons.visibility_off,
// //                         ),
// //                         onPressed: () {
// //                           setState(() {
// //                             _obscurePassword = !_obscurePassword;
// //                           });
// //                         },
// //                       ),
// //                       validator: (value) {
// //                         if (value == null || value.isEmpty) {
// //                           return 'Please enter your password';
// //                         }
// //                         if (value.length < 6) {
// //                           return 'Password must be at least 6 characters';
// //                         }
// //                         return null;
// //                       },
// //                     ),
// //                     const SizedBox(height: 32),
// //                     CustomButton(
// //                       text: 'Login',
// //                       onPressed: _handleLogin,
// //                       isLoading: _isLoading,
// //                     ),
// //                     const SizedBox(height: 24),
// //                     TextButton(
// //                       onPressed: () {
// //                         Navigator.pushNamed(context, '/signup');
// //                       },
// //                       child: const Text('Don\'t have an account? Sign up'),
// //                     ),
// //                     const SizedBox(height: 32),
// //                     _buildDemoCredentials(),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildDemoCredentials() {
// //     return Card(
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Text(
// //               'Demo Credentials:',
// //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //             ),
// //             const SizedBox(height: 12),
// //             _buildCredentialRow('Admin', 'admin@demo.com', 'admin123'),
// //             _buildCredentialRow('Plumber', 'plumber@demo.com', 'plumber123'),
// //             _buildCredentialRow('Worker', 'worker@demo.com', 'worker123'),
// //             _buildCredentialRow('Executive', 'executive@demo.com', 'executive123'),
// //             _buildCredentialRow('Distributor', 'distributor@demo.com', 'distributor123'),
// //             _buildCredentialRow('Accountant', 'accountant@demo.com', 'accountant123'),
// //             _buildCredentialRow('Sales Manager', 'manager@demo.com', 'manager123'),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildCredentialRow(String role, String email, String password) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 4),
// //       child: Row(
// //         children: [
// //           SizedBox(
// //             width: 80,
// //             child: Text(
// //               '$role:',
// //               style: const TextStyle(fontWeight: FontWeight.w500),
// //             ),
// //           ),
// //           Expanded(
// //             child: Text(
// //               '$email / $password',
// //               style: const TextStyle(fontSize: 12),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../helpers/auth_service.dart';
// import '../../admin/screens/admin_dashboard.dart';
// import '../../plumber/screens/plumber_dashboard.dart';
// import '../../worker/screens/worker_dashboard.dart';
// import '../../field_executive/screens/executiveUI.dart';
// import '../../distributor/screens/distributorsUI.dart';
// import '../../accountant_app/screens/acc_home_screen.dart';
// import '../../sales_manager/screens/sales_manager_dashboard.dart';
// import '../widgets/custom_text_field.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/logo_widget.dart';
// import '../widgets/gradient_background.dart';
// import '../config/app_theme.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController(); // registration
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _phoneController = TextEditingController(); // registration
//   final _roleController = TextEditingController(); // registration
//   bool _isLoading = false;
//   bool _obscurePassword = true;
//   bool _isRegister = false; // toggle login/register

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _phoneController.dispose();
//     _roleController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleSubmit() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:5000'));
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();

//     try {
//       Response response;
//       if (_isRegister) {
//         final name = _nameController.text.trim();
//         final phone = _phoneController.text.trim();
//         final role =
//             _roleController.text.trim(); // must match backend role keys

//         response = await dio.post('/auth/register', data: {
//           'name': name,
//           'email': email,
//           'password': password,
//           'phone': phone,
//           'role': role,
//         });

//         print('Register response: ${response.data}');
//         setState(() => _isRegister = false);
//         _showDialog('Registration successful! Please login.');
//       } else {
//         response = await dio.post('/auth/login', data: {
//           'email': email,
//           'password': password,
//         });

//         print('Login response: ${response.data}');
//         final token = response.data['token'];
//         final user = response.data['user'];

//         AuthService().setToken(token, user);

//         // Persist token for subsequent requests used by controllers' interceptors
//         try {
//           final prefs = await SharedPreferences.getInstance();
//           if (token is String && token.isNotEmpty) {
//             await prefs.setString('auth_token', token);
//           }
//           // Optional: store basic user info
//           final role =
//               user is Map<String, dynamic> ? user['role']?.toString() : null;
//           if (role != null) {
//             await prefs.setString('user_role', role);
//           }
//         } catch (e) {
//           // Non-fatal: continue even if persistence fails
//           print('Failed to persist auth token: $e');
//         }

//         Widget homeScreen;
//         switch (user['role']) {
//           case 'Admin':
//             homeScreen = const AdminDashboardScreen();
//             break;
//           case 'Plumber':
//             homeScreen = const PlumberDashboardScreen();
//             break;
//           case 'Worker':
//             homeScreen = const WorkerDashboardScreen();
//             break;
//           case 'FieldExecutive':
//             homeScreen = const FieldExecutiveUI();
//             break;
//           case 'Distributor':
//             homeScreen = const DistributorHomePage();
//             break;
//           case 'Accountant':
//             homeScreen = const AccountantHomeScreen();
//             break;
//           case 'SalesManager':
//             homeScreen = const SalesManagerDashboardScreen();
//             break;
//           default:
//             throw Exception('Unknown role: ${user['role']}');
//         }

//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => homeScreen),
//           );
//         }
//       }
//     } on DioException catch (e) {
//       String errorMessage = 'Operation failed';
//       if (e.response != null) {
//         print('Dio error response: ${e.response?.data}');
//         errorMessage = e.response?.data['message'] ?? errorMessage;
//       } else {
//         print('Dio error: $e');
//         errorMessage = 'Operation failed: ${e.message}';
//       }
//       _showDialog(errorMessage);
//     } catch (e) {
//       print('Unexpected error: $e');
//       _showDialog('Unexpected error: $e');
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   void _showDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(_isRegister ? 'Register' : 'Login'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: AuthTheme.lightTheme,
//       child: Scaffold(
//         body: GradientBackground(
//           child: SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     const SizedBox(height: 40),
//                     const Center(child: LogoWidget()),
//                     const SizedBox(height: 48),
//                     if (_isRegister)
//                       CustomTextField(
//                         label: 'Name',
//                         controller: _nameController,
//                         keyboardType: TextInputType.name,
//                         prefixIcon: const Icon(Icons.person_outline),
//                         validator: (value) {
//                           if (value == null || value.isEmpty)
//                             return 'Enter your name';
//                           return null;
//                         },
//                       ),
//                     if (_isRegister) const SizedBox(height: 16),
//                     if (_isRegister)
//                       CustomTextField(
//                         label: 'Phone',
//                         controller: _phoneController,
//                         keyboardType: TextInputType.phone,
//                         prefixIcon: const Icon(Icons.phone),
//                         validator: (value) {
//                           if (value == null || value.isEmpty)
//                             return 'Enter your phone';
//                           return null;
//                         },
//                       ),
//                     if (_isRegister) const SizedBox(height: 16),
//                     if (_isRegister)
//                       CustomTextField(
//                         label: 'Role',
//                         controller: _roleController,
//                         keyboardType: TextInputType.text,
//                         prefixIcon: const Icon(Icons.badge_outlined),
//                         validator: (value) {
//                           if (value == null || value.isEmpty)
//                             return 'Enter your role';
//                           return null;
//                         },
//                       ),
//                     if (_isRegister) const SizedBox(height: 16),
//                     CustomTextField(
//                       label: 'Email',
//                       controller: _emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       prefixIcon: const Icon(Icons.email_outlined),
//                       validator: (value) {
//                         if (value == null || value.isEmpty)
//                           return 'Enter your email';
//                         if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                             .hasMatch(value)) return 'Enter a valid email';
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     CustomTextField(
//                       label: 'Password',
//                       controller: _passwordController,
//                       obscureText: _obscurePassword,
//                       prefixIcon: const Icon(Icons.lock_outlined),
//                       suffixIcon: IconButton(
//                         icon: Icon(_obscurePassword
//                             ? Icons.visibility
//                             : Icons.visibility_off),
//                         onPressed: () => setState(
//                             () => _obscurePassword = !_obscurePassword),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty)
//                           return 'Enter your password';
//                         if (value.length < 6)
//                           return 'Password must be at least 6 characters';
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 32),
//                     CustomButton(
//                       text: _isRegister ? 'Register' : 'Login',
//                       onPressed: _handleSubmit,
//                       isLoading: _isLoading,
//                     ),
//                     const SizedBox(height: 24),
//                     TextButton(
//                       onPressed: () =>
//                           setState(() => _isRegister = !_isRegister),
//                       child: Text(_isRegister
//                           ? 'Already have an account? Login'
//                           : 'Don\'t have an account? Sign up'),
//                     ),
//                     const SizedBox(height: 32),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../admin/screens/company_selection.dart';
import '../../authpage/pages/auth_services.dart';
import '../../external_seller/screens/external_seller_dashboard.dart';
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

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(); // registration
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController(); // registration
  final _roleController = TextEditingController(); // registration
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isRegister = false; // toggle login/register

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

        // await AuthService().setToken(token, user);
        // try {
        //   final prefs = await SharedPreferences.getInstance();
        //   if (token is String && token.isNotEmpty) {
        //     await prefs.setString('auth_token', token);
        //   }
        //   // Optional: store basic user info
        //   final role =
        //       user is Map<String, dynamic> ? user['role']?.toString() : null;
        //   if (role != null) {
        //     await prefs.setString('user_role', role);
        //   }
        // } catch (e) {
        //   // Non-fatal: continue even if persistence fails
        //   print('Failed to persist auth token: $e');
        // }

        await AuthService().setToken(token, user);

        Widget homeScreen;
        switch (user['role']) {
          case 'Admin':
            homeScreen = const CompanySelectionScreen();
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