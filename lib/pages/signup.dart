import 'package:flutter/material.dart';
import 'package:news_feed_app/pages/home.dart';
import 'package:news_feed_app/pages/login.dart';
import 'package:news_feed_app/pages/profile.dart';
import 'package:news_feed_app/services/authentication.dart';
import 'package:news_feed_app/widgets/button.dart';
import 'package:news_feed_app/widgets/snackbar.dart';
import 'package:news_feed_app/widgets/text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  void signupUser() async {
    // set is loading to true.
    setState(() {
      isLoading = true;
    });
    // signup user using our authmethod
    String res = await AuthMethod().signupUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text);
    // if string return is success, user has been creaded and navigate to next screen other witse show error.
    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      //navigate to the next screen
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
      body: SafeArea(
          child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height / 2.8,
              child: Image.asset('assets/images/news.png'),
            ),
            TextFieldInput(
                icon: Icons.person,
                textEditingController: nameController,
                hintText: 'Masukkan Nama Anda',
                textInputType: TextInputType.text),
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
            MyButtons(onTap: signupUser, text: "Daftar"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Sudah punya akun?"),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    " Masuk",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
