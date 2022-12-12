import 'dart:io';

import 'package:catolica_plus_plus/models/certificate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NewCertificatesPage extends StatefulWidget {
  const NewCertificatesPage({Key? key}) : super(key: key);

  @override
  State<NewCertificatesPage> createState() => _NewCertificatesPageState();
}

class _NewCertificatesPageState extends State<NewCertificatesPage> {
  final controllerTitle = TextEditingController();
  final controllerAmountOfHours = TextEditingController();
  final controllerDescription = TextEditingController();
  String? filePath;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future createCertificate(Certificate certificate) async {
    final docCertificate =
        FirebaseFirestore.instance.collection('certificates').doc();
    certificate.id = docCertificate.id;
    final json = certificate.toJson();
    await docCertificate.set(json);
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final user = FirebaseAuth.instance.currentUser;
    final path = 'files/${user?.email}/${DateTime.now().millisecondsSinceEpoch} - ${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    filePath = await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/logo.png',
          height: 52,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: controllerTitle,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Titulo',
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          TextField(
            controller: controllerAmountOfHours,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Quantidade de Horas',
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          TextField(
            controller: controllerDescription,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Descrição (opcional)',
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          const Text('Imagem do Certificado'),
          ElevatedButton(
            onPressed: selectFile,
            child: const Icon(Icons.upload),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controllerTitle.text.isEmpty ||
                  controllerAmountOfHours.text.isEmpty ||
                  pickedFile == null) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Preencha todos os campos obrigatórios'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Voltar'))
                    ],
                  ),
                );
              }
              await uploadFile();
              final certificate = Certificate(
                  title: controllerTitle.text,
                  amountOfHours: double.parse(controllerAmountOfHours.text),
                  description: controllerDescription.text,
                  status: 2,
                  filePath: filePath,
                  userEmail: FirebaseAuth.instance.currentUser?.email
              );
              createCertificate(certificate);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Dados Enviados com Sucesso.'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Voltar'))
                  ],
                ),
              );
            },
            child: const Text('Enviar'),
          ),
          if (pickedFile != null)
            Text('Imagem: ' + pickedFile!.name + ' adicionada com sucesso.')
        ],
      ),
    );
  }
}
