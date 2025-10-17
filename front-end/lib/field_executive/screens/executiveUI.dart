// // import 'package:flutter/material.dart';
// // import '../../constants/colors.dart';
// // import 'package:role_based_app/field_executive/widgets/AddFollowUpPage.dart';
// // import 'package:role_based_app/field_executive/widgets/AddProductToOrderPage.dart';
// // import 'package:role_based_app/field_executive/widgets/AssignedCustomersPage.dart';
// // import 'package:role_based_app/field_executive/widgets/Camera_Page.dart';
// // import 'package:role_based_app/field_executive/widgets/CaptureSignaturePage.dart';
// // import 'package:role_based_app/field_executive/widgets/Chat_Page.dart';
// // import 'package:role_based_app/field_executive/widgets/CheckStockPage.dart';
// // import 'package:role_based_app/field_executive/widgets/CustomerVisitReportFormPage.dart';
// // import 'package:role_based_app/field_executive/widgets/GetProductDetailsPage.dart';
// // import 'package:role_based_app/field_executive/widgets/PlaceOrderPage.dart';
// // import 'package:role_based_app/field_executive/widgets/ReceiveNotificationsPage.dart';
// // import 'package:role_based_app/field_executive/widgets/Status_Page.dart';
// // import 'package:role_based_app/field_executive/widgets/SubmitDvrPage.dart';
// // import 'package:role_based_app/field_executive/widgets/SyncOfflineDataPage.dart';
// // import 'package:role_based_app/field_executive/widgets/Tasks_Page.dart';
// // import 'package:role_based_app/field_executive/widgets/UpdateStockPage.dart';

// // class FieldExecutiveUI extends StatelessWidget {
// //   const FieldExecutiveUI({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     final Map<String, List<Map<String, dynamic>>> categorizedFeatures = {
// //       'GPS Tracking': [
// //         {'title': 'Start Tracking', 'page': const StatusPage(), 'icon': Icons.location_on},
// //         {'title': 'Status', 'page': const StatusPage(), 'icon': Icons.info_outline},
// //         {'title': 'Tasks', 'page': const TasksPage(), 'icon': Icons.task},
// //         {'title': 'Chat', 'page': const ChatPage(), 'icon': Icons.chat},
// //         {'title': 'Camera', 'page': const CameraPage(), 'icon': Icons.camera_alt},
// //       ],
// //       'Customer Visits': [
// //         {'title': 'Assigned Customers', 'page': const AssignedCustomersPage(), 'icon': Icons.people_outline},
// //         {'title': 'Visit Customer', 'page': const CustomerVisitReportFormPage(), 'icon': Icons.location_searching},
// //         {'title': 'Submit DVR', 'page': const SubmitDvrPage(), 'icon': Icons.upload},
// //         {'title': 'Add Follow Up', 'page': const AddFollowUpPage(), 'icon': Icons.add_alert},
// //       ],
// //       'Order Management': [
// //         {'title': 'Place Order', 'page': const PlaceOrderPage(), 'icon': Icons.shopping_cart},
// //         {'title': 'Get Product Details', 'page': const GetProductDetailsPage(), 'icon': Icons.info},
// //         {'title': 'Check Stock', 'page': const CheckStockPage(), 'icon': Icons.inventory},
// //         {'title': 'Add Product to Order', 'page': const AddProductToOrderPage(), 'icon': Icons.add_shopping_cart},
// //         {'title': 'Update Stock', 'page': const UpdateStockPage(), 'icon': Icons.update},
// //       ],
// //       'Other Operations': [
// //         {'title': 'Capture Signature', 'page': const CaptureSignaturePage(), 'icon': Icons.edit_document},
// //         {'title': 'Sync Offline Data', 'page': const SyncOfflinePage(), 'icon': Icons.sync},
// //         {'title': 'Receive Notifications', 'page': const NotificationsPage(), 'icon': Icons.notifications},
// //       ],
// //     };

// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: AppColors.primaryBlue,
// //         title: const Text('Executive Dashboard'),
// //       ),
// //       drawer: Drawer(
// //         child: ListView(
// //           padding: EdgeInsets.zero,
// //           children: [
// //             const DrawerHeader(
// //               decoration: BoxDecoration(color: AppColors.primaryBlue),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   SizedBox(height: 12),
// //                   CircleAvatar(
// //                     radius: 28,
// //                     child: Icon(Icons.badge, size: 32),
// //                   ),
// //                   SizedBox(height: 12),
// //                   Text(
// //                     'Field Executive',
// //                     style: TextStyle(
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 18,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             for (var category in categorizedFeatures.keys)
// //               ListTile(
// //                 leading: const Icon(Icons.folder_copy_outlined),
// //                 title: Text(category),
// //                 onTap: () {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (_) => FeatureCategoryPage(
// //                         title: category,
// //                         features: categorizedFeatures[category]!,
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ListTile(
// //               leading: const Icon(Icons.logout),
// //               title: const Text('Sign Out'),
// //               onTap: () => Navigator.pushReplacementNamed(context, '/login'),
// //             ),
// //           ],
// //         ),
// //       ),
// //       body: Container(
// //         color: Colors.grey.shade100,
// //         padding: const EdgeInsets.all(16.0),
// //         child: ListView(
// //           children: categorizedFeatures.entries.map((entry) {
// //             return Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Padding(
// //                   padding: const EdgeInsets.symmetric(vertical: 8.0),
// //                   child: Text(
// //                     entry.key,
// //                     style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
// //                   ),
// //                 ),
// //                 GridView.count(
// //                   crossAxisCount: 2,
// //                   shrinkWrap: true,
// //                   physics: const NeverScrollableScrollPhysics(),
// //                   crossAxisSpacing: 12,
// //                   mainAxisSpacing: 12,
// //                   childAspectRatio: 1.3,
// //                   children: entry.value.map((feature) {
// //                     return GestureDetector(
// //                       onTap: () => Navigator.push(
// //                         context,
// //                         MaterialPageRoute(builder: (_) => feature['page']),
// //                       ),
// //                       child: Card(
// //                         elevation: 4,
// //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //                         child: Padding(
// //                           padding: const EdgeInsets.all(16),
// //                           child: Column(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               Icon(feature['icon'], size: 32, color: AppColors.primaryBlue),
// //                               const SizedBox(height: 8),
// //                               Text(
// //                                 feature['title'],
// //                                 textAlign: TextAlign.center,
// //                                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   }).toList(),
// //                 ),
// //                 const SizedBox(height: 20),
// //               ],
// //             );
// //           }).toList(),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class FeatureCategoryPage extends StatelessWidget {
// //   final String title;
// //   final List<Map<String, dynamic>> features;

// //   const FeatureCategoryPage({required this.title, required this.features, Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: AppColors.primaryBlue,
// //         title: Text(title),
// //       ),
// //       body: Container(
// //         color: Colors.grey.shade100,
// //         padding: const EdgeInsets.all(16.0),
// //         child: GridView.count(
// //           crossAxisCount: 2,
// //           crossAxisSpacing: 12,
// //           mainAxisSpacing: 12,
// //           childAspectRatio: 1.3,
// //           children: features.map((feature) {
// //             return GestureDetector(
// //               onTap: () => Navigator.push(
// //                 context,
// //                 MaterialPageRoute(builder: (_) => feature['page']),
// //               ),
// //               child: Card(
// //                 elevation: 4,
// //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(16),
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Icon(feature['icon'], size: 32, color: AppColors.primaryBlue),
// //                       const SizedBox(height: 8),
// //                       Text(
// //                         feature['title'],
// //                         textAlign: TextAlign.center,
// //                         style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             );
// //           }).toList(),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:role_based_app/field_executive/widgets/tasks_page.dart';
// import '../../constants/colors.dart';
// import 'package:role_based_app/field_executive/widgets/AddFollowUpPage.dart';
// import 'package:role_based_app/field_executive/widgets/AddProductToOrderPage.dart';
// import 'package:role_based_app/field_executive/widgets/AssignedCustomersPage.dart';
// import 'package:role_based_app/field_executive/widgets/Camera_Page.dart';
// import 'package:role_based_app/field_executive/widgets/CaptureSignaturePage.dart';
// import 'package:role_based_app/field_executive/widgets/Chat_Page.dart';
// import 'package:role_based_app/field_executive/widgets/CheckStockPage.dart';
// import 'package:role_based_app/field_executive/widgets/CustomerVisitReportFormPage.dart';
// import 'package:role_based_app/field_executive/widgets/GetProductDetailsPage.dart';
// import 'package:role_based_app/field_executive/widgets/PlaceOrderPage.dart';
// import 'package:role_based_app/field_executive/widgets/ReceiveNotificationsPage.dart';
// import 'package:role_based_app/field_executive/widgets/location.dart';
// import 'package:role_based_app/field_executive/widgets/SubmitDvrPage.dart';
// import 'package:role_based_app/field_executive/widgets/SyncOfflineDataPage.dart';
// import 'package:role_based_app/field_executive/widgets/UpdateStockPage.dart';

// class FieldExecutiveUI extends StatelessWidget {
//   const FieldExecutiveUI({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final Map<String, List<Map<String, dynamic>>> categorizedFeatures = {
//       'GPS Tracking': [
//         {'title': 'Start Tracking', 'page': const UpdateLocationPage(), 'icon': Icons.location_on},
//         {'title': 'Tasks', 'page': const AddTaskPage(), 'icon': Icons.task},
//         {'title': 'Chat', 'page': const ChatPage(), 'icon': Icons.chat},
//         {'title': 'Camera', 'page': const CameraPage(), 'icon': Icons.camera_alt},
//       ],
//       'Customer Visits': [
//         {'title': 'Assigned Customers', 'page': const FieldExecutiveCustomersPage(), 'icon': Icons.people_outline},
//         {'title': 'Visit Customer', 'page': const CustomerVisitPage(), 'icon': Icons.location_searching},
//         {'title': 'Submit DVR', 'page': const DVRPage(), 'icon': Icons.upload},
//         {'title': 'Add Follow Up', 'page': const AddFollowUpPage(), 'icon': Icons.add_alert},
//       ],
//       'Order Management': [
//         {'title': 'Place Order', 'page': const FieldExecutivePlaceOrderPage(), 'icon': Icons.shopping_cart},
//         {'title': 'Get Product Details', 'page': const MyOrdersPage(), 'icon': Icons.info},
//         {'title': 'Check Stock', 'page': const StockPage(), 'icon': Icons.inventory},
//         {'title': 'Add Product to Order', 'page': const AddProductToOrderPage(), 'icon': Icons.add_shopping_cart},
//         {'title': 'Update Stock', 'page': const UpdateStockPage(), 'icon': Icons.update},
//       ],
//       'Other Operations': [
//         {'title': 'Capture Signature', 'page': const CaptureSignaturePage(), 'icon': Icons.edit_document},
//         {'title': 'Sync Offline Data', 'page': const SyncOfflineDataPage(), 'icon': Icons.sync},
//         {'title': 'Receive Notifications', 'page': const NotificationsPage(), 'icon': Icons.notifications},
//       ],
//     };

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Executive Dashboard"),
//         backgroundColor: AppColors.primaryBlue,
//         foregroundColor: Colors.white,
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(color: AppColors.primaryBlue),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CircleAvatar(
//                     radius: 28,
//                     backgroundColor: Colors.white,
//                     child: Icon(Icons.badge, size: 32, color: AppColors.primaryBlue),
//                   ),
//                   SizedBox(height: 12),
//                   Text(
//                     'Field Executive',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             for (var category in categorizedFeatures.keys)
//               ExpansionTile(
//                 leading: const Icon(Icons.folder_copy_outlined),
//                 title: Text(category),
//                 children: categorizedFeatures[category]!
//                     .map((feature) => ListTile(
//                           title: Text(feature['title']),
//                           onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (_) => feature['page']),
//                           ),
//                         ))
//                     .toList(),
//               ),
//             const Divider(),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Sign Out'),
//               onTap: () => Navigator.pushReplacementNamed(context, '/login'),
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: categorizedFeatures.entries.map((entry) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   entry.key,
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 12),
//                 GridView.count(
//                   crossAxisCount: 2,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   children: entry.value.map((feature) {
//                     return ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primaryBlue,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.all(12),
//                       ),
//                       onPressed: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => feature['page']),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(feature['icon'], size: 32),
//                           const SizedBox(height: 8),
//                           Text(
//                             feature['title'],
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }

// class FeatureCategoryPage extends StatelessWidget {
//   final String title;
//   final List<Map<String, dynamic>> features;

//   const FeatureCategoryPage({required this.title, required this.features, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primaryBlue,
//         foregroundColor: Colors.white,
//         title: Text(title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GridView.count(
//           crossAxisCount: 2,
//           crossAxisSpacing: 12,
//           mainAxisSpacing: 12,
//           children: features.map((feature) {
//             return ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryBlue,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.all(12),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               onPressed: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => feature['page']),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(feature['icon'], size: 32),
//                   const SizedBox(height: 8),
//                   Text(
//                     feature['title'],
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'package:role_based_app/field_executive/widgets/tasks_page.dart';
import 'package:role_based_app/field_executive/widgets/AddFollowUpPage.dart';
import 'package:role_based_app/field_executive/widgets/AddProductToOrderPage.dart';
import 'package:role_based_app/field_executive/widgets/AssignedCustomersPage.dart';
import 'package:role_based_app/field_executive/widgets/Camera_Page.dart';
import 'package:role_based_app/field_executive/widgets/CaptureSignaturePage.dart';
import 'package:role_based_app/field_executive/widgets/Chat_Page.dart';
import 'package:role_based_app/field_executive/widgets/CheckStockPage.dart';
import 'package:role_based_app/field_executive/widgets/CustomerVisitReportFormPage.dart';
import 'package:role_based_app/field_executive/widgets/GetProductDetailsPage.dart';
import 'package:role_based_app/field_executive/widgets/PlaceOrderPage.dart';
import 'package:role_based_app/field_executive/widgets/ReceiveNotificationsPage.dart';
import 'package:role_based_app/field_executive/widgets/location.dart';
import 'package:role_based_app/field_executive/widgets/SubmitDvrPage.dart';
import 'package:role_based_app/field_executive/widgets/SyncOfflineDataPage.dart';
import 'package:role_based_app/field_executive/widgets/UpdateStockPage.dart';

class FieldExecutiveUI extends StatelessWidget {
  const FieldExecutiveUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Field Executive Dashboard"),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primaryBlue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.badge, size: 32, color: AppColors.primaryBlue),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Field Executive',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Section 1: GPS & Communication
            ExpansionTile(
              leading: const Icon(Icons.location_on),
              title: const Text("GPS & Communication"),
              children: [
                _drawerItem(context, "Start Tracking", const UpdateLocationPage()),
                _drawerItem(context, "Tasks", const AddTaskPage()),
                _drawerItem(context, "Chat", const ChatPage()),
                _drawerItem(context, "Camera", const CameraPage()),
              ],
            ),

            // Section 2: Customer Visits
            ExpansionTile(
              leading: const Icon(Icons.people_alt_outlined),
              title: const Text("Customer Visits"),
              children: [
                _drawerItem(context, "Assigned Customers", const FieldExecutiveCustomersPage()),
                _drawerItem(context, "Visit Customer", const CustomerVisitPage()),
                _drawerItem(context, "Submit DVR", const DVRPage()),
                _drawerItem(context, "Add Follow Up", const AddFollowUpPage()),
              ],
            ),

            // Section 3: Order Management
            ExpansionTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("Order Management"),
              children: [
                _drawerItem(context, "Place Order", const FieldExecutivePlaceOrderPage()),
                _drawerItem(context, "Get Product Details", const MyOrdersPage()),
                _drawerItem(context, "Check Stock", const StockPage()),
                _drawerItem(context, "Add Product to Order", const AddProductToOrderPage()),
                _drawerItem(context, "Update Stock", const UpdateStockPage()),
              ],
            ),

            // Section 4: Other Operations
            ExpansionTile(
              leading: const Icon(Icons.settings_applications),
              title: const Text("Other Operations"),
              children: [
                _drawerItem(context, "Capture Signature", const CaptureSignaturePage()),
                _drawerItem(context, "Sync Offline Data", const SyncOfflineDataPage()),
                _drawerItem(context, "Receive Notifications", const NotificationsPage()),
              ],
            ),

            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sign Out"),
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),

      // -------- Dashboard Body --------
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _sectionTitle("GPS & Communication"),
            _gridSection(context, [
              _dashboardButton(context, "Start Tracking", Icons.location_on, const UpdateLocationPage()),
              _dashboardButton(context, "Tasks", Icons.task, const AddTaskPage()),
              _dashboardButton(context, "Chat", Icons.chat, const ChatPage()),
              _dashboardButton(context, "Camera", Icons.camera_alt, const CameraPage()),
            ]),

            const SizedBox(height: 16),
            _sectionTitle("Customer Visits"),
            _gridSection(context, [
              _dashboardButton(context, "Assigned Customers", Icons.people_outline, const FieldExecutiveCustomersPage()),
              _dashboardButton(context, "Visit Customer", Icons.location_searching, const CustomerVisitPage()),
              _dashboardButton(context, "Submit DVR", Icons.upload, const DVRPage()),
              _dashboardButton(context, "Add Follow Up", Icons.add_alert, const AddFollowUpPage()),
            ]),

            const SizedBox(height: 16),
            _sectionTitle("Order Management"),
            _gridSection(context, [
              _dashboardButton(context, "Place Order", Icons.shopping_cart, const FieldExecutivePlaceOrderPage()),
              _dashboardButton(context, "Product Details", Icons.info, const MyOrdersPage()),
              _dashboardButton(context, "Check Stock", Icons.inventory, const StockPage()),
              _dashboardButton(context, "Add to Order", Icons.add_shopping_cart, const AddProductToOrderPage()),
              _dashboardButton(context, "Update Stock", Icons.update, const UpdateStockPage()),
            ]),

            const SizedBox(height: 16),
            _sectionTitle("Other Operations"),
            _gridSection(context, [
              _dashboardButton(context, "Capture Signature", Icons.edit_document, const CaptureSignaturePage()),
              _dashboardButton(context, "Sync Offline Data", Icons.sync, const SyncOfflineDataPage()),
              _dashboardButton(context, "Notifications", Icons.notifications, const NotificationsPage()),
            ]),
          ],
        ),
      ),
    );
  }

  // ----------------- Helper Widgets -----------------

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _drawerItem(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
    );
  }

  Widget _gridSection(BuildContext context, List<Widget> children) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: children,
    );
  }

  Widget _dashboardButton(BuildContext context, String title, IconData icon, Widget page) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

