// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class AddConfession extends StatelessWidget {
  AddConfession({super.key});

  List gender = ['Male', 'Female', 'Other'];
  List faculty = ['Engineering', 'Science', 'Arts', 'Other'];
  List engineeringDepartment = [
    'CSE',
    'IT',
    'ETCE',
    'IEE'
        'EE',
    'ME',
    'Civil',
    'MME',
    'FTBE',
    'Printing',
    'Chemical',
    'Construction',
    'Power',
    'Production',
    'Other Engineering'
  ];
  List scienceDepartment = [
    'Physics',
    'Chemistry',
    'Mathematics',
    'Statistics',
    'Botany',
    'Zoology',
    'Microbiology',
    'Biochemistry',
    'Biotechnology',
    'Other Science'
  ];
  List artsDepartment = [
    'Bangla',
    'English',
    'History',
    'Economics',
    'Political Science',
    'Sociology',
    'Philosophy',
    'Islamic Studies',
    'Other Arts'
  ];
  List otherDepartment = ['Law', 'Medicine', 'Pharmacy', 'Nursing', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Confession'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text(
                'Post',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    // borderRadius: BorderRadius.circular(0),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: TextFormField(
                    maxLines: 10,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write your confession?',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Add Image (optional) [Size: 1MB]',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.add_a_photo,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 45,
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Your Department',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
