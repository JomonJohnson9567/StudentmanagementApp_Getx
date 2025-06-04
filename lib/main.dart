import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentmanagement_getx/controller/controller.dart';
import 'package:studentmanagement_getx/db_functions/functions_db.dart';
import 'package:studentmanagement_getx/screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StudentController());

    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "STUDENT MANAGEMENT",
      home: HomePage(),
    );
  }
}
