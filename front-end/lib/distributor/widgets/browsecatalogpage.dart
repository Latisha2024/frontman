// // // category_page.dart
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import '../../authpage/pages/auth_services.dart';
// import '../../constants/colors.dart';

// class CategoryPage extends StatefulWidget {
//   const CategoryPage({super.key});

//   @override
//   State<CategoryPage> createState() => _CategoryPageState();
// }

// class _CategoryPageState extends State<CategoryPage> {
//   final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5000"));

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
//       setState(() {
//         categories = response.data;
//         message = "✅ Categories fetched successfully";
//       });
//     } catch (e) {
//       setState(() => message = "❌ Error: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   // ✅ Create new category
//   Future<void> createCategory() async {
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
//     } catch (e) {
//       setState(() => message = "❌ Error: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   // ✅ Update category
//   Future<void> updateCategory() async {
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
//     } catch (e) {
//       setState(() => message = "❌ Error: $e");
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   // ✅ Delete category
//   Future<void> deleteCategory() async {
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
//     } catch (e) {
//       setState(() => message = "❌ Error: $e");
//     } finally {
//       setState(() => loading = false);
//     }
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
//         title: const Text("Manage Categories"),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Form inputs
//             TextField(
//               controller: idController,
//               decoration: const InputDecoration(labelText: "Category ID (for update/delete)"),
//             ),
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: "Category Name"),
//             ),
//             TextField(
//               controller: descController,
//               decoration: const InputDecoration(labelText: "Description"),
//             ),
//             const SizedBox(height: 10),

//             // Action buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton(
//                   onPressed: loading ? null : createCategory,
//                   child: const Text("➕ Create"),
//                 ),
//                 ElevatedButton(
//                   onPressed: loading ? null : updateCategory,
//                   child: const Text("✏️ Update"),
//                 ),
//                 ElevatedButton(
//                   onPressed: loading ? null : deleteCategory,
//                   child: const Text("🗑️ Delete"),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: loading ? null : getCategories,
//               child: const Text("📋 Refresh Categories"),
//             ),
//             const SizedBox(height: 20),

//             if (loading) const CircularProgressIndicator(),
//             if (message != null) Text(message!),

//             // List of categories
//             Expanded(
//               child: ListView.separated(
//                 itemCount: categories.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 12),
//                 itemBuilder: (context, index) {
//                   final cat = categories[index];
//                   return Card(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     elevation: 3,
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: AppColors.primary.withOpacity(0.2),
//                         child: Text(cat["name"].toString()[0].toUpperCase()),
//                       ),
//                       title: Text(cat["name"] ?? "Unnamed"),
//                       subtitle: Text(cat["description"] ?? "No description"),
//                       trailing: Text("🛒 ${cat["_count"]?["products"] ?? 0} products"),
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

      // check if wrapped in {data: [...]}
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
        title: const Text("Manage Categories"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Form inputs
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: "Category ID (for update/delete)"),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Category Name"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 10),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: loading ? null : createCategory,
                  child: const Text("➕ Create"),
                ),
                ElevatedButton(
                  onPressed: loading ? null : updateCategory,
                  child: const Text("✏️ Update"),
                ),
                ElevatedButton(
                  onPressed: loading ? null : deleteCategory,
                  child: const Text("🗑️ Delete"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: loading ? null : getCategories,
              child: const Text("📋 Refresh Categories"),
            ),
            const SizedBox(height: 20),

            if (loading) const CircularProgressIndicator(),
            if (message != null) Text(message!, style: const TextStyle(fontWeight: FontWeight.bold)),

            // List of categories
            Expanded(
              child: ListView.separated(
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        child: Text((cat["name"] ?? "N")[0].toUpperCase()),
                      ),
                      title: Text(cat["name"] ?? "Unnamed"),
                      subtitle: Text(cat["description"] ?? "No description"),
                      trailing: Text("🛒 ${cat["_count"]?["products"] ?? 0} products"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

