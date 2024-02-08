import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:together/utils/global.colors.dart';
import 'package:together/view/login/login.view.dart';
import 'package:together/view/verifyemail/VerifyEmail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

class SignUp extends StatefulWidget {

  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final mobilenoController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  XFile? file;
  final ImagePicker imagePicker = ImagePicker();

  bool Obsure = true;
  bool obsure = true;

  var mobileno = "";
  var fullname = "";
  var email = "";
  var password = "";
  var confirm = "";
  var downloadUrlImage = "";
  var uid = "";


  CollectionReference students =
      FirebaseFirestore.instance.collection('students');



  Future<void> addUser() {
    return students
        .add({
          'fullname': fullname,
          'email': email,
          'mobileno': mobileno,
          'password': password,
      'profilepic' : downloadUrlImage,
      'uid' : uid,
        })
        .then((value) => print('User added'))
        .catchError((error) => print('Failed to add user: $error'));
  }
  getImage() async {
    file=await imagePicker.pickImage(source: ImageSource.gallery,imageQuality: 25);
    setState(() {
      file;
    });
  }


  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    mobilenoController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /*Section 1*/

                Text(
                  "Get on Board",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
                ),
                Text(
                  "Create your Profile to start Your Journey.",
                  style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  )),
                ),
                /*end*/
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 100,right: 100,bottom: 10),
                  child: GestureDetector(
                    child: CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.white,
                      backgroundImage: file == null ? null : FileImage(File(file!.path)),
                      child: file == null ? Lottie.asset("assets/propic.json",height: 200):null,
                    ),
                    onTap: (){
                      getImage();
                    },
                  ),
                ),
                Text("Add Photo"),


                /*Section 2*/
                Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_outline_outlined,
                              color: GlobalColors.textColor,
                            ),
                            labelText: "Full Name",
                            hintText: "Full Name",
                            border: const OutlineInputBorder(),
                            labelStyle:
                                TextStyle(color: GlobalColors.textColor),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: GlobalColors.textColor,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Full name';
                            }
                            return null;
                          },
                          controller: fullnameController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.alternate_email,
                              color: GlobalColors.textColor,
                            ),
                            labelText: "Email ID",
                            hintText: "Email ID",
                            border: const OutlineInputBorder(),
                            labelStyle:
                                TextStyle(color: GlobalColors.textColor),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: GlobalColors.textColor,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email Id';
                            } else if (!value.contains('@')) {
                              return 'Please Enter Valid Email Id';
                            }
                            return null;
                          },
                          controller: emailController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.call,
                              color: GlobalColors.textColor,
                            ),
                            labelText: "Mobile No",
                            hintText: "Mobile No",
                            border: const OutlineInputBorder(),
                            labelStyle:
                                TextStyle(color: GlobalColors.textColor),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: GlobalColors.textColor,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Mobile Number';
                            } else if (value.length == 10) {
                              return null;
                            } else {
                              return 'Enter a valid Mobile Number';
                            }
                          },
                          keyboardType: TextInputType.phone,
                          controller: mobilenoController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              color: GlobalColors.textColor,
                            ),
                            labelText: "Password",
                            hintText: "Password",
                            border: const OutlineInputBorder(),
                            labelStyle:
                                TextStyle(color: GlobalColors.textColor),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: GlobalColors.textColor,
                              ),
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    Obsure = !Obsure;
                                  });
                                },
                                icon: Icon(Obsure
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                          obscureText: Obsure,
                          controller: passwordController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              color: GlobalColors.textColor,
                            ),
                            labelText: "Confirm Password",
                            hintText: "Confirm Password",
                            border: const OutlineInputBorder(),
                            labelStyle:
                                TextStyle(color: GlobalColors.textColor),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: GlobalColors.textColor,
                              ),
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obsure = !obsure;
                                  });
                                },
                                icon: Icon(obsure
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Confirm Password';
                            } else if (value != passwordController.text) {
                              return "Password Don't Match";
                            }
                            return null;
                          },
                          obscureText: obsure,
                          controller: confirmController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: (() {
                                /*Login Button Pressed*/
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    fullname = fullnameController.text;
                                    email = emailController.text;
                                    mobileno = mobilenoController.text;
                                    password = passwordController.text;
                                    confirm = confirmController.text;
                                    file == null ?
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(content: Text("Please Select an Image"))) : SignUp();
                                  }
                                  );
                                }
                              }),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: GlobalColors.mainColor),
                              child: Text(
                                "Login".toUpperCase(),
                              )),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Get.to(const LoginView());
                            },
                            // ignore: prefer_const_constructors
                            child: Text.rich(TextSpan(
                                text: "Already have an account ",
                                style: const TextStyle(color: Colors.black),
                                children: const [
                                  TextSpan(
                                      text: "Login ",
                                      style: TextStyle(color: Colors.blue))
                                ])),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future SignUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      uid = FirebaseAuth.instance.currentUser!.uid;
      Get.to(VerifyEmailPage());
      UploadImage();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void clearText() {
    fullnameController.clear();
    emailController.clear();
    mobilenoController.clear();
    passwordController.clear();
    confirmController.clear();
    if(file != null){
      file=null;
    }
  }

  Future<void> UploadImage() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    fStorage.Reference storageRef = fStorage.FirebaseStorage.instance.ref().child("profiles").child(fileName);
    fStorage.UploadTask uploadTask = storageRef.putFile(File(file!.path));
      await uploadTask.whenComplete(() async {
      downloadUrlImage = await uploadTask.snapshot.ref.getDownloadURL();
      addUser();
      clearText();
    });

  }
}



