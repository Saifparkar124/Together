import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:together/utils/global.colors.dart';
import 'package:together/view/forget%20password/forgetpassword.dart';
import 'package:together/view/homepage/homepage.dart';
import 'package:together/view/signup/signup.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool Obsure = true;

  var email = "";
  var password = "";

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                /* Section 1 */
                Center(
                    child: Lottie.asset("assets/login.json",
                        height: size.height * 0.3)),
                Text(
                  "Welcome Back",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
                ),
                /* End */
                /*Section 2*/
                LoginForm(),
                /*End*/

                /*Section 3 */
                const SizedBox(
                  height: 10,
                ),
                signup(),
                /*end*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  Center signup() {
    return Center(
      child: TextButton(
        onPressed: () {
          Get.to(const SignUp());
        },
        // ignore: prefer_const_constructors
        child: Text.rich(TextSpan(
            text: "Don't have an account ",
            style: const TextStyle(color: Colors.black),
            children: const [
              TextSpan(text: "Sign up", style: TextStyle(color: Colors.blue))
            ])),
      ),
    );
  }

  Form LoginForm() {
    return Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
          ),
          child: Column(
            children: [
              /**/
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: "Email id",
                  hintText: "Email id",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Email Id';
                  } else if (!value.contains('@')) {
                    return 'Please Enter Valid Email Id';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  labelText: "Password",
                  hintText: "Password",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          Obsure = !Obsure;
                        });
                      },
                      icon: Icon(
                          Obsure ? Icons.visibility : Icons.visibility_off)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                controller: passwordController,
                obscureText: Obsure,
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      /*Forget Password code*/
                      Get.to(ForgetPassword());
                    },
                    child: const Text("Forget Password")),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: (() {
                      /*Login Button Pressed*/
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          email = emailController.text;
                          password = passwordController.text;
                          signIn();
                        });
                      }
                    }),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: GlobalColors.mainColor),
                    child: Text(
                      "Login".toUpperCase(),
                    )),
              )
            ],
          ),
        ));
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      Get.to(HomePage());
      clearText();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void clearText() {
    emailController.clear();
    passwordController.clear();
  }
}
