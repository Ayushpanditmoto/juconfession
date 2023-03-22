// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:juconfession/services/auth.firebase.dart';
import 'package:juconfession/utils/route.dart';
import 'package:juconfession/utils/utils.dart';

import '../components/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  bool isLogin = false;
  bool isImageUploaded = false;
  File? _image;
  bool isChecked = false;

  List gender = ['Male', 'Female', 'Other'];
  String? selectedGender;
  String? selectedFaculty;
  String? selectedDepartment;
  String? selectedStartYear;
  String? selectedEndYear;

  List faculty = ['Engineering', 'Science', 'Arts', 'Other'];
  List year = [
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
  ];
  List engineeringDepartment = [
    'CSE',
    'IT',
    'ETCE',
    'IEE',
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

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 94, 255),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //svg image
                // SvgPicture.asset(
                //   'assets/signup.svg',
                //   height: 250,
                // ),
                const SizedBox(height: 10),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                MemoryImage(_image!.readAsBytesSync()),
                            backgroundColor: Colors.transparent,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: 'https://i.stack.imgur.com/l60Hf.png',
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    )
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(children: [
                    TextEnterArea(
                        hintText: 'Enter Your Name',
                        controller: nameController,
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        }),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          dropdownColor: Colors.white,
                          style: const TextStyle(color: Colors.black),
                          value: selectedGender,
                          icon: const Icon(Icons.arrow_drop_down_circle,
                              color: Colors.black),
                          hint: const Text("Select Your gender",
                              style: TextStyle(color: Colors.black)),
                          items: gender
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value.toString();
                            });
                          }),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          onTap: () {
                            setState(() {
                              selectedDepartment = null;
                            });
                          },
                          dropdownColor: Colors.white,
                          value: selectedFaculty,
                          style: const TextStyle(color: Colors.black),
                          icon: const Icon(Icons.arrow_drop_down_circle,
                              color: Colors.black),
                          hint: const Text("Select Faculty",
                              style: TextStyle(color: Colors.black)),
                          items: faculty
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedFaculty = value.toString();
                            });
                          }),
                    ),
                    if (selectedFaculty != null) const SizedBox(height: 5),
                    if (selectedFaculty != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            value: selectedDepartment,
                            dropdownColor: Colors.white,
                            style: const TextStyle(color: Colors.black),
                            icon: const Icon(Icons.arrow_drop_down_circle,
                                color: Colors.black),
                            hint: const Text("Select Department",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0))),
                            items: selectedFaculty == faculty[0]
                                ? engineeringDepartment
                                    .map((e) => DropdownMenuItem(
                                        value: e, child: Text(e)))
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
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          value: selectedStartYear,
                          dropdownColor: Colors.white,
                          icon: const Icon(Icons.arrow_drop_down_circle,
                              color: Colors.black),
                          hint: const Text(
                            "Select Starting Year",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                          items: year
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedStartYear = value.toString();
                            });
                          }),
                    ),
                    const SizedBox(height: 5),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: Colors.black),
                          value: selectedEndYear,
                          icon: const Icon(Icons.arrow_drop_down_circle,
                              color: Colors.black),
                          hint: const Text(
                            "Select Ending Year",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          dropdownColor: Colors.white,
                          items: year
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedEndYear = value.toString();
                            });
                          }),
                    ),

                    TextEnterArea(
                        hintText: 'Enter Your Email',
                        controller: emailController,
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (p0) {
                          //end line should contain @gmail.com

                          if (p0!.isEmpty) {
                            return 'Please enter your email';
                          } else if (!p0.contains('@gmail.com')) {
                            return 'Please enter a valid gmail account';
                          }
                          return null;
                        }),
// password text field
                    TextEnterArea(
                        hintText: 'Enter Your Password',
                        controller: passwordController,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: false,
                        textInputAction: TextInputAction.done,
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        }),
                  ]),
                ),

                const SizedBox(height: 10),
                //check box for terms and condition
                Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        const Text(
                          'I agree to the ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const TermsAndCondition()));
                          },
                          child: const Text(
                            'Terms and Conditions',
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        //and privacy policy
                        const Text(
                          ' and ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const PrivacyPolicy()));
                      },
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                //Bullet point
                Column(
                  children: const [
                    Text(
                      '• You must be a student of the Jadavpur University',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: !isChecked
                      ? null
                      : () async {
                          try {
                            if (_formKey.currentState!.validate() == false) {
                              return;
                            }

                            if (_image == null) {
                              return showSnackBar(
                                  'Please select an image', context);
                            }
                            setState(() {
                              isLogin = true;
                            });
                            String result = await AuthMethod().signUpUser(
                              email: emailController.text,
                              password: passwordController.text,
                              name: nameController.text,
                              image: File(_image!.path).readAsBytesSync(),
                              gender: selectedGender!,
                              department: selectedDepartment!,
                              faculty: selectedFaculty!,
                              startYear: selectedStartYear!,
                              endYear: selectedEndYear!,
                            );

                            setState(() {
                              isLogin = false;
                            });

                            showSnackBar(result, context);
                            if (result == 'Verification Email Sent') {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  RoutePath.verifyEmail, (route) => false);
                            }
                          } catch (e) {
                            setState(() {
                              isLogin = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please Fill All The Fields'),
                              ),
                            );
                          }

                          // Navigator.pushNamed(context, RoutePath.confess);
                        },
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Colors.grey,
                    disabledForegroundColor: Colors.black,
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    minimumSize: const Size(160, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLogin
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
