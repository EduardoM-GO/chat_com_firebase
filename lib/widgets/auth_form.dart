import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_com_firebase/screen/chatscreen.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  TextEditingController _nome = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _senha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nome',
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                    ),
                    controller: _email,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                    ),
                    controller: _senha,
                  ),
                  SizedBox(height: 12),
                  RaisedButton(
                    child: Text('Entrar'),
                    onPressed: () async {
                      int i = 0;
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                                email: _email.text, password: _senha.text);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('Nenhum usuário encontrado para esse e-mail.');
                        } else if (e.code == 'wrong-password') {
                          print('Senha errada fornecida para esse usuário.');
                        }
                        i = 1;
                      }
                      if (i == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen()));
                      }
                    },
                  ),
                  FlatButton(
                    child: Text('Criar uma nova conta?'),
                    onPressed: () async {
                      int i = 0;
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                                email: _email.text, password: _senha.text);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                        i = 1;
                      }
                      if (i == 0) {
                        print("Registrou!");
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
