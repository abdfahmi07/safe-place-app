import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:safe_place_app/view/layouts/admin/admin_bottom_navbar_layout.dart';
import 'package:safe_place_app/view/layouts/user/user_bottom_navbar_layout.dart';
import 'package:safe_place_app/model/user_model.dart';
import 'package:safe_place_app/view/screens/auth/register_screen.dart';
import 'package:safe_place_app/view_model/auth/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    Future<void> handleLogin() async {
      try {
        final UserModel userData =
            await loginViewModel.signInWithEmailAndPassword();

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: ((context) => userData.role == 'admin'
                      ? const AdminBottomNavbarLayout(
                          page: 0,
                          appBarTitle: 'Safe Place',
                        )
                      : const UserBottomNavbarLayout(
                          page: 0,
                          appBarTitle: 'Safe Place',
                        ))),
              (route) => false);
        }
      } catch (err) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(err.toString())));
        }
      }
    }

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ListView(
            children: [
              const _HeaderLogin(),
              const SizedBox(height: 40),
              Form(
                  key: loginViewModel.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: loginViewModel.emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 20, right: 10),
                              child: Icon(Iconsax.tag_user,
                                  color: Color(0xFFE6984C)),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1.5, color: Color(0xFFF0F5F8))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1.5, color: Color(0xFFE6984C))),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1.5, color: Colors.redAccent)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.redAccent)),
                            contentPadding: const EdgeInsets.all(20),
                            hintText: 'Email Address',
                            hintStyle: const TextStyle(
                                color: Color(0xFFAEABBB),
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                            errorMaxLines: 3),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: loginViewModel.passwordController,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(fontSize: 14),
                        obscureText: true,
                        decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 20, right: 10),
                              child:
                                  Icon(Iconsax.lock, color: Color(0xFFE6984C)),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1.5, color: Color(0xFFF0F5F8))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1.5, color: Color(0xFFE6984C))),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1.5, color: Colors.redAccent)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.redAccent)),
                            contentPadding: const EdgeInsets.all(20),
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                                color: Color(0xFFAEABBB),
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                            errorMaxLines: 3),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color(0xFFF2AC66),
                                ),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                            onPressed: handleLogin,
                            child: const Text('Sign In',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                      ),
                      const SizedBox(height: 20),
                      Text.rich(
                          style: const TextStyle(fontSize: 12),
                          TextSpan(text: "Don't have an account? ", children: [
                            TextSpan(
                                text: 'Sign up',
                                style:
                                    const TextStyle(color: Color(0xFFE6984C)),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const RegisterScreen()));
                                  })
                          ]))
                    ],
                  ))
            ],
          )),
    );
  }
}

class _HeaderLogin extends StatelessWidget {
  const _HeaderLogin();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 200),
        Text("Welcome back.",
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.bold,
              fontSize: 26,
            )),
        const SizedBox(height: 5),
        Text("Sign in to your account",
            style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.w500, color: Colors.black45))
      ],
    );
  }
}
