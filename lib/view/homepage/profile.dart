import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:together/utils/global.colors.dart';
import 'package:together/view/login/login.view.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final formKey = GlobalKey<FormState>();
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final mobilenoController = TextEditingController();
  XFile? file;
  final ImagePicker imagePicker = ImagePicker();

  bool obsure = false;

  var fullname = '';
  var profilepic = '';
  var email = '';
  var uid = '';
  var mobileno= '';

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
    final User? user = FirebaseAuth.instance.currentUser;
    final QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('students').where('uid', isEqualTo: user!.uid).get();
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
updateuser() async {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('students');
  final QuerySnapshot userSnapshot = await usersCollection.where('uid', isEqualTo: uid).get();
  final QueryDocumentSnapshot<Object?> userDocId = userSnapshot.docs.first;
  final DocumentReference userDoc = usersCollection.doc(userDocId as String?);
  final Map<String, dynamic> updatedUserData = {
  'name': fullname,
  'email': email,
  };
  userDoc.update(updatedUserData).then((value) => print('updated'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [ obsure == false ?
          SizedBox(
            width: 50,
            child: TextButton(
                onPressed: (){
                  setState(() {
                    obsure = true;
                  });
                },
                child: const Text('Edit',style: TextStyle(color: Colors.blue,fontSize: 18),)),
          ) : TextButton(
            onPressed: () async {
              obsure =false;
              if(formKey.currentState!.validate()){
                setState(() {
                  fullname = fullnameController.text;
                  email = emailController.text;
                  mobileno = mobilenoController.text;
                  updateuser();
                });
              }
            },
            child: const Text('Done',style: TextStyle(color: Colors.blue,fontSize: 18),))
        ],
      ),
      body: SingleChildScrollView(
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
              SizedBox(
                width: 100,
                child: ElevatedButton(onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                  );
                },
                  child: const Text(
                    'Log out',
                    style: TextStyle(fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
