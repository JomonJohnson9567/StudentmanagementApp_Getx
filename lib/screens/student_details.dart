// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:studentmanagement_getx/controller/controller.dart';
import 'package:studentmanagement_getx/model/model.dart';
import 'package:studentmanagement_getx/widgets/appbar_widget.dart';

final StudentController studentController = Get.put(StudentController());

class Details extends StatelessWidget {
  final StudentModel student;

  const Details({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppbarWidget(
          title: 'Details',
          backgroundColor: const Color.fromARGB(255, 231, 63, 12),
        ),
      ),
      body: Center(
        child: Container(
          height: 400,
          width: 350,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 239, 137, 54),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                CircleAvatar(
                  backgroundImage: FileImage(File(student.imageurl.toString())),
                  radius: 60,
                ),
                const SizedBox(height: 30),
                Text(
                  student.name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Department: ${student.department}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Roll No: ${student.rollno}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 12),
                Text(
                  'Mobile: ${student.phoneno}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
