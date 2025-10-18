// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:role_based_app/distributor/screens/distributorsUI.dart';
// import '../../authpage/pages/auth_services.dart';
// import '../../constants/colors.dart';
// //import '../../dashboard/dashboard_page.dart';

// class CategoryPage extends StatefulWidget {
//   const CategoryPage({super.key});

//   @override
//   State<CategoryPage> createState() => _CategoryPageState();
// }

// class _CategoryPageState extends State<CategoryPage> {
//   final dio = Dio(BaseOptions(baseUrl: "https://frontman-backend-2.onrender.com/"));

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController descController = TextEditingController();
//   final TextEditingController idController = TextEditingController();

//   List<dynamic> categories = [];
//   bool loading = false;
//   String? message;

//   Future<String?> _getToken() async {
//     final authService = AuthService();
//     return await authService.getToken();
//   }

//   // ✅ Get all categories
//   Future<void> getCategories() async {
//     setState(() {
//       loading = true;
//       message = null;
//     });
//     try {
//       final token = await _getToken();
//       final response = await dio.get(
//         "/distributor/categories",
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );

//       final data = response.data is List ? response.data : response.data["data"];
//       setState(() {
//         categories = data ?? [];
//         message = "✅ Categories fetched successfully";
//       });
//     } on DioError catch (e) {
//       setState(() => message = "❌ API Error: ${e.response?.data ?? e.message}");
//     } catch (e) {
//       setState(() => message = "❌ Error: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   // ✅ Create new category
//   Future<void> createCategory() async {
//     if (nameController.text.isEmpty) {
//       setState(() => message = "⚠️ Enter category name");
//       return;
//     }
//     setState(() {
//       loading = true;
//       message = null;
//     });
//     try {
//       final token = await _getToken();
//       final response = await dio.post(
//         "/distributor/categories",
//         data: {
//           "name": nameController.text,
//           "description": descController.text,
//         },
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );
//       setState(() => message = "✅ Created: ${response.data}");
//       await getCategories();
//     } on DioError catch (e) {
//       setState(() => message = "❌ API Error: ${e.response?.data ?? e.message}");
//     } catch (e) {
//       setState(() => message = "❌ Error: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   // ✅ Update category
//   Future<void> updateCategory() async {
//     if (idController.text.isEmpty) {
//       setState(() => message = "⚠️ Enter Category ID to update");
//       return;
//     }
//     setState(() {
//       loading = true;
//       message = null;
//     });
//     try {
//       final token = await _getToken();
//       final response = await dio.put(
//         "/distributor/categories/${idController.text}",
//         data: {
//           "name": nameController.text,
//           "description": descController.text,
//         },
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );
//       setState(() => message = "✏️ Updated: ${response.data}");
//       await getCategories();
//     } on DioError catch (e) {
//       setState(() => message = "❌ API Error: ${e.response?.data ?? e.message}");
//     } catch (e) {
//       setState(() => message = "❌ Error: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   // ✅ Delete category
//   Future<void> deleteCategory() async {
//     if (idController.text.isEmpty) {
//       setState(() => message = "⚠️ Enter Category ID to delete");
//       return;
//     }
//     setState(() {
//       loading = true;
//       message = null;
//     });
//     try {
//       final token = await _getToken();
//       final response = await dio.delete(
//         "/distributor/categories/${idController.text}",
//         options: Options(headers: {"Authorization": "Bearer $token"}),
//       );
//       setState(() => message = "🗑️ Deleted: ${response.data}");
//       await getCategories();
//     } on DioError catch (e) {
//       setState(() => message = "❌ API Error: ${e.response?.data ?? e.message}");
//     } catch (e) {
//       setState(() => message = "❌ Error: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   Widget _buildActionCard({required String title, required List<Widget> children}) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 3,
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title,
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     getCategories();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: const Text("Manage Categories",
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.home, size: 26),
//             tooltip: "Back to Dashboard",
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const DistributorHomePage()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _buildActionCard(
//               title: "Category Form",
//               children: [
//                 TextField(
//                   controller: idController,
//                   decoration: const InputDecoration(
//                     labelText: "Category ID (for update/delete)",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: nameController,
//                   decoration: const InputDecoration(
//                     labelText: "Category Name",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: descController,
//                   decoration: const InputDecoration(
//                     labelText: "Description",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Wrap(
//                   spacing: 12,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: loading ? null : createCategory,
//                       icon: const Icon(Icons.add),
//                       label: const Text("Create"),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: loading ? null : updateCategory,
//                       icon: const Icon(Icons.edit),
//                       label: const Text("Update"),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: loading ? null : deleteCategory,
//                       icon: const Icon(Icons.delete),
//                       label: const Text("Delete"),
//                     ),
//                   ],
//                 ),
//               ],
//             ),

//             ElevatedButton.icon(
//               onPressed: loading ? null : getCategories,
//               icon: const Icon(Icons.refresh),
//               label: const Text("Refresh Categories"),
//             ),
//             const SizedBox(height: 20),

//             if (loading) const CircularProgressIndicator(),

//             if (message != null) Card(
//               color: message!.startsWith("✅") || message!.startsWith("✏️") || message!.startsWith("🗑️")
//                   ? Colors.green[50]
//                   : Colors.red[50],
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Text(
//                   message!,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: message!.startsWith("✅") || message!.startsWith("✏️") || message!.startsWith("🗑️")
//                         ? Colors.green
//                         : Colors.red,
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 12),
//             Expanded(
//               child: ListView.separated(
//                 itemCount: categories.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 12),
//                 itemBuilder: (context, index) {
//                   final cat = categories[index];
//                   return Card(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     elevation: 2,
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: AppColors.primary.withOpacity(0.2),
//                         child: Text((cat["name"] ?? "N")[0].toUpperCase()),
//                       ),
//                       title: Text(cat["name"] ?? "Unnamed"),
//                       subtitle: Text(cat["description"] ?? "No description"),
//                       trailing: Text(
//                         "🛒 ${cat["_count"]?["products"] ?? 0} products",
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:role_based_app/distributor/screens/distributorsUI.dart';
import '../../authpage/pages/auth_services.dart';
import '../../constants/colors.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final dio = Dio(BaseOptions(baseUrl: "https://frontman-backend-2.onrender.com/"));

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  List<dynamic> categories = [];
  bool loading = false;
  String? message;

  Future<String?> _getToken() async {
    final authService = AuthService();
    return await authService.getToken();
  }

  // ✅ Get all categories
  Future<void> getCategories() async {
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final token = await _getToken();
      final response = await dio.get(
        "/distributor/categories",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      final data = response.data is List ? response.data : response.data["data"];
      setState(() {
        categories = data ?? [];
        message = "✅ Categories fetched successfully";
      });
    } on DioError catch (e) {
      setState(() => message = "❌ API Error: ${e.response?.data ?? e.message}");
    } catch (e) {
      setState(() => message = "❌ Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  // ✅ Create new category
  Future<void> createCategory() async {
    if (nameController.text.isEmpty) {
      setState(() => message = "⚠️ Enter category name");
      return;
    }
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final token = await _getToken();
      final response = await dio.post(
        "/distributor/categories",
        data: {
          "name": nameController.text,
          "description": descController.text,
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      setState(() => message = "✅ Created: ${response.data}");
      await getCategories();
    } on DioError catch (e) {
      setState(() => message = "❌ API Error: ${e.response?.data ?? e.message}");
    } catch (e) {
      setState(() => message = "❌ Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  // ✅ Update category
  Future<void> updateCategory() async {
    if (idController.text.isEmpty) {
      setState(() => message = "⚠️ Enter Category ID to update");
      return;
    }
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final token = await _getToken();
      final response = await dio.put(
        "/distributor/categories/${idController.text}",
        data: {
          "name": nameController.text,
          "description": descController.text,
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      setState(() => message = "✏️ Updated: ${response.data}");
      await getCategories();
    } on DioError catch (e) {
      setState(() => message = "❌ API Error: ${e.response?.data ?? e.message}");
    } catch (e) {
      setState(() => message = "❌ Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  // ✅ Delete category
  Future<void> deleteCategory() async {
    if (idController.text.isEmpty) {
      setState(() => message = "⚠️ Enter Category ID to delete");
      return;
    }
    setState(() {
      loading = true;
      message = null;
    });
    try {
      final token = await _getToken();
      final response = await dio.delete(
        "/distributor/categories/${idController.text}",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      setState(() => message = "🗑️ Deleted: ${response.data}");
      await getCategories();
    } on DioError catch (e) {
      setState(() => message = "❌ API Error: ${e.response?.data ?? e.message}");
    } catch (e) {
      setState(() => message = "❌ Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Widget _buildActionCard({required String title, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Manage Categories",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, size: 26),
            tooltip: "Back to Dashboard",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DistributorHomePage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(   // ✅ whole page scrollable
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildActionCard(
              title: "Category Form",
              children: [
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: "Category ID (for update/delete)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Category Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12, // ✅ spacing between rows
                  children: [
                    ElevatedButton.icon(
                      onPressed: loading ? null : createCategory,
                      icon: const Icon(Icons.add),
                      label: const Text("Create"),
                    ),
                    ElevatedButton.icon(
                      onPressed: loading ? null : updateCategory,
                      icon: const Icon(Icons.edit),
                      label: const Text("Update"),
                    ),
                    ElevatedButton.icon(
                      onPressed: loading ? null : deleteCategory,
                      icon: const Icon(Icons.delete),
                      label: const Text("Delete"),
                    ),
                  ],
                ),
              ],
            ),

            ElevatedButton.icon(
              onPressed: loading ? null : getCategories,
              icon: const Icon(Icons.refresh),
              label: const Text("Refresh Categories"),
            ),
            const SizedBox(height: 20),

            if (loading) const Center(child: CircularProgressIndicator()),

            if (message != null) Card(
              color: message!.startsWith("✅") || message!.startsWith("✏️") || message!.startsWith("🗑️")
                  ? Colors.green[50]
                  : Colors.red[50],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  message!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: message!.startsWith("✅") || message!.startsWith("✏️") || message!.startsWith("🗑️")
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ✅ Categories list scrolls with page
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final cat = categories[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: Text((cat["name"] ?? "N")[0].toUpperCase()),
                    ),
                    title: Text(cat["name"] ?? "Unnamed"),
                    subtitle: Text(cat["description"] ?? "No description"),
                    trailing: Text(
                      "🛒 ${cat["_count"]?["products"] ?? 0} products",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}



