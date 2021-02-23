import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class chatscreen extends StatefulWidget {
  final Email;
  final Chave;

  chatscreen({this.Email, this.Chave});

  @override
  _chatscreenState createState() => _chatscreenState();
}

class _chatscreenState extends State<chatscreen> {
  TextEditingController _mensagem = TextEditingController();

  @override
  Widget build(BuildContext context) {
   // MediaQueryData deviceInfo = MediaQuery.of(context);

    Widget _OrganizaMensagem(documents) {
      return Container(
        child: Card(
          color: Colors.white70,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (documents["Usuario"] != widget.Email)
                  Text(_quebraLinha(documents["msg"])),
                Text(""),
                if (documents["Usuario"] == widget.Email) Text(_quebraLinha(documents["msg"],))
              ],
            ),
          ),
        ),
      );
    }

    Widget _Lista() {
      return Container(
        height: MediaQuery.of(context).size.height - 70,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Mensagens")
              .doc(widget.Chave)
              .collection('Conversa')
              .orderBy("DataEnvio")
              .snapshots(),
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
                child: _OrganizaMensagem(documents[i]),
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
                FirebaseFirestore.instance
                    .collection("Mensagens")
                    .doc(widget.Chave)
                    .collection('Conversa')
                    .add({
                  'msg': _mensagem.text,
                  'Usuario': widget.Email,
                  'DataEnvio': Timestamp.now(),
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
              _Lista(),
              EscreveMensagem(),
            ],
          )),
    );
  }
}

String _quebraLinha(String texto) {
  String resultado = "";
  int i, cont = 0;
  for (i = 0; i < texto.length; i++) {
    cont++;
    if (cont < 36) {
      if (cont == 35 && cont < texto.length) {
        if (texto[i + 1] == " ") {
          resultado = resultado + texto[i];
        } else
          resultado = resultado + texto[i] + "-";
      } else {
        resultado = resultado + texto[i];
      }
    } else {
      resultado = resultado + "\n" + texto[i].trim();
      cont = 0;
    }
  }
  return resultado;
}