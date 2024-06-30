import 'package:flutter/material.dart';
import 'package:news_feed_app/pages/home.dart';
import 'package:news_feed_app/pages/profile.dart';
import 'package:news_feed_app/pages/signup.dart';
import 'package:news_feed_app/services/authentication.dart';
import 'package:news_feed_app/widgets/button.dart';
import 'package:news_feed_app/widgets/snackbar.dart';
import 'package:news_feed_app/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

// email and passowrd auth part
  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    // signup user using our authmethod
    String res = await AuthMethod().loginUser(
        email: emailController.text, password: passwordController.text);

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      //navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      // show error
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height / 2.7,
              child: Image.asset('assets/images/news.png'),
            ),
            TextFieldInput(
                icon: Icons.email,
                textEditingController: emailController,
                hintText: 'Masukkan Email Anda',
                textInputType: TextInputType.text),
            TextFieldInput(
              icon: Icons.lock,
              textEditingController: passwordController,
              hintText: 'Masukkan Password Anda',
              textInputType: TextInputType.text,
              isPass: true,
            ),
            //  we call our forgot password below the login in button
            // const ForgotPassword(),
            MyButtons(onTap: loginUser, text: "Masuk"),

            // const PhoneAuthentication(),
            // Don't have an account? got to signup screen
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Daftar",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Container socialIcon(image) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFedf0f8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black45,
          width: 2,
        ),
      ),
      child: Image.network(
        image,
        height: 40,
      ),
    );
  }
}
