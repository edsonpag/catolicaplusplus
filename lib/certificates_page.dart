import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'models/certificate.dart';


class CertificatesPage extends StatelessWidget {
  const CertificatesPage({Key? key}) : super(key: key);

  static double totalHours = 0;

  Stream<List<Certificate>> readCertificates() {
    return FirebaseFirestore.instance
        .collection('certificates')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Certificate.fromJson(doc.data())).toList());
  }

  MaterialColor getCurrentColor(int status) {
    if(status == 1) {
      return Colors.green;
    } else if(status == 2) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
  Widget buildCertificates(Certificate certificate) {
      CertificatesPage.totalHours += certificate.amountOfHours;
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: getCurrentColor(certificate.status),
          child: Text('${certificate.amountOfHours}'),
        ),
        title: Text(certificate.title),
        subtitle: Text(certificate.description),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Certificate>>(
        stream: readCertificates(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erro ${snapshot.error}');
          }
          else if(snapshot.hasData) {
            final certificates = snapshot.data!;
            CertificatesPage.totalHours = 0;
            return ListView(
              children: certificates.where((certificate) => certificate.userEmail == FirebaseAuth.instance.currentUser?.email).map(buildCertificates).toList(),
            );
          }
          else {
            return const Center(child: CircularProgressIndicator(),);
          }
        }
      ),
    );
  }
}
