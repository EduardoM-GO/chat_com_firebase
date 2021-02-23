import 'package:cloud_firestore/cloud_firestore.dart';
/*import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';*/
import 'package:flutter/material.dart';
import 'package:chat_com_firebase/widgets/chatscreen.dart';

class conversa_form extends StatefulWidget {
  final Email;

  conversa_form({this.Email});

  @override
  _conversa_formState createState() => _conversa_formState();
}

class _conversa_formState extends State<conversa_form> {
  TextEditingController _contato = TextEditingController();

  Widget _listaConversa(documents, int i) {
    return Container(
      child: GestureDetector(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                /*Container(
                  width: 80.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: documents[i]["Imagem"] != null
                            ? Image.network(documents[i]["Imagem"]).image
                            : AssetImage("Imagem/Padrao.png"),
                        fit: BoxFit.cover),
                  ),
                ),*/
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Nome: " + documents[i]["Nome"],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => chatscreen(
                        Email: widget.Email,
                        Chave: documents[i]["Chave"],
                      )));
        },
      ),
    );
  }

  Widget _lista() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Usuario')
            .doc(widget.Email)
            .collection('Conversas')
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
              child: _listaConversa(documents, i),
            ),
          );
        },
      ),
    );
  }

  Widget _AddContato() {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      title: Text("Adicionar uma nova Conversa"),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: 'Email:', hintText: 'Teste@gmail.com'),
              controller: _contato,
            ),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text("Cancelar"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("Add"),
          onPressed: () {
            Salvacontato();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void Salvacontato() {
    FirebaseFirestore.instance
        .collection("Mensagens")
        .doc(widget.Email + _contato.text)
        .collection('Conversa')
        .add({});
    FirebaseFirestore.instance
        .collection("Usuario")
        .doc(widget.Email)
        .collection('Conversas')
        .add({"Chave": widget.Email + _contato.text, "Nome": _contato.text});
    FirebaseFirestore.instance
        .collection("Usuario")
        .doc(_contato.text)
        .collection('Conversas')
        .add({"Chave": widget.Email + _contato.text, "Nome": widget.Email});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[_lista()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return _AddContato();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
