// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentmanagement_getx/constants/constants.dart';
import 'package:studentmanagement_getx/controller/controller.dart';
import 'package:studentmanagement_getx/db_functions/functions_db.dart';
import 'package:studentmanagement_getx/model/model.dart';
import 'package:studentmanagement_getx/screens/add_student.dart';
import 'package:studentmanagement_getx/screens/search.dart';
import 'package:studentmanagement_getx/screens/student_details.dart';

final StudentController studentController = Get.put(StudentController());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _fetchStudentsData();
  }

  Future<void> _fetchStudentsData() async {
    final students = await getAllStudents();
    studentController.students.value = students; // Fetch and set data
  }

  Future<void> _showEditDialog(int index) async {
    final student = studentController.students[index];
    final TextEditingController nameController = TextEditingController(
      text: student.name,
    );
    final TextEditingController rollnoController = TextEditingController(
      text: student.rollno.toString(),
    );
    final TextEditingController departmentController = TextEditingController(
      text: student.department,
    );
    final TextEditingController phonenoController = TextEditingController(
      text: student.phoneno.toString(),
    );
    final TextEditingController ageController = TextEditingController(
      text: student.age.toString(),
    );

    showDialog(
      context: context,
      builder:
          (BuildContext contex) => AlertDialog(
            title: Text("Edit Student"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Name"),
                  ),
                  TextFormField(
                    controller: rollnoController,
                    decoration: InputDecoration(labelText: "Roll No"),
                  ),
                  TextFormField(
                    controller: departmentController,
                    decoration: InputDecoration(labelText: "Department"),
                  ),
                  TextFormField(
                    controller: phonenoController,
                    decoration: InputDecoration(labelText: "Phone No"),
                  ),
                  TextFormField(
                    controller: ageController,
                    decoration: InputDecoration(labelText: " Age"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  await updateStudent(
                    StudentModel(
                      id: student.id,
                      rollno: rollnoController.text,
                      name: nameController.text,
                      department: departmentController.text,
                      phoneno: phonenoController.text,
                      age: ageController.text,
                      imageurl: student.imageurl,
                    ),
                  );
                  Navigator.of(context).pop();
                  _fetchStudentsData(); // Refresh the list
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("Changes Updated"),
                    ),
                  );
                },
                child: Text("Save"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {
                Get.to(const SearchPage());
              },
              icon: const Icon(Icons.search, color: kwhite),
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Logout"),
                    content: Text('Are you sure want to Logout'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          exit(0);
                        },
                        child: Text("logout"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.logout, color: kwhite),
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 237, 103, 13),
        title: Center(
          child: Text(
            "STUDENT LIST",
            style: TextStyle(color: kwhite, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: Obx(
        () =>
            studentController.students.isEmpty
                ? Center(
                  child: Text(
                    "No students available.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final student = studentController.students[index];
                    final id = student.id;
                    final imageUrl = student.imageurl;
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        onTap: () {
                          Get.to(() => Details(student: student));
                        },
                        leading: GestureDetector(
                          onTap: () {
                            if (imageUrl != null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.file(
                                            File(imageUrl),
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.purple[100],
                            backgroundImage:
                                imageUrl != null
                                    ? FileImage(File(imageUrl))
                                    : null,
                            child:
                                imageUrl == null
                                    ? Icon(
                                      Icons.person,
                                      size: 32,
                                      color: Colors.purple,
                                    )
                                    : null,
                          ),
                        ),
                        title: Text(
                          student.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.purple[900],
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text(
                              student.department,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Roll No: ${student.rollno}",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: "Edit",
                              onPressed: () {
                                _showEditDialog(index);
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                            IconButton(
                              tooltip: "Delete",
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (BuildContext context) => AlertDialog(
                                        title: Text("Delete Student"),
                                        content: Text(
                                          "Are you sure you want to delete?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await deleteStudent(id!);
                                              _fetchStudentsData();
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Text(
                                                    "Deleted Successfully",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "Ok",
                                              style: TextStyle(
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 12);
                  },
                  itemCount: studentController.students.length,
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddStudent());
          // Navigator.of(
          //   context,
          // ).push(MaterialPageRoute(builder: (context) => AddStudent()));
        },
        backgroundColor: kbalck,
        child: Icon(Icons.add, color: kwhite, size: 45),
      ),
    );
  }
}
