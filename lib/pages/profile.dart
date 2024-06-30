import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_feed_app/pages/landing_page.dart';
import 'package:news_feed_app/services/authentication.dart';
import 'package:news_feed_app/widgets/bottom_nav_bar.dart';
import 'package:news_feed_app/widgets/button.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  static const routeName = '/profile';

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _getUserName();
  }

  Future<void> _getUserName() async {
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      setState(() {
        userName = userDoc['name'];
        userEmail = userDoc['email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo-nama.png',
              height: 40.0,
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      bottomNavigationBar: const BottomNavBar(index: 2),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const Text(
              "Profil Anda",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            itemProfile('Nama', '$userName', Icons.person),
            const SizedBox(height: 10),
            itemProfile('Email', '$userEmail', Icons.mail),
            const SizedBox(
              height: 20,
            ),
            MyButtons(
                onTap: () async {
                  await AuthMethod().signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LandingPage(),
                    ),
                  );
                },
                text: "Keluar"),
          ],
        ),
      ),
    );
  }

  itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                color: Colors.black.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10)
          ]),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        tileColor: Colors.white,
      ),
    );
  }
}
