// // // import 'package:flutter/material.dart';
// // // import '../../constants/colors.dart'; // Ensure AppColors is defined here

// // // class CustomerVisitReportFormPage extends StatefulWidget {
// // //   const CustomerVisitReportFormPage({super.key});

// // //   @override
// // //   State<CustomerVisitReportFormPage> createState() => _CustomerVisitReportFormPageState();
// // // }

// // // class _CustomerVisitReportFormPageState extends State<CustomerVisitReportFormPage> {
// // //   final customerController = TextEditingController(text: "ABC Pvt Ltd");
// // //   final locationController = TextEditingController(text: "Chennai");
// // //   final presentController = TextEditingController(text: "Mr. Kumar, Ms. Priya");
// // //   final productsController = TextEditingController(text: "Product X, Product Y");
// // //   final reasonController = TextEditingController(text: "Regular check-in & product feedback");
// // //   final concernsController = TextEditingController(text: "Packaging issues reported");
// // //   final feedbackController = TextEditingController(text: "Customer appreciated the support.");
// // //   final reportByController = TextEditingController(text: "John Doe");

// // //   String investigation = "Ongoing";
// // //   String rootCause = "Product defect";
// // //   String correctiveAction = "Replace batch";
// // //   String recommendation = "Increase QA checks";
// // //   DateTime? visitDate = DateTime.now();

// // //   Future<void> _selectVisitDate(BuildContext context) async {
// // //     final picked = await showDatePicker(
// // //       context: context,
// // //       initialDate: visitDate ?? DateTime.now(),
// // //       firstDate: DateTime(2000),
// // //       lastDate: DateTime(2100),
// // //     );
// // //     if (picked != null) {
// // //       setState(() => visitDate = picked);
// // //     }
// // //   }

// // //   Widget sectionTitle(String title) {
// // //     return Container(
// // //       width: double.infinity,
// // //       padding: const EdgeInsets.symmetric(vertical: 8),
// // //       decoration: BoxDecoration(
// // //         color: AppColors.primaryBlue.withOpacity(0.15),
// // //         borderRadius: BorderRadius.circular(6),
// // //       ),
// // //       child: Text(
// // //         title,
// // //         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// // //         textAlign: TextAlign.center,
// // //       ),
// // //     );
// // //   }

// // //   Widget buildField(String label, TextEditingController controller, {int maxLines = 1}) {
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
// // //         const SizedBox(height: 6),
// // //         TextField(
// // //           controller: controller,
// // //           maxLines: maxLines,
// // //           decoration: const InputDecoration(
// // //             border: OutlineInputBorder(),
// // //             filled: true,
// // //             fillColor: Colors.white,
// // //           ),
// // //         ),
// // //         const SizedBox(height: 16),
// // //       ],
// // //     );
// // //   }

// // //   Widget buildDropdown(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
// // //         const SizedBox(height: 6),
// // //         DropdownButtonFormField<String>(
// // //           value: value,
// // //           onChanged: onChanged,
// // //           decoration: const InputDecoration(
// // //             border: OutlineInputBorder(),
// // //             filled: true,
// // //             fillColor: Colors.white,
// // //           ),
// // //           items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
// // //         ),
// // //         const SizedBox(height: 16),
// // //       ],
// // //     );
// // //   }

// // //   void _submitReport() {
// // //     String summary = '''
// // // Customer: ${customerController.text}
// // // Date of Visit: ${visitDate != null ? "${visitDate!.day}/${visitDate!.month}/${visitDate!.year}" : 'Not selected'}
// // // Location: ${locationController.text}
// // // Present: ${presentController.text}
// // // Products: ${productsController.text}
// // // Reason: ${reasonController.text}

// // // Concerns: ${concernsController.text}
// // // Investigation: $investigation
// // // Root Cause: $rootCause
// // // Corrective Action: $correctiveAction
// // // Recommendations: $recommendation

// // // General Feedback: ${feedbackController.text}
// // // Report Completed By: ${reportByController.text}
// // // ''';

// // //     showDialog(
// // //       context: context,
// // //       builder: (_) => AlertDialog(
// // //         title: const Text("Visit Report Submitted"),
// // //         content: SingleChildScrollView(child: Text(summary)),
// // //         actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
// // //       ),
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: const Color(0xFFF4F6F8),
// // //       appBar: AppBar(
// // //         title: const Text("Customer Visit Report"),
// // //         backgroundColor: AppColors.primaryBlue,
// // //         foregroundColor: Colors.white,
// // //       ),
// // //       body: SingleChildScrollView(
// // //         padding: const EdgeInsets.all(20),
// // //         child: Column(
// // //           children: [
// // //             sectionTitle("INFORMATION"),
// // //             buildField("Customer", customerController),
// // //             Row(
// // //               children: [
// // //                 const Text("Date of Visit: ", style: TextStyle(fontWeight: FontWeight.w600)),
// // //                 TextButton.icon(
// // //                   onPressed: () => _selectVisitDate(context),
// // //                   icon: const Icon(Icons.calendar_today),
// // //                   label: Text(
// // //                     visitDate != null
// // //                         ? "${visitDate!.day}/${visitDate!.month}/${visitDate!.year}"
// // //                         : "Select Date",
// // //                     style: const TextStyle(fontWeight: FontWeight.w500),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //             buildField("Location", locationController),
// // //             buildField("People Present", presentController),
// // //             buildField("Products Discussed", productsController, maxLines: 2),
// // //             buildField("Reason for Visit", reasonController),

// // //             sectionTitle("QUALITY"),
// // //             buildField("Customer Concerns", concernsController, maxLines: 2),
// // //             buildDropdown("Investigation Status", investigation, ["None", "Ongoing", "Resolved"], (val) {
// // //               if (val != null) setState(() => investigation = val);
// // //             }),
// // //             buildDropdown("Root Cause", rootCause, ["None", "Product defect", "Miscommunication"], (val) {
// // //               if (val != null) setState(() => rootCause = val);
// // //             }),
// // //             buildDropdown("Corrective Action", correctiveAction, ["None", "Replace batch", "Schedule meeting"], (val) {
// // //               if (val != null) setState(() => correctiveAction = val);
// // //             }),
// // //             buildDropdown("Recommendations", recommendation, ["None", "Increase QA checks", "Follow-up visit"], (val) {
// // //               if (val != null) setState(() => recommendation = val);
// // //             }),

// // //             sectionTitle("GENERAL FEEDBACK"),
// // //             buildField("Feedback / Comments", feedbackController, maxLines: 2),
// // //             buildField("Report Completed By", reportByController),

// // //             const SizedBox(height: 20),
// // //             SizedBox(
// // //               width: double.infinity,
// // //               child: ElevatedButton.icon(
// // //                 onPressed: _submitReport,
// // //                 icon: const Icon(Icons.save_alt),
// // //                 label: const Text("Submit Report"),
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor: AppColors.primaryBlue,
// // //                   padding: const EdgeInsets.symmetric(vertical: 14),
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:dio/dio.dart';
// // import '../../authpage/pages/auth_services.dart';

// // class CustomerVisitReportPage extends StatefulWidget {
// //   const CustomerVisitReportPage({super.key});

// //   @override
// //   State<CustomerVisitReportPage> createState() => _CustomerVisitReportPageState();
// // }

// // class _CustomerVisitReportPageState extends State<CustomerVisitReportPage> {
// //   final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));
// //   bool loading = false;
// //   String? message;

// //   final TextEditingController customerController = TextEditingController();
// //   final TextEditingController locationController = TextEditingController();
// //   final TextEditingController peopleController = TextEditingController();
// //   final TextEditingController productsController = TextEditingController();
// //   final TextEditingController reasonController = TextEditingController();
// //   final TextEditingController concernsController = TextEditingController();
// //   final TextEditingController investigationController = TextEditingController();
// //   final TextEditingController rootCauseController = TextEditingController();
// //   final TextEditingController correctiveActionController = TextEditingController();
// //   final TextEditingController recommendationsController = TextEditingController();
// //   final TextEditingController feedbackController = TextEditingController();
// //   final TextEditingController reportByController = TextEditingController();

// //   DateTime visitDate = DateTime.now();

// //   Future<void> submitReport() async {
// //     setState(() {
// //       loading = true;
// //       message = null;
// //     });

// //     try {
// //       final authService = AuthService();
// //       final token = await authService.getToken();
// //       if (token == null) return;

// //       final response = await dio.post(
// //         '/fieldExecutive/customers',
// //         data: {
// //           'customerId': customerController.text.trim(),
// //           'visitDate': visitDate.toIso8601String(),
// //           'location': locationController.text.trim(),
// //           'peoplePresent': peopleController.text.trim(),
// //           'productsDiscussed': productsController.text.trim(),
// //           'reasonForVisit': reasonController.text.trim(),
// //           'customerConcerns': concernsController.text.trim(),
// //           'investigationStatus': investigationController.text.trim(),
// //           'rootCause': rootCauseController.text.trim(),
// //           'correctiveAction': correctiveActionController.text.trim(),
// //           'recommendations': recommendationsController.text.trim(),
// //           'feedback': feedbackController.text.trim(),
// //           'reportCompletedBy': reportByController.text.trim(),
// //         },
// //         options: Options(
// //           headers: {'Authorization': 'Bearer $token'},
// //         ),
// //       );

// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         setState(() {
// //           message = "✅ Visit report submitted successfully!";
// //         });
// //       } else {
// //         setState(() {
// //           message = "⚠️ Submission failed (${response.statusCode})";
// //         });
// //       }
// //     } catch (e) {
// //       setState(() {
// //         message = "❌ Error: $e";
// //       });
// //     } finally {
// //       setState(() => loading = false);
// //     }
// //   }

// //   Future<void> pickVisitDate() async {
// //     final picked = await showDatePicker(
// //       context: context,
// //       initialDate: visitDate,
// //       firstDate: DateTime(2020),
// //       lastDate: DateTime(2030),
// //     );
// //     if (picked != null) setState(() => visitDate = picked);
// //   }

// //   Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 6),
// //       child: TextField(
// //         controller: controller,
// //         maxLines: maxLines,
// //         decoration: InputDecoration(
// //           labelText: label,
// //           border: const OutlineInputBorder(),
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Customer Visit Report")),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             _buildTextField("Customer ID", customerController),
// //             Row(
// //               children: [
// //                 Expanded(child: Text("Visit Date: ${visitDate.toLocal().toString().split(' ')[0]}")),
// //                 TextButton.icon(
// //                   icon: const Icon(Icons.calendar_today),
// //                   label: const Text("Pick Date"),
// //                   onPressed: pickVisitDate,
// //                 ),
// //               ],
// //             ),
// //             _buildTextField("Location", locationController),
// //             _buildTextField("People Present", peopleController),
// //             _buildTextField("Products Discussed", productsController),
// //             _buildTextField("Reason for Visit", reasonController, maxLines: 2),
// //             _buildTextField("Customer Concerns", concernsController, maxLines: 2),
// //             _buildTextField("Investigation Status", investigationController, maxLines: 2),
// //             _buildTextField("Root Cause", rootCauseController, maxLines: 2),
// //             _buildTextField("Corrective Action", correctiveActionController, maxLines: 2),
// //             _buildTextField("Recommendations", recommendationsController, maxLines: 2),
// //             _buildTextField("Feedback", feedbackController, maxLines: 2),
// //             _buildTextField("Report Completed By", reportByController),
// //             const SizedBox(height: 16),
// //             ElevatedButton(
// //               onPressed: loading ? null : submitReport,
// //               child: loading
// //                   ? const CircularProgressIndicator(color: Colors.white)
// //                   : const Text("Submit Report"),
// //             ),
// //             if (message != null) ...[
// //               const SizedBox(height: 16),
// //               Text(
// //                 message!,
// //                 style: TextStyle(
// //                   color: message!.contains("✅") ? Colors.green : Colors.red,
// //                   fontWeight: FontWeight.w500,
// //                 ),
// //               ),
// //             ]
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import '../../authpage/pages/auth_services.dart';

// class CustomerVisitPage extends StatefulWidget {
//   const CustomerVisitPage({super.key});

//   @override
//   State<CustomerVisitPage> createState() => _CustomerVisitPageState();
// }

// class _CustomerVisitPageState extends State<CustomerVisitPage> {
//   final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));

//   final TextEditingController customerIdController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController feedbackController = TextEditingController();
//   final TextEditingController peoplePresentController = TextEditingController();
//   final TextEditingController productsDiscussedController = TextEditingController();
//   final TextEditingController reasonForVisitController = TextEditingController();

//   bool loading = false;
//   String? message;
//   List<dynamic> visits = [];

//   String? currentCustomerId;

//   // ✅ Fetch visit reports for entered customer ID
//   Future<void> fetchCustomerVisits() async {
//     if (customerIdController.text.isEmpty) {
//       setState(() => message = "⚠️ Please enter a Customer ID");
//       return;
//     }

//     setState(() {
//       loading = true;
//       message = null;
//       currentCustomerId = customerIdController.text;
//     });

//     try {
//       final token = await AuthService().getToken();
//       if (token == null) {
//         setState(() => message = "⚠️ No token found. Please login again.");
//         return;
//       }

//       final response = await dio.get(
//         "/fieldExecutive/customers/$currentCustomerId",
//         queryParameters: {"customerId": currentCustomerId},
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );

//       setState(() {
//         visits = response.data;
//         message = null;
//       });
//     } catch (e) {
//       setState(() => message = "❌ Failed to load visit reports: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   // ✅ Submit a visit report for entered customer ID
//   Future<void> submitVisitReport() async {
//     if (currentCustomerId == null) {
//       setState(() => message = "⚠️ Please fetch a customer first!");
//       return;
//     }

//     if (locationController.text.isEmpty) {
//       setState(() => message = "⚠️ Location is required!");
//       return;
//     }

//     setState(() {
//       loading = true;
//       message = null;
//     });

//     try {
//       final token = await AuthService().getToken();
//       if (token == null) {
//         setState(() => message = "⚠️ No token found. Please login again.");
//         return;
//       }

//       await dio.post(
//         "/fieldExecutive/customers/$currentCustomerId/visits",
//         data: {
//           "visitDate": DateTime.now().toIso8601String(),
//           "location": locationController.text,
//           "peoplePresent": peoplePresentController.text,
//           "productsDiscussed": productsDiscussedController.text,
//           "reasonForVisit": reasonForVisitController.text,
//           "feedback": feedbackController.text,
//         },
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );

//       setState(() {
//         message = "✅ Visit report submitted successfully!";
//       });

//       // Clear form
//       locationController.clear();
//       feedbackController.clear();
//       peoplePresentController.clear();
//       productsDiscussedController.clear();
//       reasonForVisitController.clear();

//       await fetchCustomerVisits();
//     } catch (e) {
//       setState(() => message = "❌ Error submitting visit report: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Customer Visit Report")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // --- Customer ID Input ---
//             TextField(
//               controller: customerIdController,
//               decoration: const InputDecoration(labelText: "Enter Customer ID"),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: loading ? null : fetchCustomerVisits,
//               child: loading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text("Fetch Visits"),
//             ),

//             const Divider(height: 30),

//             // --- Visit Report Form ---
//             TextField(
//               controller: locationController,
//               decoration: const InputDecoration(labelText: "Location"),
//             ),
//             TextField(
//               controller: peoplePresentController,
//               decoration: const InputDecoration(labelText: "People Present"),
//             ),
//             TextField(
//               controller: productsDiscussedController,
//               decoration: const InputDecoration(labelText: "Products Discussed"),
//             ),
//             TextField(
//               controller: reasonForVisitController,
//               decoration: const InputDecoration(labelText: "Reason for Visit"),
//             ),
//             TextField(
//               controller: feedbackController,
//               decoration: const InputDecoration(labelText: "Feedback / Notes"),
//             ),
//             const SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: loading ? null : submitVisitReport,
//               child: loading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text("Submit Visit Report"),
//             ),

//             if (message != null)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Text(
//                   message!,
//                   style: TextStyle(
//                     color: message!.contains("✅") ? Colors.green : Colors.red,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),

//             const Divider(height: 40),
//             const Text(
//               "Customer Visit History",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),

//             loading
//                 ? const Center(child: CircularProgressIndicator())
//                 : visits.isEmpty
//                     ? const Text("No visit reports yet.")
//                     : ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: visits.length,
//                         itemBuilder: (context, index) {
//                           final v = visits[index];
//                           return Card(
//                             margin: const EdgeInsets.symmetric(vertical: 8),
//                             elevation: 3,
//                             child: ListTile(
//                               title: Text(
//                                 "📍 ${v['location'] ?? 'Unknown Location'}",
//                                 style: const TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 4),
//                                   Text("Feedback: ${v['feedback'] ?? 'N/A'}"),
//                                   Text("Reason: ${v['reasonForVisit'] ?? 'N/A'}"),
//                                   if (v['visitDate'] != null)
//                                     Text("Date: ${v['visitDate'].toString().substring(0, 10)}"),
//                                   if (v['customer'] != null)
//                                     Text("Customer: ${v['customer']['name']}"),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import '../../authpage/pages/auth_services.dart';

// class CustomerVisitPage extends StatefulWidget {
//   const CustomerVisitPage({super.key});

//   @override
//   State<CustomerVisitPage> createState() => _CustomerVisitPageState();
// }

// class _CustomerVisitPageState extends State<CustomerVisitPage> {
//   final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));

//   bool loading = false;
//   String? message;

//   Map<String, dynamic>? customer;
//   List<dynamic> visits = [];

//   // Controllers
//   final TextEditingController customerIdController = TextEditingController();
//   final TextEditingController visitDateController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController peoplePresentController = TextEditingController();
//   final TextEditingController productsDiscussedController = TextEditingController();
//   final TextEditingController reasonController = TextEditingController();
//   final TextEditingController concernsController = TextEditingController();
//   final TextEditingController investigationController = TextEditingController();
//   final TextEditingController rootCauseController = TextEditingController();
//   final TextEditingController correctiveActionController = TextEditingController();
//   final TextEditingController recommendationsController = TextEditingController();
//   final TextEditingController feedbackController = TextEditingController();

//   Future<String?> _getToken() async {
//     final authService = AuthService();
//     return await authService.getToken();
//   }

//   // 1️⃣ Get Customer By ID
//   Future<void> getCustomerById() async {
//     final id = customerIdController.text.trim();
//     if (id.isEmpty) {
//       setState(() => message = "⚠️ Enter Customer ID");
//       return;
//     }

//     setState(() {
//       loading = true;
//       message = null;
//       customer = null;
//     });

//     try {
//       final token = await _getToken();
//       final response = await dio.get(
//         "/fieldExecutive/customers/$id",
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );
//       setState(() {
//         customer = response.data;
//         message = "✅ Customer fetched successfully";
//       });
//     } catch (e) {
//       String errorMessage = "❌ Failed to fetch customer";
//       if (e is DioError && e.response != null) {
//         errorMessage = "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
//       }
//       setState(() => message = errorMessage);
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   // 2️⃣ Create Visit Report
//   Future<void> createVisitReport() async {
//     final id = customerIdController.text.trim();
//     if (id.isEmpty || visitDateController.text.isEmpty || locationController.text.isEmpty) {
//       setState(() => message = "⚠️ Customer ID, Visit Date, and Location are required");
//       return;
//     }

//     setState(() {
//       loading = true;
//       message = null;
//     });

//     try {
//       final token = await _getToken();
//       final response = await dio.post(
//         "/fieldExecutive/customers/$id/visits",
//         data: {
//           "visitDate": visitDateController.text,
//           "location": locationController.text,
//           "peoplePresent": peoplePresentController.text,
//           "productsDiscussed": productsDiscussedController.text,
//           "reasonForVisit": reasonController.text,
//           "customerConcerns": concernsController.text,
//           "investigationStatus": investigationController.text,
//           "rootCause": rootCauseController.text,
//           "correctiveAction": correctiveActionController.text,
//           "recommendations": recommendationsController.text,
//           "feedback": feedbackController.text,
//         },
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );

//       setState(() {
//         message = "✅ Visit report created successfully!";
//         // Clear form
//         visitDateController.clear();
//         locationController.clear();
//         peoplePresentController.clear();
//         productsDiscussedController.clear();
//         reasonController.clear();
//         concernsController.clear();
//         investigationController.clear();
//         rootCauseController.clear();
//         correctiveActionController.clear();
//         recommendationsController.clear();
//         feedbackController.clear();
//       });

//       getVisitReports(); // Refresh visit list
//     } catch (e) {
//       String errorMessage = "❌ Failed to create visit report";
//       if (e is DioError && e.response != null) {
//         errorMessage = "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
//       }
//       setState(() => message = errorMessage);
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   // 3️⃣ Get Visit Reports
//   Future<void> getVisitReports() async {
//     final id = customerIdController.text.trim();

//     setState(() {
//       loading = true;
//       message = null;
//       visits = [];
//     });

//     try {
//       final token = await _getToken();
//       Map<String, dynamic>? queryParams;
//       if (id.isNotEmpty) queryParams = {"customerId": id};

//       final response = await dio.get(
//         "/fieldExecutive/customers/visits",
//         queryParameters: queryParams,
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );

//       setState(() {
//         visits = response.data;
//         message = "📄 ${visits.length} visit reports found.";
//       });
//     } catch (e) {
//       String errorMessage = "❌ Failed to fetch visit reports";
//       if (e is DioError && e.response != null) {
//         errorMessage = "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
//       }
//       setState(() => message = errorMessage);
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   @override
//   void dispose() {
//     customerIdController.dispose();
//     visitDateController.dispose();
//     locationController.dispose();
//     peoplePresentController.dispose();
//     productsDiscussedController.dispose();
//     reasonController.dispose();
//     concernsController.dispose();
//     investigationController.dispose();
//     rootCauseController.dispose();
//     correctiveActionController.dispose();
//     recommendationsController.dispose();
//     feedbackController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Customer Visits")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             if (loading) const LinearProgressIndicator(),
//             if (message != null)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Text(message!, style: const TextStyle(fontSize: 16, color: Colors.red)),
//               ),

//             // Customer ID
//             TextField(controller: customerIdController, decoration: const InputDecoration(labelText: "Customer ID")),

//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 Expanded(child: ElevatedButton(onPressed: getCustomerById, child: const Text("Get Customer"))),
//                 const SizedBox(width: 10),
//                 Expanded(child: ElevatedButton(onPressed: getVisitReports, child: const Text("Get Visits"))),
//               ],
//             ),

//             const SizedBox(height: 20),
//             if (customer != null) ...[
//               Text("Customer Info", style: const TextStyle(fontWeight: FontWeight.bold)),
//               Text("Name: ${customer!['name']}"),
//               Text("Email: ${customer!['email'] ?? '-'}"),
//               Text("Phone: ${customer!['phone']}"),
//               const Divider(),
//             ],

//             // Visit Report Form
//             const Text("Create Visit Report", style: TextStyle(fontWeight: FontWeight.bold)),
//             TextField(controller: visitDateController, decoration: const InputDecoration(labelText: "Visit Date (YYYY-MM-DD)")),
//             TextField(controller: locationController, decoration: const InputDecoration(labelText: "Location")),
//             TextField(controller: peoplePresentController, decoration: const InputDecoration(labelText: "People Present")),
//             TextField(controller: productsDiscussedController, decoration: const InputDecoration(labelText: "Products Discussed")),
//             TextField(controller: reasonController, decoration: const InputDecoration(labelText: "Reason for Visit")),
//             TextField(controller: concernsController, decoration: const InputDecoration(labelText: "Customer Concerns")),
//             TextField(controller: investigationController, decoration: const InputDecoration(labelText: "Investigation Status")),
//             TextField(controller: rootCauseController, decoration: const InputDecoration(labelText: "Root Cause")),
//             TextField(controller: correctiveActionController, decoration: const InputDecoration(labelText: "Corrective Action")),
//             TextField(controller: recommendationsController, decoration: const InputDecoration(labelText: "Recommendations")),
//             TextField(controller: feedbackController, decoration: const InputDecoration(labelText: "Feedback")),
//             const SizedBox(height: 10),
//             ElevatedButton(onPressed: createVisitReport, child: const Text("Submit Visit Report")),

//             const SizedBox(height: 20),
//             if (visits.isNotEmpty) ...[
//               const Text("Visit Reports", style: TextStyle(fontWeight: FontWeight.bold)),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: visits.length,
//                 itemBuilder: (context, index) {
//                   final visit = visits[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 5),
//                     child: ListTile(
//                       title: Text("Visit on ${visit['visitDate'].toString().split('T')[0]} at ${visit['location']}"),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("People: ${visit['peoplePresent'] ?? '-'}"),
//                           Text("Products: ${visit['productsDiscussed'] ?? '-'}"),
//                           Text("Reason: ${visit['reasonForVisit'] ?? '-'}"),
//                           Text("Feedback: ${visit['feedback'] ?? '-'}"),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../authpage/pages/auth_services.dart';

class CustomerVisitPage extends StatefulWidget {
  const CustomerVisitPage({super.key});

  @override
  State<CustomerVisitPage> createState() => _CustomerVisitPageState();
}

class _CustomerVisitPageState extends State<CustomerVisitPage> {
  final dio = Dio(BaseOptions(baseUrl: "http://localhost:5001"));

  bool loading = false;
  String? message;

  Map<String, dynamic>? customer;
  List<dynamic> visits = [];
  List<dynamic> customers = [];
  String? selectedCustomerId;

  // Controllers
  final TextEditingController customerIdController = TextEditingController();
  final TextEditingController visitDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController peoplePresentController = TextEditingController();
  final TextEditingController productsDiscussedController =
      TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController concernsController = TextEditingController();
  final TextEditingController investigationController = TextEditingController();
  final TextEditingController rootCauseController = TextEditingController();
  final TextEditingController correctiveActionController =
      TextEditingController();
  final TextEditingController recommendationsController =
      TextEditingController();
  final TextEditingController feedbackController = TextEditingController();
  final TextEditingController reportCompletedByController =
      TextEditingController(); // NEW

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
  }

  // 0️⃣ Get Assigned Customers for dropdown
  Future<void> getAssignedCustomers() async {
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final token = await _getToken();
      final response = await dio.get(
        "/fieldExecutive/customers",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      final data = response.data;
      if (data is List) {
        customers = data;
      } else {
        customers = [];
      }
      if (customers.isNotEmpty) {
        selectedCustomerId = customers.first['id']?.toString();
        customerIdController.text = selectedCustomerId ?? '';
      }
      setState(() {});
    } catch (e) {
      String errorMessage = "❌ Failed to load customers";
      if (e is DioException && e.response != null) {
        errorMessage =
            "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
      }
      setState(() => message = errorMessage);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getAssignedCustomers();
  }

  // 1️⃣ Get Customer By ID
  Future<void> getCustomerById() async {
    final id = customerIdController.text.trim();
    if (id.isEmpty) {
      setState(() => message = "⚠️ Enter Customer ID");
      return;
    }

    setState(() {
      loading = true;
      message = null;
      customer = null;
    });

    try {
      final token = await _getToken();
      final response = await dio.get(
        "/fieldExecutive/customers/$id",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      setState(() {
        customer = response.data;
        message = "✅ Customer fetched successfully";
        customerIdController.text = response.data['id'].toString();
      });
    } catch (e) {
      String errorMessage = "❌ Failed to fetch customer";
      if (e is DioException && e.response != null) {
        errorMessage =
            "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
      }
      setState(() => message = errorMessage);
    } finally {
      setState(() => loading = false);
    }
  }

  // 2️⃣ Create Visit Report
  Future<void> createVisitReport() async {
    final id = customerIdController.text.trim();
    if (id.isEmpty ||
        visitDateController.text.isEmpty ||
        locationController.text.isEmpty ||
        reportCompletedByController.text.isEmpty) {
      setState(() => message =
          "⚠️ Customer ID, Visit Date, Location & Completed By are required");
      return;
    }

    setState(() {
      loading = true;
      message = null;
    });

    try {
      final token = await _getToken();
      try {
        DateTime.parse(visitDateController.text);
      } catch (_) {
        setState(() => message = "⚠️ Invalid date format (use YYYY-MM-DD)");
        return;
      }
      await dio.post(
        "/fieldExecutive/customers/$id/visits",
        data: {
          "visitDate": visitDateController.text,
          "location": locationController.text,
          "peoplePresent": peoplePresentController.text,
          "productsDiscussed": productsDiscussedController.text,
          "reasonForVisit": reasonController.text,
          "customerConcerns": concernsController.text,
          "investigationStatus": investigationController.text,
          "rootCause": rootCauseController.text,
          "correctiveAction": correctiveActionController.text,
          "recommendations": recommendationsController.text,
          "feedback": feedbackController.text,
          "reportCompletedBy": reportCompletedByController.text, // NEW
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        message = "✅ Visit report created successfully!";
        // Clear form
        visitDateController.clear();
        locationController.clear();
        peoplePresentController.clear();
        productsDiscussedController.clear();
        reasonController.clear();
        concernsController.clear();
        investigationController.clear();
        rootCauseController.clear();
        correctiveActionController.clear();
        recommendationsController.clear();
        feedbackController.clear();
        reportCompletedByController.clear();
      });

      getVisitReports(); // Refresh visit list
    } catch (e) {
      String errorMessage = "❌ Failed to create visit report";
      if (e is DioException && e.response != null) {
        errorMessage =
            "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
      }
      setState(() => message = errorMessage);
    } finally {
      setState(() => loading = false);
    }
  }

  // 3️⃣ Get Visit Reports
  Future<void> getVisitReports() async {
    final id = customerIdController.text.trim();

    setState(() {
      loading = true;
      message = null;
      visits = [];
    });

    try {
      final token = await _getToken();
      Map<String, dynamic>? queryParams;
      if (id.isNotEmpty) queryParams = {"customerId": id};

      final response = await dio.get(
        "/fieldExecutive/customers/visits",
        queryParameters: queryParams,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      setState(() {
        // Backend returns an array, not an object. Fall back to ['visits'] if shape changes.
        final data = response.data;
        if (data is List) {
          visits = data;
        } else if (data is Map && data['visits'] is List) {
          visits = data['visits'];
        } else {
          visits = [];
        }
        message = "📄 ${visits.length} visit reports found.";
      });
    } catch (e) {
      String errorMessage = "❌ Failed to fetch visit reports";
      if (e is DioException && e.response != null) {
        errorMessage =
            "❌ Error: ${e.response!.data['message'] ?? e.response!.statusMessage}";
      }
      setState(() => message = errorMessage);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    customerIdController.dispose();
    visitDateController.dispose();
    locationController.dispose();
    peoplePresentController.dispose();
    productsDiscussedController.dispose();
    reasonController.dispose();
    concernsController.dispose();
    investigationController.dispose();
    rootCauseController.dispose();
    correctiveActionController.dispose();
    recommendationsController.dispose();
    feedbackController.dispose();
    reportCompletedByController.dispose(); // NEW
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer Visits")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (loading) const LinearProgressIndicator(),
            if (message != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(message!,
                    style: const TextStyle(fontSize: 16, color: Colors.red)),
              ),

            DropdownButtonFormField<String>(
              value: selectedCustomerId,
              isExpanded: true,
              decoration: const InputDecoration(labelText: "Select Customer"),
              items: customers
                  .map<DropdownMenuItem<String>>((c) => DropdownMenuItem(
                        value: c['id']?.toString(),
                        child: Text(
                            (c['name'] ?? 'Unknown') +
                                (c['phone'] != null ? " (${c['phone']})" : ''),
                            overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCustomerId = value;
                  customerIdController.text = value ?? '';
                });
              },
            ),

            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: getAssignedCustomers,
                        child: const Text("Refresh Customers"))),
                const SizedBox(width: 10),
                Expanded(
                    child: ElevatedButton(
                        onPressed: getVisitReports,
                        child: const Text("Get Visits"))),
              ],
            ),

            const SizedBox(height: 20),
            if (customer != null) ...[
              Text("Customer Info",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("Name: ${customer!['name']}"),
              Text("Email: ${customer!['email'] ?? '-'}"),
              Text("Phone: ${customer!['phone']}"),
              const Divider(),
            ],

            const Text("Create Visit Report",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
                controller: visitDateController,
                decoration: const InputDecoration(
                    labelText: "Visit Date (YYYY-MM-DD)")),
            TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: "Location")),
            TextField(
                controller: peoplePresentController,
                decoration: const InputDecoration(labelText: "People Present")),
            TextField(
                controller: productsDiscussedController,
                decoration:
                    const InputDecoration(labelText: "Products Discussed")),
            TextField(
                controller: reasonController,
                decoration:
                    const InputDecoration(labelText: "Reason for Visit")),
            TextField(
                controller: concernsController,
                decoration:
                    const InputDecoration(labelText: "Customer Concerns")),
            TextField(
                controller: investigationController,
                decoration:
                    const InputDecoration(labelText: "Investigation Status")),
            TextField(
                controller: rootCauseController,
                decoration: const InputDecoration(labelText: "Root Cause")),
            TextField(
                controller: correctiveActionController,
                decoration:
                    const InputDecoration(labelText: "Corrective Action")),
            TextField(
                controller: recommendationsController,
                decoration:
                    const InputDecoration(labelText: "Recommendations")),
            TextField(
                controller: feedbackController,
                decoration: const InputDecoration(labelText: "Feedback")),
            TextField(
                controller: reportCompletedByController,
                decoration: const InputDecoration(
                    labelText: "Report Completed By")), // NEW
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: createVisitReport,
                child: const Text("Submit Visit Report")),

            const SizedBox(height: 20),
            if (visits.isNotEmpty) ...[
              const Text("Visit Reports",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visits.length,
                itemBuilder: (context, index) {
                  final visit = visits[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                          "Visit on ${visit['visitDate'].toString().split('T')[0]} at ${visit['location']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("People: ${visit['peoplePresent'] ?? '-'}"),
                          Text(
                              "Products: ${visit['productsDiscussed'] ?? '-'}"),
                          Text("Reason: ${visit['reasonForVisit'] ?? '-'}"),
                          Text("Feedback: ${visit['feedback'] ?? '-'}"),
                          Text(
                              "Completed By: ${visit['reportCompletedBy'] ?? '-'}"), // NEW
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
