import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  TextEditingController _mensagem = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);

    Widget Lista() {
      return Container(
        height: MediaQuery.of(context).size.height - 70,
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("Mensagens").orderBy("createdAt").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = snapshot.data.docs;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: documents.length,
              itemBuilder: (ctx, i) => Container(
                padding: EdgeInsets.all(8),
                child: Text(documents[i]['msg']),
              ),
            );
          },
        ),
      );
    }

    Widget EscreveMensagem() {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: "Mensagem",
            labelStyle: TextStyle(
              color: Colors.blue,
            ),
            suffix: GestureDetector(
              child: Icon(
                Icons.send,
                color: Colors.blueAccent,
              ),
              onTap: () {
                FirebaseFirestore.instance.collection("Mensagens").add({
                  'msg': _mensagem.text,
                  'Usuario': "Eduardo",
                  'createdAt': Timestamp.now(),
                });
                _mensagem.text = "";
              },
            ),
          ),
          controller: _mensagem,
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.black, fontSize: 20.0),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Lista(),
              EscreveMensagem(),
            ],
          )),
    );
  }
}
