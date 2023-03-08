// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:juconfession/provider/theme_provider.dart';
import 'package:juconfession/services/firestore.methods.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class AddConfession extends StatefulWidget {
  const AddConfession({super.key});

  @override
  State<AddConfession> createState() => _AddConfessionState();
}

class _AddConfessionState extends State<AddConfession> {
  TextEditingController confessionController = TextEditingController();
  bool isLoading = false;
  List gender = ['Male', 'Female', 'Other'];
  String? selectedGender;
  String? selectedFaculty;
  String? selectedDepartment;
  String? selectedYear;
  Uint8List? _image;
  List faculty = ['Engineering', 'Science', 'Arts', 'Other'];
  List year = ['1st', '2nd', '3rd', '4th', 'other'];
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

  Map<String, dynamic> submitConfession = {
    'id': '0',
    'confession': "",
    'image': "",
    'gender': "",
    'faculty': "",
    'department': "",
    'year': "",
  };

  List otherDepartment = ['Law', 'Medicine', 'Pharmacy', 'Nursing', 'Other'];

  _selectImages(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select Image'),
      children: [
        SimpleDialogOption(
          child: const Text('Take a picture'),
          onPressed: () async {
            Navigator.pop(context);

            Uint8List? image = await pickImage(ImageSource.camera);

            if (image != null) {
              setState(() {
                _image = image;
              });
            }
          },
        ),
        SimpleDialogOption(
          child: const Text('Select from gallery'),
          onPressed: () async {
            Uint8List? image = await pickImage(ImageSource.gallery);
            if (image != null) {
              setState(() {
                _image = image;
              });
            } else {
              showSnackBar('No image selected', context);
            }
          },
        ),
        SimpleDialogOption(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  resetFields() {
    setState(() {
      confessionController.clear();
      selectedGender = null;
      selectedFaculty = null;
      selectedDepartment = null;
      selectedYear = null;
      _image = null;
    });
  }

  @override
  void dispose() {
    confessionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Confess anonymously',
              style: TextStyle(
                color: theme.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                try {
                  if (confessionController.text.isEmpty &&
                      selectedDepartment!.isNotEmpty &&
                      selectedFaculty!.isNotEmpty &&
                      selectedGender!.isNotEmpty &&
                      selectedYear!.isNotEmpty) {
                    setState(() {
                      isLoading = false;
                    });
                    showSnackBar("Fill All the Information", context);
                    return;
                  }

                  String rev = await FirestoreMethods().uploadConfess(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                    confession: confessionController.text,
                    department: selectedDepartment!,
                    gender: selectedGender!,
                    faculty: selectedFaculty!,
                    year: selectedYear!,
                    image: _image,
                  );

                  if (rev == "success") {
                    resetFields();
                    setState(() {
                      isLoading = false;
                    });
                    showSnackBar("Confession Posted", context);
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    showSnackBar(rev, context);
                  }
                } catch (e) {
                  setState(() {
                    isLoading = false;
                  });
                  showSnackBar(e.toString(), context);
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
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
              isLoading
                  ? const LinearProgressIndicator(
                      backgroundColor: Colors.purple,
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    // borderRadius: BorderRadius.circular(0),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    controller: confessionController,
                    minLines: 5,
                    maxLines: 40,
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
              const SizedBox(
                height: 10,
              ),

              //drop down menu to choose between gender
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DropdownButtonFormField(
                    value: selectedGender,
                    icon: const Icon(Icons.arrow_drop_down_circle),
                    hint: const Text("Your gender"),
                    items: gender
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value.toString();
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DropdownButtonFormField(
                    value: selectedFaculty,
                    icon: const Icon(Icons.arrow_drop_down_circle),
                    hint: const Text("Faculty"),
                    items: faculty
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedFaculty = value.toString();
                      });
                    }),
              ),
              if (selectedFaculty != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropdownButtonFormField(
                      value: selectedFaculty == faculty[0]
                          ? selectedDepartment = engineeringDepartment[0]
                          : selectedFaculty == faculty[1]
                              ? selectedDepartment = scienceDepartment[0]
                              : selectedFaculty == faculty[2]
                                  ? selectedDepartment = artsDepartment[0]
                                  : selectedDepartment = otherDepartment[0],
                      icon: const Icon(Icons.arrow_drop_down_circle),
                      hint: const Text("Department"),
                      items: selectedFaculty == faculty[0]
                          ? engineeringDepartment
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList()
                          : selectedFaculty == faculty[1]
                              ? scienceDepartment
                                  .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e)))
                                  .toList()
                              : selectedFaculty == faculty[2]
                                  ? artsDepartment
                                      .map((e) => DropdownMenuItem(
                                          value: e, child: Text(e)))
                                      .toList()
                                  : otherDepartment
                                      .map((e) => DropdownMenuItem(
                                          value: e, child: Text(e)))
                                      .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDepartment = value.toString();
                        });
                      }),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DropdownButtonFormField(
                    value: selectedYear,
                    icon: const Icon(Icons.arrow_drop_down_circle),
                    hint: const Text("Year"),
                    items: year
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value.toString();
                      });
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
              //image picker
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _image == null
                      ? Center(
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => _selectImages(context));
                            },
                            child: const Text(
                              'Add Image (Optional)',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Stack(
                          children: [
                            Image.memory(
                              _image!,
                              fit: BoxFit.fitHeight,
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ));
  }
}
