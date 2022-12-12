import 'package:catolica_plus_plus/certificates_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            width: 327,
            height: 197,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromRGBO(144, 11, 64, 1)),
            child: Center(
              child: Text(
                '${CertificatesPage.totalHours}/238h',
                style: TextStyle(fontSize: 48.0, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
