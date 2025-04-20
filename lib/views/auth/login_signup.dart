import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController forgetEmailController = TextEditingController();

  bool isSignUp = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            child: Column(
              children: [
                SizedBox(height: Get.height * 0.08),
                Text(
                  isSignUp ? 'Sign Up' : 'Login',
                  style: GoogleFonts.poppins(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: Get.height * 0.03),
                Text(
                  isSignUp
                      ? 'Welcome, Please Sign up to see events and classes from your friends.'
                      : 'Welcome back, Please Sign in and continue your journey with us.',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Get.height * 0.03),
                Container(
                  width: Get.width * 0.55,
                  child: TabBar(
                    onTap: (v) {
                      setState(() {
                        isSignUp = !isSignUp;
                      });
                    },
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.black,
                    tabs: const [
                      Tab(text: 'Login'),
                      Tab(text: 'Sign Up'),
                    ],
                  ),
                ),
                SizedBox(height: Get.height * 0.04),
                Container(
                  width: Get.width,
                  height: Get.height * 0.6,
                  child: Form(
                    key: formKey,
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        LoginWidget(),
                        SignUpWidget(),
                      ],
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

  Widget LoginWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        buildTextField('Email', emailController, false),
        SizedBox(height: 20),
        buildTextField('Password', passwordController, true),
        SizedBox(height: 10),
        InkWell(
          onTap: () {
            Get.defaultDialog(
              title: 'Forgot Password?',
              content: Column(
                children: [
                  buildTextField('Enter your email...', forgetEmailController, false),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      print("Reset password link sent to ${forgetEmailController.text}");
                    },
                    child: const Text("Send"),
                  )
                ],
              ),
            );
          },
          child: const Text("Forgot password?", style: TextStyle(fontSize: 16)),
        ),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) return;
            print("Logging in with: ${emailController.text}");
          },
          child: const Text("Login"),
        ),
      ],
    );
  }

  Widget SignUpWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildTextField('Full Name', nameController, false),
          SizedBox(height: 20),
          buildTextField('Contact Number', contactController, false),
          SizedBox(height: 20),
          buildTextField('Email', emailController, false),
          SizedBox(height: 20),
          buildTextField('Password', passwordController, true),
          SizedBox(height: 20),
          buildTextField('Confirm Password', confirmPasswordController, true),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              if (passwordController.text != confirmPasswordController.text) {
                Get.snackbar('Error', 'Passwords do not match');
                return;
              }
              print("Signing up with: ${emailController.text}");
            },
            child: const Text("Sign Up"),
          ),
          SizedBox(height: 20),
          Text(
            'By signing up, you agree to our Terms, Data Policy and Cookies Policy.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String hint, TextEditingController controller, bool isObscure) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: hint == 'Contact Number' ? TextInputType.phone : TextInputType.text,
      validator: (input) {
        if (input == null || input.trim().isEmpty) {
          return '$hint is required.';
        }
        if (hint == 'Email' && !input.contains('@')) {
          return 'Enter a valid email.';
        }
        if (hint == 'Contact Number' && !RegExp(r'^[0-9]{10,}$').hasMatch(input)) {
          return 'Enter a valid contact number.';
        }
        if (hint.contains('Password') && input.length < 6) {
          return 'Password must be at least 6 characters.';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
