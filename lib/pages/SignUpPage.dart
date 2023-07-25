import 'package:chatapp/models/UserModel.dart';
import 'package:chatapp/pages/CompleteProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();
    if (email == "" || password == "" || cPassword == "") {
      print("Please fill all the feilds");
    } else if (password != cPassword) {
      print("Password Not Match");
    } else {
      signup(email, password);
    }
  }

  void signup(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      print(ex.code.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        fullname: "",
        profilpic: "",
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) => print("New User Created"));
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CompleteProfile(
            userModel: newUser, firebaseUser: credential!.user!);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Chat app',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email Address",
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "PassWord",
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: cPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm PassWord",
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                CupertinoButton(
                    child: Text("Sign Up"),
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      checkValues();
                    }),
              ],
            ),
          ),
        ),
      )),
      bottomNavigationBar: Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Already have an account?",
            style: TextStyle(fontSize: 16.0),
          ),
          CupertinoButton(
              child: Text(
                "Login",
                style: TextStyle(fontSize: 16.0),
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ]),
      ),
    );
  }
}
