import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:together/utils/global.colors.dart';

class ShowProfile extends StatefulWidget {
  const ShowProfile({Key? key}) : super(key: key);

  @override
  State<ShowProfile> createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile> {
  final formKey = GlobalKey<FormState>();
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final mobilenoController = TextEditingController();
  var fullname = '';
  var profilepic = '';
  var email = '';
  var uid = '';
  var mobileno= '';
  bool obsure = false;
  dynamic Argument = Get.arguments ;
  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    mobilenoController.dispose();
    super.dispose();
  }

  Future<void> getUser() async {
    final user = Argument[0]['uid'];
    print(user);
    final QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('students').where('uid', isEqualTo: user).get();
    if(querySnapshot.docs.isNotEmpty){
      final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      final data = documentSnapshot.data() as Map<String,dynamic>;
      setState(() {
        fullnameController.text = data['fullname'];
        profilepic = data['profilepic'];
        emailController.text = data['email'];
        mobilenoController.text = data['mobileno'];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Center(
                    child: obsure == true ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profilepic),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 60,right:2,bottom: 10,top: 70),
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt,color: Colors.lightBlue,),
                            onPressed: () {

                            },),
                        ),
                      ),
                    ) : CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profilepic),
                    )
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(height: 10,),
                Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          enabled: obsure,
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
                          enabled: obsure,
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
                          enabled: obsure,
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
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
