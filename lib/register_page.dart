import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_data_and_display/components/my_button.dart';

import 'components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // text editing contrillers
  final emailnameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final contactController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void disponse() {
    nameController.dispose();
    contactController.dispose();
    emailnameController.dispose();
    super.dispose();
  }

  //validation for contact
  bool validateContact(String contact) {
    final RegExp phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(contact);
  }

  // sign user up mehtod
  Future<void> signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      if (confirmPasswordController.text == passwordController.text) {
        if (validateContact(contactController.text.trim())) {
          final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailnameController.text,
            password: passwordController.text,
          );

          await addUserDetails(
            nameController.text.trim(),
            emailnameController.text.trim(),
            int.parse(contactController.text.trim()),
          );

          Navigator.pop(context);
          // Perform any post-registration actions here
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Contact Number is Wrong'),
              duration: Duration(seconds: 3), // Duration for which the SnackBar is visible
              backgroundColor: Colors.blue, // Background color
            ),
          );
        }
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password is Descent Match'),
            duration: Duration(seconds: 3), // Duration for which the SnackBar is visible
            backgroundColor: Colors.blue, // Background color
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.code),
          duration: Duration(seconds: 3), // Duration for which the SnackBar is visible
          backgroundColor: Colors.blue, // Background color
        ),
      );
    }
  }


  Future<void> addUserDetails(String name, String email, int contact) async {
    await FirebaseFirestore.instance.collection("passengers").add({
      'name': name,
      'contact': contact,
      'email': email,
    });
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),

            //icon image
            Container(
              margin: EdgeInsets.only(right: 10, top: 10, left: 10, bottom: 10),
              child: Image.asset('lib/images/logo.jpg' ,),
              height: 80,
              width: 120,
            ),

            Text(
              'Let\'s create an account for you',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Container(
              height: 740,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
                color: Color(0xFFEBDEF0),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),

                    Container(
                      margin: EdgeInsets.only(right: 10, top: 20, left: 10),
                      child: const Text(
                        "REGISTER FOR PASSENGER",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // Name feild
                    MyTextField(
                        controller: nameController,
                        hintText: 'Name',
                        obscureText: false),

                    const SizedBox(
                      height: 10,
                    ),

                    // Contact feild
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                        controller: contactController,
                        obscureText: false,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Contact',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        ),
                        validator: (value) {
                          if (!validateContact(value!)) {
                            return 'Invalid contact number';
                          }
                          return null;
                        }, // Pass the validator function here
                      ),
                    ),


                    const SizedBox(
                      height: 10,
                    ),

                    MyTextField(
                        controller: emailnameController,
                        hintText: 'Email',
                        obscureText: false),

                    const SizedBox(
                      height: 10,
                    ),

                    // password textfield
                    MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true),

                    const SizedBox(
                      height: 10,
                    ),

                    MyTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: true),

                    const SizedBox(
                      height: 10,
                    ),
                    // forgot password?

                    // sign in button
                    MyButton(
                      text: "Sign In",
                      onTop: signUserUp,
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // or continue with
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[800],
                              thickness: 0.5,
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[800],
                              thickness: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // not a member? register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have Account?',
                          style: TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(
                          width: 4,
                        ),

                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'Login Now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
