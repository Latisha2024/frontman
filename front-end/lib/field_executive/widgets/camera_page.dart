// import 'package:flutter/material.dart';
// import '../../constants/colors.dart';

// class CameraPage extends StatefulWidget {
//   const CameraPage({super.key});

//   @override
//   State<CameraPage> createState() => _CameraPageState();
// }

// class _CameraPageState extends State<CameraPage> {
//   String? capturedImagePath;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Camera"),
//         backgroundColor: AppColors.primaryBlue,
//         foregroundColor: Colors.white,
//       ),
//       body: Container(
//         color: Colors.grey.shade100,
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text(
//               "Capture Photo with GPS",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             Container(
//               height: 220,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.grey),
//               ),
//               child: Center(
//                 child: capturedImagePath == null
//                     ? const Text("No image captured")
//                     : Image.asset(capturedImagePath!, fit: BoxFit.cover),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: () {
//                 // TODO: Integrate camera functionality here
//                 // You could use image_picker or camera plugin
//                 setState(() {
//                   capturedImagePath = "assets/sample_photo.jpg"; // Placeholder path
//                 });
//               },
//               icon: const Icon(Icons.camera_alt),
//               label: const Text("Capture Photo"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryBlue,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: () {
//                 // TODO: Integrate GPS and upload/send logic
//               },
//               icon: const Icon(Icons.send),
//               label: const Text("Send with GPS"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green.shade700,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../authpage/pages/auth_services.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5001"));
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  bool loading = false;
  String? message;

  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _image = picked);
    }
  }

  Future<void> uploadImage() async {
    if (_image == null) {
      setState(() => message = "⚠️ Please capture an image first!");
      return;
    }

    setState(() {
      loading = true;
      message = null;
    });

    try {
      final authService = AuthService();
      final token = await authService.getToken();

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(_image!.path),
        'latitude': latitudeController.text.trim(),
        'longitude': longitudeController.text.trim(),
        'description': descriptionController.text.trim(),
      });

      final response = await dio.post(
        '/fieldExecutive/camera/upload',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data'
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() => message = "✅ Image uploaded successfully!");
      } else {
        setState(() => message = "⚠️ Upload failed (${response.statusCode})");
      }
    } catch (e) {
      setState(() => message = "❌ Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Camera Upload")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _image != null
                ? Image.file(File(_image!.path), height: 200)
                : const Icon(Icons.camera_alt, size: 120, color: Colors.grey),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera),
              label: const Text("Capture Image"),
              onPressed: pickImage,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: latitudeController,
              decoration: const InputDecoration(labelText: "Latitude"),
            ),
            TextField(
              controller: longitudeController,
              decoration: const InputDecoration(labelText: "Longitude"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : uploadImage,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Upload"),
            ),
            if (message != null) ...[
              const SizedBox(height: 20),
              Text(
                message!,
                style: TextStyle(
                    color: message!.contains("✅") ? Colors.green : Colors.red),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
