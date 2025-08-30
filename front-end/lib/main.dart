// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'authpage/pages/login_page.dart';
// import 'authpage/pages/signup_page.dart';
// import 'accountant_app/providers/accountant_provider.dart';
// import 'constants/colors.dart';
// import './admin/screens/manage_users.dart';
// import './admin/screens/manage_products.dart';
// import './admin/screens/generate_reports.dart';
// import './admin/screens/convert_points.dart';
// import './admin/screens/invoices.dart';
// import './admin/screens/send_notifications.dart';
// import './admin/screens/warranty_database.dart';
// import './admin/screens/order_summary.dart';
// import './admin/screens/audit_logs.dart';
// import './admin/screens/assign_incentive.dart';
// import './external_seller/screens/incentives.dart';
// import './external_seller/screens/points.dart';
// import './external_seller/screens/delivery_report.dart';
// import './external_seller/screens/register_warranty.dart';
// import './worker/screens/production.dart';
// import './worker/screens/manage_stock.dart';
// import './worker/screens/report_damage.dart';
// import './worker/screens/summary.dart';
// import './worker/screens/shift_alerts.dart';
// import './sales_manager/screens/gps_tracking.dart';
// import './sales_manager/screens/performance_reports.dart';
// import './sales_manager/screens/assign_tasks.dart';
// import './sales_manager/screens/approve_dvr_reports.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AccountantProvider()),
//       ],
//       child: MaterialApp(
//         title: 'Business Management App',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: _createMaterialColor(AppColors.primary),
//           primaryColor: AppColors.primary,
//           scaffoldBackgroundColor: AppColors.background,
//           appBarTheme: const AppBarTheme(
//             backgroundColor: AppColors.primary,
//             foregroundColor: AppColors.textLight,
//             elevation: 2,
//             centerTitle: true,
//           ),
//           cardTheme: CardThemeData(
//             surfaceTintColor: Colors.transparent, // Optional: remove elevation overlay tint
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               foregroundColor: AppColors.textLight,
//               padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//           outlinedButtonTheme: OutlinedButtonThemeData(
//             style: OutlinedButton.styleFrom(
//               foregroundColor: AppColors.primary,
//               side: const BorderSide(color: AppColors.primary),
//               padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//           inputDecorationTheme: InputDecorationTheme(
//             filled: true,
//             fillColor: AppColors.surface,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: AppColors.border),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: AppColors.border),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: AppColors.primary, width: 2),
//             ),
//           ),
//         ),
//         initialRoute: '/login',
//         routes: {
//           '/login': (context) => const LoginPage(),
//           '/signup': (context) => const SignUpPage(),
//           // Admin
//           '/admin/manage-users': (context) => const ManageUsersScreen(),
//           '/admin/manage-products': (context) => const ManageProductsScreen(),
//           '/admin/generate-reports': (context) => const GenerateReportsScreen(),
//           '/admin/convert-points-to-cash': (context) => const ConvertPointsToCashScreen(),
//           '/admin/invoices': (context) => const AdminInvoicesScreen(),
//           '/admin/send-notifications': (context) => const SendNotificationsScreen(),
//           '/admin/warranty-database': (context) => const WarrantyDatabaseScreen(),
//           '/admin/order-summary': (context) => const OrderSummaryScreen(),
//           '/admin/audit-logs': (context) => const AuditLogsScreen(),
//           '/admin/assign-incentive': (context) => const AssignIncentiveScreen(),
//           // External Seller
//           '/seller/incentives': (context) => const ExternalSellerIncentivesScreen(),
//           '/seller/points': (context) => const ExternalSellerPointsScreen(),
//           '/seller/delivery-report': (context) => const ExternalSellerDeliveryReportScreen(),
//           '/seller/register-warranty': (context) => const ExternalSellerRegisterWarrantyScreen(),
//           // Worker
//           '/worker/production': (context) => const WorkerProductionScreen(),
//           '/worker/manage-stock': (context) => const WorkerManageStockScreen(),
//           '/worker/report-damage': (context) => const WorkerReportDamageScreen(),
//           '/worker/summary': (context) => const WorkerSummaryScreen(),
//           '/worker/shift-alerts': (context) => const WorkerShiftAlertsScreen(),
//           // Sales Manager
//           '/sales_manager/gps_tracking': (context) => const SalesManagerGpsTrackingScreen(),
//           '/sales_manager/performance_reports': (context) => const SalesManagerPerformanceReportsScreen(),
//           '/sales_manager/assign_tasks': (context) => const SalesManagerAssignTasksScreen(),
//           '/sales_manager/approve_dvr_reports': (context) => const SalesManagerApproveDvrReportsScreen(),
//         },
//       ),
//     );
//   }

//   MaterialColor _createMaterialColor(Color color) {
//     final strengths = <double>[.05];
//     final swatch = <int, Color>{};
//     final int r = color.red, g = color.green, b = color.blue;

//     for (int i = 1; i < 10; i++) {
//       strengths.add(0.1 * i);
//     }

//     for (var strength in strengths) {
//       final double ds = 0.5 - strength;
//       swatch[(strength * 1000).round()] = Color.fromRGBO(
//         r + ((ds < 0 ? r : (255 - r)) * ds).round(),
//         g + ((ds < 0 ? g : (255 - g)) * ds).round(),
//         b + ((ds < 0 ? b : (255 - b)) * ds).round(),
//         1,
//       );
//     }

//     return MaterialColor(color.value, swatch);
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authpage/pages/login_page.dart';
import 'authpage/pages/signup_page.dart';
import 'accountant_app/providers/accountant_provider.dart';
import 'constants/colors.dart';
import './plumber/screens/incentives.dart';
import './plumber/screens/points.dart';
import './plumber/screens/delivery_report.dart';
import './plumber/screens/register_warranty.dart';
import './plumber/screens/plumber_dashboard.dart';
import './plumber/screens/validate_warranty.dart';
import './plumber/screens/commissioned_work.dart';
import './worker/screens/worker_dashboard.dart';
import './worker/screens/production.dart';
import './worker/screens/manage_stock.dart';
import './worker/screens/report_damage.dart';
import './worker/screens/shift_alerts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountantProvider()),
      ],
      child: MaterialApp(
        title: 'Business Management App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: _createMaterialColor(AppColors.primary),
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textLight,
            elevation: 2,
            centerTitle: true,
          ),
          cardTheme: CardThemeData(
            surfaceTintColor: Colors.transparent,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textLight,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
          // Plumber
          '/seller/dashboard': (context) => const PlumberDashboardScreen(),
          '/seller/incentives': (context) => const PlumberIncentivesScreen(),
          '/seller/points': (context) => const PlumberPointsScreen(),
          '/seller/delivery-report': (context) =>
              const PlumberDeliveryReportScreen(),
          '/seller/register-warranty': (context) =>
              const PlumberRegisterWarrantyScreen(),
          '/seller/validate-warranty': (context) =>
              const PlumberValidateRegistrationScreen(),
          '/seller/commissioned-work': (context) =>
              const CommissionedWorkScreen(),
          // Worker
          '/worker/dashboard': (context) => const WorkerDashboardScreen(),
          '/worker/production': (context) => const WorkerProductionScreen(),
          '/worker/manage-stock': (context) => const WorkerManageStockScreen(),
          '/worker/report-damage': (context) =>
              const WorkerReportDamageScreen(),
          '/worker/shift-alerts': (context) => const WorkerShiftAlertsScreen(),
        },
      ),
    );
  }

  MaterialColor _createMaterialColor(Color color) {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }
}
